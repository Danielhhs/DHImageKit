//
//  DHImageEditor.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageEditor.h"
#import "DHRadialTiltShiftFilter.h"
#import "DHLinearTiltShiftFilter.h"
#import "DHImageHelper.h"
#import "DHImageColorFilter.h"
#import "DHImageRotateFilter.h"
#import "DHImageNormalFilter.h"

static DHImageEditor *sharedInstance;

@interface DHImageEditor () {
    dispatch_queue_t imageProcessingQ;
}
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) GPUImageFilterGroup *filterGroup;
@property (nonatomic, strong) DHImageFilter *dhFilter;
@property (nonatomic, weak) id<GPUImageInput> renderTarget;
@property (nonatomic, strong) DHImageNormalFilter *normalFilter;

//Status keeper
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *currentFilter;
@property (nonatomic) DHImageEditComponent currentComponent;
@property (nonatomic) DHImageEidtComponentSubType currentSubType;
@property (nonatomic) NSMutableDictionary *initialParams;
@property (nonatomic) NSMutableDictionary *intermediateParams;
@property (nonatomic) BOOL isCurrentFilterANewFilter;
@property (nonatomic) CGFloat initialStrength;

//Adjustment filter
@property (nonatomic) CGPoint accumulatedTranslation;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval elapsedTime;

@end

@implementation DHImageEditor

#pragma mark - Initialization
- (void) initiateEditorWithImage:(UIImage *)image
                    renderTarget:(id<GPUImageInput>)renderTarget
                      completion:(void (^)(BOOL))completion
{
    self.renderTarget = renderTarget;
    self.dhFilter = nil;
    dispatch_sync(imageProcessingQ, ^{
        self.picture = [[GPUImagePicture alloc] initWithImage:image];
        self.filterGroup = [[GPUImageFilterGroup alloc] init];
        DHImageNormalFilter *filter = [[DHImageNormalFilter alloc] init];
        [self startProcessingWithDHFilter:filter];
        if (completion) {
            completion(YES);
        }
    });
}

- (void) initiateEditorWithImageURL:(NSURL *)imageURL
                       renderTarget:(id<GPUImageInput>)renderTarget
                         completion:(void (^)(BOOL))complection
{
    UIImage *image = [UIImage imageWithContentsOfFile:[imageURL path]];
    if (image == nil) {
        if (complection) {
            complection(NO);
        }
    } else {
        [self initiateEditorWithImage:image renderTarget:renderTarget completion:complection];
    }
}

