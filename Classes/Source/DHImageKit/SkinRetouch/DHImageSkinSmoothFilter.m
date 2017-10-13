//
//  DHImageSkinSmoothFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinSmoothFilter.h"
#import "DHImageFourInputFilter.h"
#import "DHImageExposureFilter.h"
#import "DHImageToneCurveFilter.h"

NSString * const kDHImageSkinSmoothCompositingFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 varying highp vec2 textureCoordinate3;
 varying highp vec2 textureCoordinate4;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 
 uniform highp vec2 renderCenter;
 uniform highp float renderRadius;
 uniform highp float strength;
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 toneCurvedImage = texture2D(inputImageTexture2, textureCoordinate);
     lowp vec4 mask = texture2D(inputImageTexture3, textureCoordinate);
     lowp vec4 strengthMap = texture2D(inputImageTexture4, textureCoordinate4);
     lowp vec4 processedColor = vec4(mix(image.rgb,toneCurvedImage.rgb,(1.0 - mask.b) * strength),1.0);
     gl_FragColor = vec4(mix(image.rgb, processedColor.rgb, strengthMap.r), 1.0);
//     gl_FragColor = strengthMap;
 }
 );

@interface DHImageSkinSmoothFilter ()
@property (nonatomic, strong) DHImageExposureFilter *exposureFilter;
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@property (nonatomic, strong) DHImageFourInputFilter *compositeFilter;
@property (nonatomic, strong) DHImageSkinSmoothMaskFilter *maskFilter;
@property (nonatomic, strong) DHImageSharpenFilter *sharpenFilter;
@property (nonatomic, strong) DHImageDissolveBlendFilter *dissolveBlendFilter;
@end

@implementation DHImageSkinSmoothFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        _maskFilter = [[DHImageSkinSmoothMaskFilter alloc] init];
        [self addFilter:_maskFilter];
        
        _dissolveBlendFilter = [[DHImageDissolveBlendFilter alloc] init];
        [self addFilter:_dissolveBlendFilter];
        
        _sharpenFilter = [[DHImageSharpenFilter alloc] init];
        _sharpenFilter.sharpness = 4.f;
        [_sharpenFilter updateWithStrength:1.f];
        [self addFilter:_sharpenFilter];
        
        
        _exposureFilter = [[DHImageExposureFilter alloc] init];
        _exposureFilter.exposure = -1.5;
        [self addTarget:_exposureFilter];
        
        [_exposureFilter addTarget:self.maskFilter];
        
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] init];
        [self addFilter:_toneCurveFilter];
        
        [_toneCurveFilter addTarget:self.dissolveBlendFilter atTextureLocation:1];

        _compositeFilter = [[DHImageFourInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinSmoothCompositingFilterFragmentShaderString];
        [_compositeFilter disableFourthFrameCheck];
        [self.dissolveBlendFilter addTarget:_compositeFilter atTextureLocation:1];
        [self.maskFilter addTarget:_compositeFilter atTextureLocation:2];
        [self.strengthMask addTarget:_compositeFilter atTextureLocation:3];
        [self addFilter:_compositeFilter];
        
        [_compositeFilter addTarget:self.sharpenFilter];
        
        self.initialFilters = @[_exposureFilter, _toneCurveFilter, self.dissolveBlendFilter, _compositeFilter];
        self.terminalFilter = self.sharpenFilter;
        
        CGPoint controlPoint0 = CGPointMake(0, 0);
        CGPoint controlPoint1 = CGPointMake(120/255.0, 146/255.0);
        CGPoint controlPoint2 = CGPointMake(1.0, 1.0);
        
        self.controlPoints = @[[NSValue valueWithCGPoint:controlPoint0],
                               [NSValue valueWithCGPoint:controlPoint1],
                               [NSValue valueWithCGPoint:controlPoint2]];
        self.radius = [DHImageSkinSmootherRadius radiusAsFractionOfImageWidth:0.13];
        self.amount = 0.85;
        self.sharpnessFactor = 6.f;
        
        [self.strengthMask informTargetsForFrameReadyWithCompletion:nil];
    }
    return self;
}

- (void) setControlPoints:(NSArray *)controlPoints
{
    _controlPoints = [controlPoints copy];
    self.toneCurveFilter.rgbCompositeControlPoints = _controlPoints;
}

- (void)setRadius:(DHImageSkinSmootherRadius *)radius {
    _radius = radius.copy;
    [self updateHighPassRadius];
}


- (void)setAmount:(CGFloat)amount {
    _amount = amount;
    self.dissolveBlendFilter.mix = amount;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
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


@end

