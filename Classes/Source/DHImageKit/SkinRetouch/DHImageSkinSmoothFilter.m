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
 }
 );

@interface DHImageSkinSmoothFilter ()
@property (nonatomic, strong) DHImageExposureFilter *exposureFilter;
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@property (nonatomic, strong) DHImageFourInputFilter *compositeFilter;
@end

@implementation DHImageSkinSmoothFilter

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