- (BOOL) imageModified
{
    BOOL hasIFFilter =  ![self.dhFilter isKindOfClass:[DHImageNormalFilter class]];
    BOOL hasComponentFilter = ([self.filterGroup filterCount] > 1);
    if (hasIFFilter || hasComponentFilter) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Start Processing
- (void) startProcessingWithDHFilter:(DHImageFilter *)filter
{
    if (self.dhFilter) {
        [self _replaceFilter:self.dhFilter withFilter:filter];
    } else {
        [self _addFilter:filter];
    }
    self.dhFilter = filter;
    [self _processImage];
}

- (void) startProcessingComponent:(DHImageEditComponent)component
{
    [self startProcessingComponent:component subComponent:DHImageEidtComponentSubTypeNone];
}

- (void) startProcessingComponent:(DHImageEditComponent)component
                     subComponent:(DHImageEidtComponentSubType)subType
{
    [self showProcessedImage];
    self.currentComponent = component;
    self.currentSubType = subType;
    [self.initialParams removeAllObjects];
    self.initialParams = [NSMutableDictionary dictionary];
    GPUImageOutput<GPUImageInput> *existingFilter = [DHImageHelper filterOfComponent:component
                                                                             subType:subType
                                                                       inFilterGroup:self.filterGroup];
    NSArray *parameters = [DHImageHelper parametersForComponent:component subType:subType];
    if (existingFilter) {
        self.currentFilter = existingFilter;
        for (NSString *parameter in parameters) {
            self.initialParams[parameter] = [self.currentFilter valueForKey:parameter];
        }
        self.isCurrentFilterANewFilter = NO;
    } else {
        self.isCurrentFilterANewFilter = YES;
        Class filterClass = [DHImageHelper filterClassForComponent:component subType:subType];
        GPUImageOutput<GPUImageInput> *filter = [[filterClass alloc] init];
        if (component == DHImageEditComponentAjust) {
            DHImageRotateFilter *rotateFilter = (DHImageRotateFilter *)filter;
            rotateFilter.ignoreAspectRatio = YES;
            self.initialParams[@"rotation"] = @(0.f);
        } else if (component == DHImageEditComponentColor) {
            self.initialParams[@"color"] = [UIColor whiteColor];
            self.initialParams[@"strength"] = @(0.f);
        }else {
            DHImageEditorValues values = [DHImageHelper valuesforComponent:component];
            self.initialParams[[parameters lastObject]] = @(values.initialValue);
        }
        self.currentFilter = filter;
        [self saveInterMediateState];
        [self _addFilter:self.currentFilter];
    }
    dispatch_async(imageProcessingQ, ^{
        NSString *parameter = [DHImageHelper parameterForUpdateForComponent:component subType:subType];
        [self updateWithInput:[self.initialParams[parameter] doubleValue]];
    });
}

#pragma mark - Finish Processing
- (void) finishProcessingCurrentComponent
{
    [self _resetStatus];
}

- (void) cancelProcessingCurrentComponent
{
    if (self.isCurrentFilterANewFilter) {
        [self _removeFilter:self.currentFilter];
    } else {
        NSArray *parameters = [DHImageHelper parametersForComponent:self.currentComponent subType:self.currentSubType];
        for (NSString *parameter in parameters) {
            [self.currentFilter setValue:self.initialParameters[parameter] forKey:parameter];
        }
    }
    [self _processImage];
    [self _resetStatus];
}

- (void) finishProcessingImage
{
    [self _clearup];
}

#pragma mark - Get Current Parameter
- (NSDictionary *) initialParameters
{
    return [self.initialParams copy];
}

- (void) saveInterMediateState
{
    self.intermediateParams = [NSMutableDictionary dictionary];
    NSArray *params = [DHImageHelper parametersForComponent:self.currentComponent subType:self.currentSubType];
    for (NSString *param in params) {
        self.intermediateParams[param] = [self.currentFilter valueForKey:param];
    }
}

- (NSDictionary *) intermediateParameters
{
    return [self.intermediateParams copy];
}

- (void) restoreIntermediateState
{
    if (self.intermediateParams) {
        NSArray *params = [DHImageHelper parametersForComponent:self.currentComponent subType:self.currentSubType];
        for (NSString *param in params) {
            [self.currentFilter setValue:self.intermediateParams[param] forKey:param];
        }
        [self _processImage];
    }
}

#pragma mark - Update DHImageFilter
- (void) updateDHFilterWithStrength:(CGFloat)strength
{
    dispatch_async(imageProcessingQ, ^{
        [self.dhFilter updateWithStrength:strength];
        [self _processImage];
    });
}

- (CGFloat) currentDHFilterStrength
{
    return self.dhFilter.strength;
}

- (void) startUpdatingStrengthForDHImageFilter
{
    self.initialStrength = self.dhFilter.strength;
}

- (void) cancelUpdatingStrengthForDHImageFilter
{
    [self updateDHFilterWithStrength:self.initialStrength];
}

#pragma mark - Update
- (void) updateWithInput:(CGFloat)inputValue
{
    dispatch_async(imageProcessingQ, ^{
        if (self.currentComponent == DHImageEditComponentColor) {
            [self.currentFilter setValue:@(inputValue) forKey:@"strength"];
        } else {
            NSArray *parameters = [DHImageHelper parametersForComponent:self.currentComponent subType:DHImageEidtComponentSubTypeNone];
            [self.currentFilter setValue:@(inputValue) forKey:[parameters firstObject]];
        }
        [self _processImage];
    });
}

- (void) updateWithColor:(UIColor *)color
{
    if ([self.currentFilter isKindOfClass:[DHImageColorFilter class]]) {
        DHImageColorFilter *colorFilter = (DHImageColorFilter *)self.currentFilter;
        colorFilter.color = color;
        [self _processImage];
    }
}

- (void) removeColorFilter
{
    GPUImageOutput<GPUImageInput> *filter = [DHImageHelper filterOfComponent:DHImageEditComponentColor
                                                                     subType:DHImageEidtComponentSubTypeNone
                                                               inFilterGroup:self.filterGroup];
    if ([filter isKindOfClass:[DHImageColorFilter class]]) {
        DHImageColorFilter *rgbFilter = (DHImageColorFilter *)filter;
        rgbFilter.color = [UIColor whiteColor];
    }
    [self _processImage];
}

#pragma mark - Tilt Shift Input
- (void) startProcessingTiltShiftWithSubType:(DHImageEidtComponentSubType)subtype
{
    [self showProcessedImage];
    self.currentComponent = DHImageEditComponentTiltShift;
    self.currentSubType = subtype;
    [self.initialParams removeAllObjects];
    self.initialParams = [NSMutableDictionary dictionary];
    GPUImageOutput<GPUImageInput> *existingFilter = [DHImageHelper filterOfComponent:DHImageEditComponentTiltShift
                                                                             subType:subtype
                                                                       inFilterGroup:self.filterGroup];
    NSArray *parameters = [DHImageHelper parametersForComponent:DHImageEditComponentTiltShift subType:subtype];
    if (existingFilter) {
        self.currentFilter = existingFilter;
        for (NSString *parameter in parameters) {
            self.initialParams[parameter] = [self.currentFilter valueForKey:parameter];
        }
        self.isCurrentFilterANewFilter = NO;
        DHTiltShiftFilter *tiltShiftFilter = (DHTiltShiftFilter *)self.currentFilter;
        [tiltShiftFilter hideMaskForPicture:self.picture duration:0.5];
    } else {
        GPUImageOutput<GPUImageInput> *otherFilter = nil;
        if (subtype == DHTiltShiftSubTypeRadial) {
            DHRadialTiltShiftFilter *tiltShiftFilter = [[DHRadialTiltShiftFilter alloc] init];
            [tiltShiftFilter setFocusFallOffRate:0.2];
            [tiltShiftFilter setCenter:CGPointMake(0.5, 0.5)];
            [tiltShiftFilter setRadius:0.5];
            self.initialParams[@"center"] = [NSValue valueWithCGPoint:tiltShiftFilter.center];
            self.initialParams[@"radius"] = @(tiltShiftFilter.radius);
            otherFilter = [DHImageHelper filterOfComponent:DHImageEditComponentTiltShift subType:DHTiltShiftSubTypeLinear inFilterGroup:self.filterGroup];
            self.currentFilter = tiltShiftFilter;
            self.isCurrentFilterANewFilter = YES;
        } else if (subtype == DHTiltShiftSubTypeLinear) {
            DHLinearTiltShiftFilter *tiltShiftFilter = [[DHLinearTiltShiftFilter alloc] init];
            [tiltShiftFilter setCenter:0.5];
            [tiltShiftFilter setRange:0.1];
            [tiltShiftFilter setFocusFallOffRate:0.3];
            self.initialParams[@"center"] =  @(tiltShiftFilter.center);
            otherFilter = [DHImageHelper filterOfComponent:DHImageEditComponentTiltShift subType:DHTiltShiftSubTypeRadial inFilterGroup:self.filterGroup];
            self.currentFilter = tiltShiftFilter;
            self.isCurrentFilterANewFilter = YES;
        } else {
            self.isCurrentFilterANewFilter = NO;
            return;
        }
        [self saveInterMediateState];
        if (otherFilter == nil) {
            [self _addFilter:self.currentFilter];
        } else {
            [self _replaceFilter:otherFilter withFilter:self.currentFilter];
        }
        [self _processImage];
        DHTiltShiftFilter *tiltShiftFilter = (DHTiltShiftFilter *) self.currentFilter;
        dispatch_async(dispatch_get_main_queue(), ^{
            [tiltShiftFilter hideMaskForPicture:self.picture duration:0.5];
        });
    }
}

- (void) startLinearTiltShiftInputWithValue:(CGFloat)value
{
    if ([self.currentFilter isKindOfClass:[DHLinearTiltShiftFilter class]]) {
        DHLinearTiltShiftFilter *filter = (DHLinearTiltShiftFilter *)self.currentFilter;
        [filter setCenter:value];
        [filter showMaskForPicture:self.picture];
    }
}

- (void) finishLinearTiltShiftInputWithValue:(CGFloat)value
{
    if ([self.currentFilter isKindOfClass:[DHLinearTiltShiftFilter class]]) {
        DHLinearTiltShiftFilter *filter = (DHLinearTiltShiftFilter *)self.currentFilter;
        [filter hideMaskForPicture:self.picture
                          duration:0.3];
    }
}

- (void) startRadialTiltShiftInputWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    if ([self.currentFilter isKindOfClass:[DHRadialTiltShiftFilter class]]) {
        DHRadialTiltShiftFilter *filter = (DHRadialTiltShiftFilter *)self.currentFilter;
        [filter setCenter:center];
        [filter setRadius:radius];
        [filter showMaskForPicture:self.picture];
    }
}

- (void) finishRadialTiltShiftInputWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    if ([self.currentFilter isKindOfClass:[DHRadialTiltShiftFilter class]]) {
        DHRadialTiltShiftFilter *filter = (DHRadialTiltShiftFilter *)self.currentFilter;
        [filter hideMaskForPicture:self.picture duration:0.3];
    }
}

- (void) updateWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    if ([self.currentFilter isKindOfClass:[DHRadialTiltShiftFilter class]]) {
        DHRadialTiltShiftFilter *filter = (DHRadialTiltShiftFilter *)self.currentFilter;
        [filter setCenter:center];
        [filter setRadius:radius];
        [self _processImage];
    }
}

- (void) removeTiltShiftFilter
{
    [self _removeFilter:self.currentFilter];
    [self _processImage];
}

#pragma mark - ShowImage
- (void) showOriginalImage
{
    [self.picture removeAllTargets];
    [self.currentFilter removeAllTargets];
    [self.picture addTarget:self.renderTarget];
    [self.picture processImage];
}

- (void) showProcessedImage
{
    [self _processImage];
}

- (UIImage *) processedImage
{
    [self.filterGroup removeAllTargets];
    [self.picture useNextFrameForImageCapture];
    [self.filterGroup useNextFrameForImageCapture];
    [self.picture processImage];
    return [self.filterGroup imageFromCurrentFramebuffer];
}

