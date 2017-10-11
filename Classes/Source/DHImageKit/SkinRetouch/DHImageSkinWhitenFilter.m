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
#import "DHImageSoftLightBlendFilter.h"

NSString * const kDHImageSkinWhitenCompositingFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 varying highp vec2 textureCoordinate3;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 uniform highp vec2 renderCenter;
 uniform highp float renderRadius;
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 toneCurvedImage = texture2D(inputImageTexture2, textureCoordinate);
     lowp vec4 mask = texture2D(inputImageTexture3, textureCoordinate);
     gl_FragColor = vec4(mix(image.rgb,toneCurvedImage.rgb,1.0 - mask.b),1.0);
 }
 );

@interface DHImageSkinWhitenFilter()
@property (nonatomic, strong) DHImageExposureFilter *exposureFilter;
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@property (nonatomic, strong) DHImageThreeInputFilter *compositeFilter;
@property (nonatomic, strong) DHImageSoftLightBlendFilter *softLifhtBlendFilter;
@property (nonatomic) CGSize currentInputSize;
@end

@implementation DHImageSkinWhitenFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _exposureFilter = [[DHImageExposureFilter alloc] init];
        _exposureFilter.exposure = -1.5;
        [self addTarget:_exposureFilter];
        
        [_exposureFilter addTarget:self.maskFilter];
        
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] init];
        [self addFilter:_toneCurveFilter];
        
        [_toneCurveFilter addTarget:self.dissolveBlendFilter atTextureLocation:1];
        
        _compositeFilter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinWhitenCompositingFilterFragmentShaderString];
        [self.dissolveBlendFilter addTarget:_compositeFilter atTextureLocation:1];
        [self.maskFilter addTarget:_compositeFilter atTextureLocation:2];
        [self addFilter:_compositeFilter];
        
        _softLifhtBlendFilter = [[DHImageSoftLightBlendFilter alloc] init];
        [self addFilter:_softLifhtBlendFilter];
        [_compositeFilter addTarget:self.softLifhtBlendFilter atTextureLocation:0];
        [self.strengthMask addTarget:self.softLifhtBlendFilter atTextureLocation:1];
        
        self.initialFilters = @[_exposureFilter, _toneCurveFilter, self.dissolveBlendFilter, _compositeFilter];
        self.terminalFilter = self.softLifhtBlendFilter;
        
        CGPoint controlPoint0 = CGPointMake(0, 0);
        CGPoint controlPoint1 = CGPointMake(120/255.0, 146/255.0);
        CGPoint controlPoint2 = CGPointMake(1.0, 1.0);
        
        self.controlPoints = @[[NSValue valueWithCGPoint:controlPoint0],
                               [NSValue valueWithCGPoint:controlPoint1],
                               [NSValue valueWithCGPoint:controlPoint2]];
        self.radius = [DHImageSkinSmootherRadius radiusAsFractionOfImageWidth:15/750.0];
        self.amount = 0.65;
        self.sharpnessFactor = 6.f;
    }
    return self;
}

- (void) setControlPoints:(NSArray *)controlPoints
{
    _controlPoints = [controlPoints copy];
    self.toneCurveFilter.rgbCompositeControlPoints = _controlPoints;
}
@end
