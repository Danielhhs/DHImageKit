//
//  DHTiltShiftFilter.m
//  DHChat
//
//  Created by 黄鸿森 on 2017/7/19.
//  Copyright © 2017年 lindved. All rights reserved.
//

#import "DHTiltShiftFilter.h"

#define DH_LINEAR_TILT_SHIFT_ANIMATION_DURATION 0.2

@interface DHTiltShiftFilter ()
@property (nonatomic, weak) GPUImagePicture *picture;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSInteger extraCount;
@property (nonatomic) NSTimeInterval duration;
@end


@implementation DHTiltShiftFilter

@synthesize blurRadiusInPixels;
@synthesize focusFallOffRate = _focusFallOffRate;

- (instancetype) init
{
    self = [super init];
    if (self) {
        
        // First pass: apply a variable Gaussian blur
        blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [self addFilter:blurFilter];
        
        // Second pass: combine the blurred image with the original sharp one
        tiltShiftFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:[self tiltShiftFilterFragmentShaderString]];
        [self addFilter:tiltShiftFilter];
        
        // Texture location 0 needs to be the sharp image for both the blur and the second stage processing
        [blurFilter addTarget:tiltShiftFilter atTextureLocation:1];
        
        // To prevent double updating of this filter, disable updates from the sharp image side
        //    self.inputFilterToIgnoreForUpdates = tiltShiftFilter;
        
        self.initialFilters = [NSArray arrayWithObjects:blurFilter, tiltShiftFilter, nil];
        self.terminalFilter = tiltShiftFilter;
        self.focusFallOffRate = 0.2;
        self.blurRadiusInPixels = 5.0;
    }
    return self;
}

#pragma mark - Accessors
- (void)setBlurRadiusInPixels:(CGFloat)newValue;
{
    blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels;
{
    return blurFilter.blurRadiusInPixels;
}


- (void) setMaskAlpha:(CGFloat)maskAlpha
{
    _maskAlpha = maskAlpha;
    [tiltShiftFilter setFloat:maskAlpha forUniformName:@"maskAlpha"];
}

- (void)setFocusFallOffRate:(CGFloat)newValue;
{
    _focusFallOffRate = newValue;
    [tiltShiftFilter setFloat:newValue forUniformName:@"focusFallOffRate"];
}

- (void) showMaskForPicture:(GPUImagePicture *)picture
{
    [self resetAnimationState];
    self.picture = picture;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(showMask)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
}

- (void) hideMaskForPicture:(GPUImagePicture *)picture
                   duration:(NSTimeInterval)duration
{
    [self resetAnimationState];
    self.duration = duration;
    self.picture = picture;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(hideMask)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) showMask
{
    self.elapsedTime += self.displayLink.duration;
    if (self.elapsedTime <= self.duration) {
        CGFloat percent = self.elapsedTime / self.duration;
        [self setMaskAlpha:percent];
        [self.picture processImage];
    } else {
        CGFloat percent = 1.f;
        [self setMaskAlpha:percent];
        [self.picture processImage];
        [self resetAnimationState];
        self.duration = DH_LINEAR_TILT_SHIFT_ANIMATION_DURATION;
    }
}

- (void) hideMask
{
    self.elapsedTime += self.displayLink.duration;
    if (self.elapsedTime <= self.duration) {
        CGFloat percent = 1.f - self.elapsedTime / self.duration;
        [self setMaskAlpha:percent];
        [self.picture processImage];
    } else {
        CGFloat percent = 0.f;
        [self setMaskAlpha:percent];
        [self.picture processImage];
        if (self.extraCount > 3) {
            [self resetAnimationState];
            self.duration = DH_LINEAR_TILT_SHIFT_ANIMATION_DURATION;
        }
        self.extraCount++;
    }
}

- (void) resetAnimationState
{
    self.extraCount = 0;
    self.elapsedTime = 0;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (GPUImageFilter *) tiltShiftFilter
{
    return tiltShiftFilter;
}

- (NSString *) tiltShiftFilterFragmentShaderString
{
    return nil;
}
@end
