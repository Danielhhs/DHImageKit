//
//  DHImageSkinFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinFilter.h"

@interface DHImageSkinFilter()
@property (nonatomic, strong, readwrite) DHImageSkinSmoothMaskFilter *maskFilter;
@property (nonatomic, strong, readwrite) DHImageSharpenFilter *sharpenFilter;
@property (nonatomic, strong, readwrite) DHImageStrengthMask *strengthMask;
@property (nonatomic, strong, readwrite) DHImageDissolveBlendFilter *dissolveBlendFilter;

@property (nonatomic) CGSize currentInputSize;
@end

@implementation DHImageSkinFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _maskFilter = [[DHImageSkinSmoothMaskFilter alloc] init];
        [self addFilter:_maskFilter];
        
        _dissolveBlendFilter = [[DHImageDissolveBlendFilter alloc] init];
        [self addFilter:_dissolveBlendFilter];
        
        _strengthMask = [[DHImageStrengthMask alloc] initWithWidth:size.width height:size.height];
        
        _sharpenFilter = [[DHImageSharpenFilter alloc] init];
        _sharpenFilter.sharpness = 4.f;
        [_sharpenFilter updateWithStrength:1.f];
        [self addFilter:_sharpenFilter];
    }
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    self.currentInputSize = newSize;
    [self updateHighPassRadius];
}

- (void)setRadius:(DHImageSkinSmootherRadius *)radius {
    _radius = radius.copy;
    [self updateHighPassRadius];
}

- (void)setSharpnessFactor:(CGFloat)sharpnessFactor {
    _sharpnessFactor = sharpnessFactor;
    self.sharpenFilter.sharpness = sharpnessFactor * self.amount;
}

- (void)updateHighPassRadius {
    CGSize inputSize = self.currentInputSize;
    if (inputSize.width * inputSize.height > 0) {
        CGFloat radiusInPixels = 0;
        switch (self.radius.unit) {
            case DHImageSkinSmootherUnitPixel:
                radiusInPixels = self.radius.value;
                break;
            case DHImageSkinSmootherUnitFractionOfImage:
                radiusInPixels = ceil(inputSize.width * self.radius.value);
                break;
            default:
                break;
        }
        if (radiusInPixels != self.maskFilter.highPassRadiusInPixels) {
            self.maskFilter.highPassRadiusInPixels = radiusInPixels;
        }
    }
}


- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
{
    [_strengthMask updateWithTouchLocation:location completion:completion];
}

- (void) finishUpdating
{
    [_strengthMask finishUpdating];
}

- (void)setAmount:(CGFloat)amount {
    _amount = amount;
    self.dissolveBlendFilter.mix = amount;
}

- (void) updateWithStrength:(CGFloat)strength
{
    [super updateWithStrength:strength];
    [self.strengthMask informTargetsForFrameReadyWithCompletion:^{
        
    }];
}
@end
