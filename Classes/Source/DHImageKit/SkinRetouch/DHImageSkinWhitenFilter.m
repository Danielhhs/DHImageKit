//
//  DHImageSkinWhitenFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinWhitenFilter.h"
#import "DHImageSkinSmoothMaskFilter.h"
#import "DHImageExposureFilter.h"
#import "DHImageDissolveBlendFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageSharpenFilter.h"
#import "DHImageStrengthMask.h"
#import "DHImageFourInputFilter.h"

NSString * const kDHImageSkinWhitenCompositingFilterFragmentShaderString =
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
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 toneCurvedImage = texture2D(inputImageTexture2, textureCoordinate);
     lowp vec4 mask = texture2D(inputImageTexture3, textureCoordinate);
     lowp vec4 strength = texture2D(inputImageTexture4, textureCoordinate4);
     lowp vec4 processedColor = vec4(mix(image.rgb,toneCurvedImage.rgb,1.0 - mask.b),1.0);
     gl_FragColor = vec4(mix(image.rgb, processedColor.rgb, strength.r), 1.0);
 }
 );

@interface DHImageSkinWhitenFilter()
@property (nonatomic, strong) DHImageExposureFilter *exposureFilter;
//@property (nonatomic, strong) DHImageSkinSmoothMaskFilter *maskFilter;
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
//@property (nonatomic, strong) DHImageDissolveBlendFilter *dissolveBlendFilter;
@property (nonatomic, strong) DHImageThreeInputFilter *compositeFilter;
//@property (nonatomic, strong) DHImageSharpenFilter *sharpenFilter;
//@property (nonatomic, strong) DHImageStrengthMask *strengthMask;

@property (nonatomic) CGSize currentInputSize;
@end

@implementation DHImageSkinWhitenFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _exposureFilter = [[DHImageExposureFilter alloc] init];
        _exposureFilter.exposure = -1;
        [self addTarget:_exposureFilter];
        
        
//        _maskFilter = [[DHImageSkinSmoothMaskFilter alloc] init];
//        [self addFilter:_maskFilter];
//        [_exposureFilter addTarget:_maskFilter];
        
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] init];
        [self addFilter:_toneCurveFilter];
        
//        _dissolveBlendFilter = [[DHImageDissolveBlendFilter alloc] init];
//        [self addFilter:_dissolveBlendFilter];
//        [_toneCurveFilter addTarget:_dissolveBlendFilter atTextureLocation:1];
        
//        _strengthMask = [[DHImageStrengthMask alloc] initWithWidth:750 height:750];
//
//        _compositeFilter = [[DHImageFourInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinSmoothCompositingFilterFragmentShaderString];
//        [_dissolveBlendFilter addTarget:_compositeFilter atTextureLocation:1];
//        [_maskFilter addTarget:_compositeFilter atTextureLocation:2];
//        [_strengthMask addTarget:_compositeFilter atTextureLocation:3];
//        [self addFilter:_compositeFilter];
        
        //        _sharpenFilter = [[DHImageSharpenFilter alloc] init];
        //        _sharpenFilter.sharpness = 4.f;
        //        [_sharpenFilter updateWithStrength:1.f];
        //        [self addFilter:_sharpenFilter];
        //        [_compositeFilter addTarget:_sharpenFilter];
        
//        self.initialFilters = @[_exposureFilter, _toneCurveFilter, _dissolveBlendFilter, _compositeFilter];
//        self.terminalFilter = _compositeFilter;
//
//        CGPoint controlPoint0 = CGPointMake(0, 0);
//        CGPoint controlPoint1 = CGPointMake(120/255.0, 146/255.0);
//        CGPoint controlPoint2 = CGPointMake(1.0, 1.0);
//
//        self.controlPoints = @[[NSValue valueWithCGPoint:controlPoint0],
//                               [NSValue valueWithCGPoint:controlPoint1],
//                               [NSValue valueWithCGPoint:controlPoint2]];
//        self.radius = [DHImageSkinSmootherRadius radiusAsFractionOfImageWidth:10/750.0];
//        self.amount = 0.55;
    }
    return self;
}

//- (void) setControlPoints:(NSArray *)controlPoints
//{
//    _controlPoints = [controlPoints copy];
//    self.toneCurveFilter.rgbCompositeControlPoints = _controlPoints;
//}
//
//- (void)setRadius:(DHImageSkinSmootherRadius *)radius {
//    _radius = radius.copy;
//    [self updateHighPassRadius];
//}
//
//- (void)setSharpnessFactor:(CGFloat)sharpnessFactor {
//    _sharpnessFactor = sharpnessFactor;
//    self.sharpenFilter.sharpness = sharpnessFactor * self.amount;
//}
//
//- (void)updateHighPassRadius {
//    CGSize inputSize = self.currentInputSize;
//    if (inputSize.width * inputSize.height > 0) {
//        CGFloat radiusInPixels = 0;
//        switch (self.radius.unit) {
//            case DHImageSkinSmootherUnitPixel:
//                radiusInPixels = self.radius.value;
//                break;
//            case DHImageSkinSmootherUnitFractionOfImage:
//                radiusInPixels = ceil(inputSize.width * self.radius.value);
//                break;
//            default:
//                break;
//        }
//        if (radiusInPixels != self.maskFilter.highPassRadiusInPixels) {
//            self.maskFilter.highPassRadiusInPixels = radiusInPixels;
//        }
//    }
//}
//
//- (void)setAmount:(CGFloat)amount {
//    _amount = amount;
//    self.dissolveBlendFilter.mix = amount;
//}
//
//- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
//{
//    [_strengthMask updateWithTouchLocation:location completion:completion];
//}
//
//- (void) finishUpdating
//{
//    [_strengthMask finishUpdating];
//}
@end