- (void) _printFilterChain
{
    NSLog(@"picture targets: %@", [self.picture targets]);
    NSLog(@"filter group targets: %@", [self.filterGroup targets]);
    for (int i = 0; i < [self.filterGroup filterCount]; i++) {
        NSLog(@"FIlter[%d] = %@, targets = %@", i, [self.filterGroup filterAtIndex:i], [[self.filterGroup filterAtIndex:i] targets]);
    }
}

#pragma mark - Adjustment
- (void) startUpdatingImageWithTranslation:(CGPoint)translation
{
    if (self.currentComponent == DHImageEditComponentAjust) {
        self.accumulatedTranslation = translation;
        [self updateImageWithTranslation:translation];
    }
}

- (void) updateImageWithTranslation:(CGPoint)translation
{
    if ([self.currentFilter isKindOfClass:[DHImageRotateFilter class]]) {
        CGPoint accuTrans = self.accumulatedTranslation;
        accuTrans.x += translation.x;
        accuTrans.y += translation.y;
        self.accumulatedTranslation = accuTrans;
        GPUImageTransformFilter *filter = (DHImageRotateFilter *)self.currentFilter;
        CGPoint realTranslation = [self _adjustTranslationForCurrentRotation:translation];
        CGAffineTransform transform = CGAffineTransformTranslate(filter.affineTransform, realTranslation.x, realTranslation.y);
        filter.affineTransform = transform;
        [self _processImage];
    }
}

