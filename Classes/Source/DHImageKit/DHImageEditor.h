//
//  DHImageEditor.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHImageConstants.h"
#import "DHImageFilter.h"

@interface DHImageEditor : NSObject

+ (DHImageEditor *) sharedEditor;

#pragma mark - Initialization
- (void) initiateEditorWithImage:(UIImage *)image
                    renderTarget:(id<GPUImageInput>)renderTarget
                      completion:(void (^)(BOOL))completion;

- (void) initiateEditorWithImageURL:(NSURL *)imageURL
                       renderTarget:(id<GPUImageInput>)renderTarget
                         completion:(void (^)(BOOL))complection;

#pragma mark - Start Processing
- (void) startProcessingComponent:(DHImageEditComponent)component;

- (void) startProcessingComponent:(DHImageEditComponent)component
                     subComponent:(DHImageEidtComponentSubType)subType;

- (void) startProcessingWithDHFilter:(DHImageFilter *)filter;

#pragma mark - Finish Processing
- (void) finishProcessingCurrentComponent;

- (void) cancelProcessingCurrentComponent;

- (void) finishProcessingImage;

#pragma mark - ShowImage
- (void) showOriginalImage;
- (void) showProcessedImage;
- (UIImage *) processedImage;

#pragma mark - Update DHImageFilter
- (void) updateDHFilterWithStrength:(CGFloat)strength;

#pragma mark - Update Input
- (void) updateWithInput:(CGFloat)inputValue;
- (void) updateWithColor:(UIColor *)color;
- (void) removeColorFilter;

#pragma mark - Tilt Shift Input
- (void) startLinearTiltShiftInputWithValue:(CGFloat) value;
- (void) finishLinearTiltShiftInputWithValue:(CGFloat)value;

- (void) startRadialTiltShiftInputWithCenter:(CGPoint)center
                                      radius:(CGFloat)radius;

- (void) updateWithCenter:(CGPoint)center radius:(CGFloat)radius;
- (void) finishRadialTiltShiftInputWithCenter:(CGPoint)center
                                       radius:(CGFloat)radius;

#pragma mark - Adjustment
- (void) startUpdatingImageWithTranslation:(CGPoint)translation;
- (void) updateImageWithTranslation:(CGPoint)translation;
- (void) moveToFullVisibleImage;
- (void) resetTransformFilter;

#pragma mark - Tilt Shift
- (void) startProcessingTiltShiftWithSubType:(DHImageEidtComponentSubType)subtype;
- (DHImageEidtComponentSubType) subTypeForExistingTiltShiftFilter;
- (void) removeTiltShiftFilter;

#pragma mark - Get Values
//For single input filters, there's only ONE key/value pair;
//For multiple input filters, get the values by checking the input parameter names as keys;
- (NSDictionary *) initialParameters;

#pragma mark - IntermediateState
//For filters that have more than one level (like color, tilt), call this method to save the intermediate state for second level operation cancelation;
- (void) saveInterMediateState;

- (NSDictionary *) intermediateParameters;

- (void) restoreIntermediateState;

- (BOOL) imageModified;

@end