- (void) resetTransformFilter
{
    if ([self.currentFilter isKindOfClass:[GPUImageTransformFilter class]]) {
        GPUImageTransformFilter *filter = (GPUImageTransformFilter *)self.currentFilter;
        filter.affineTransform = CGAffineTransformIdentity;
        [self _processImage];
    }
}

- (void) moveToFullVisibleImage
{
    if ([self.currentFilter isKindOfClass:[GPUImageTransformFilter class]]) {
        self.elapsedTime = 0;
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTranslation:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void) updateTranslation:(CADisplayLink *)displayLink
{
    self.elapsedTime += self.displayLink.duration;
    if (self.elapsedTime < 0.2) {
        CGFloat percent = self.elapsedTime / 0.2;
        CGPoint translation;
        translation.x = (1.f - percent) * self.accumulatedTranslation.x;
        translation.y = (1.f - percent) * self.accumulatedTranslation.y;
        GPUImageTransformFilter *filter = (GPUImageTransformFilter *)self.currentFilter;
        CGAffineTransform transform = filter.affineTransform;
        CGFloat scale = [DHImageHelper CGAffineTransformGetScaleX:transform];
        CGFloat rotate = [DHImageHelper CGAffineTransformGetRotation:transform];
        CGAffineTransform finalTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, translation.x, translation.y);
        finalTransform = CGAffineTransformScale(finalTransform, scale, scale);
        finalTransform = CGAffineTransformRotate(finalTransform, rotate);
        filter.affineTransform = finalTransform;
        [self _processImage];
    } else {
        GPUImageTransformFilter *filter = (GPUImageTransformFilter *)self.currentFilter;
        CGAffineTransform transform = filter.affineTransform;
        CGFloat scale = [DHImageHelper CGAffineTransformGetScaleX:transform];
        CGFloat rotate = [DHImageHelper CGAffineTransformGetRotation:transform];
        CGAffineTransform finalTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        finalTransform = CGAffineTransformScale(finalTransform, scale, scale);
        finalTransform = CGAffineTransformRotate(finalTransform, rotate);
        filter.affineTransform = finalTransform;
        [self _processImage];
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.elapsedTime = 0;
    }
}

#pragma mark - Tilt Shift
- (DHImageEidtComponentSubType) subTypeForExistingTiltShiftFilter
{
    GPUImageOutput<GPUImageInput> *filter = [DHImageHelper filterOfComponent:DHImageEditComponentTiltShift
                                                                     subType:DHImageEidtComponentSubTypeNone
                                                               inFilterGroup:self.filterGroup];
    if ([filter isKindOfClass:[DHLinearTiltShiftFilter class]]) {
        return DHTiltShiftSubTypeLinear;
    } else if ([filter isKindOfClass:[DHRadialTiltShiftFilter class]]) {
        return DHTiltShiftSubTypeRadial;
    } else {
        return DHImageEidtComponentSubTypeNone;
    }
}

#pragma mark - Private Helpers
- (void) _addFilter:(GPUImageOutput <GPUImageInput> *)filter
{
    [self.filterGroup removeAllTargets];
    [self.filterGroup addFilter:filter];
    if ([self.filterGroup filterCount] == 1) {
        self.filterGroup.initialFilters = @[filter];
        self.filterGroup.terminalFilter = filter;
    } else {
        GPUImageOutput<GPUImageInput> *currentTerminal = [self.filterGroup terminalFilter];
        NSArray *initialFilters = [self.filterGroup initialFilters];
        [currentTerminal addTarget:filter];
        self.filterGroup.terminalFilter = filter;
        self.filterGroup.initialFilters = @[[initialFilters firstObject]];
    }
    [self.picture removeAllTargets];
    [self.picture addTarget:self.filterGroup];
    [self.filterGroup addTarget:self.renderTarget];
}

- (void) _clearup
{
    [self _resetStatus];
    [_picture removeAllTargets];
    _picture = nil;
    [_filterGroup removeAllTargets];
    _filterGroup = nil;
    _renderTarget = nil;
}

- (void) _resetStatus
{
    _currentFilter = nil;
    _currentSubType = DHImageEidtComponentSubTypeNone;
    _currentComponent = DHImageEditComponentNone;
    [_initialParams removeAllObjects];
    _initialParams = nil;
    [_intermediateParams removeAllObjects];
    _intermediateParams = nil;
}

- (void) _processImage
{
    [self.picture removeAllTargets];
    [self.filterGroup removeAllTargets];
    if ([self.filterGroup filterCount] == 0) {
        [self.picture addTarget:self.renderTarget];
    } else {
        [self.picture addTarget:self.filterGroup];
        [self.filterGroup addTarget:self.renderTarget];
    }
    [self.picture processImage];
}

- (void) _removeFilter:(GPUImageOutput<GPUImageInput> *)filterToRemove
{
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    GPUImageFilterGroup *previousFilterGroup = self.filterGroup;
    self.filterGroup = filterGroup;
    for (int i = 0; i < [previousFilterGroup filterCount]; i++) {
        GPUImageOutput<GPUImageInput> *filter = [previousFilterGroup filterAtIndex:i];
        if (![filter isEqual:filterToRemove]) {
            [self _addFilter:filter];
        }
    }
    [previousFilterGroup removeAllTargets];
}

- (void) _replaceFilter:(GPUImageOutput<GPUImageInput> *)filterToRemove
             withFilter:(GPUImageOutput<GPUImageInput> *)newFilter
{
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    GPUImageFilterGroup *previousFilterGroup = self.filterGroup;
    self.filterGroup = filterGroup;
    for (int i = 0; i < [previousFilterGroup filterCount]; i++) {
        GPUImageOutput<GPUImageInput> *filter = [previousFilterGroup filterAtIndex:i];
        if (![filter isEqual:filterToRemove]) {
            [self _addFilter:filter];
        } else {
            [self _addFilter:newFilter];
        }
    }
    [previousFilterGroup removeAllTargets];
}

- (CGPoint) _adjustTranslationForCurrentRotation:(CGPoint) translation
{
    GPUImageTransformFilter *filter = (DHImageRotateFilter *)self.currentFilter;
    CGFloat rotation = [DHImageHelper CGAffineTransformGetRotation:filter.affineTransform];
    while (rotation > M_PI / 4 || rotation < -M_PI / 4 * 7) {
        if (rotation > M_PI / 4) {
            rotation -= M_PI * 2;
        } else {
            rotation += M_PI * 2;
        }
    }
    CGPoint realTranslation = translation;
    if (rotation <= -M_PI / 4 && rotation > -M_PI / 4 * 3) {
        realTranslation.x = -translation.y;
        realTranslation.y = translation.x;
    } else if (rotation <= -M_PI / 4 * 3 && rotation > -M_PI / 4 * 5) {
        realTranslation.x = -translation.x;
        realTranslation.y = -translation.y;
    } else if (rotation <= -M_PI / 4 * 5 && rotation > -M_PI / 4 * 7) {
        realTranslation.x = translation.y;
        realTranslation.y = -translation.x;
    }
    return realTranslation;
}

#pragma mark - Singleton
+ (DHImageEditor *) sharedEditor
{
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[DHImageEditor alloc] init];
        });
    }
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        imageProcessingQ = dispatch_queue_create("cn.danielhhs.image_processing", NULL);
        _initialParams = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id) copy
{
    return self;
}

@end
