//
//  DHImageSkinSmoothMaskFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinSmoothMaskFilter.h"
#import "DHImageBaseFilter.h"
#import "DHImageSkinSmoothHighPassFilter.h"

NSString * const kDHImageGreenAndBlueChannelOverlayFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform highp vec2 renderCenter;
 uniform highp float renderRadius;
 void main() {
     highp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     highp vec4 base = vec4(image.g,image.g,image.g,1.0);
     highp vec4 overlay = vec4(image.b,image.b,image.b,1.0);
     highp float ba = 2.0 * overlay.b * base.b + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
     gl_FragColor = vec4(ba,ba,ba,image.a);
 }
 );

NSString * const kDHMaskBoostFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform highp vec2 renderCenter;
 uniform highp float renderRadius;
 
 void main() {
     highp vec4 color = texture2D(inputImageTexture,textureCoordinate);
     
     highp float hardLightColor = color.b;
     for (int i = 0; i < 3; ++i)
     {
         if (hardLightColor < 0.5) {
             hardLightColor = hardLightColor  * hardLightColor * 2.;
         } else {
             hardLightColor = 1. - (1. - hardLightColor) * (1. - hardLightColor) * 2.;
         }
     }
     
     highp float k = 255.0 / (164.0 - 75.0);
     hardLightColor = (hardLightColor - 75.0 / 255.0) * k;
     
     gl_FragColor = vec4(vec3(hardLightColor),color.a);
 }
 );

@interface DHImageSkinSmoothMaskFilter ()
//Use green and blue to determine the strength of the pixel. If blue&green are strong, it will be brighter; otherwise darker;
@property (nonatomic, strong) DHImageBaseFilter *chanelOverlayFilter;
@property (nonatomic, strong) DHImageSkinSmoothHighPassFilter *highPassFilter;
@property (nonatomic, strong) DHImageBaseFilter *boostFilter;
@end

@implementation DHImageSkinSmoothMaskFilter
- (instancetype) init
{
    self = [super init];
    if (self) {
        _chanelOverlayFilter = [[DHImageBaseFilter alloc] initWithFragmentShaderFromString:kDHImageGreenAndBlueChannelOverlayFragmentShaderString];
        [self addFilter:_chanelOverlayFilter];
        
        _highPassFilter = [[DHImageSkinSmoothHighPassFilter alloc] init];
        [_chanelOverlayFilter addTarget:_highPassFilter];
        [self addFilter:_highPassFilter];
        
        _boostFilter = [[DHImageBaseFilter alloc] initWithFragmentShaderFromString:kDHMaskBoostFilterFragmentShaderString];
        [self addFilter:_boostFilter];
        [_highPassFilter addTarget:_boostFilter];
        
        self.initialFilters = @[_chanelOverlayFilter];
        self.terminalFilter = _boostFilter;
    }
    return self;
}
- (void) setHighPassRadiusInPixels:(CGFloat)highPassRadiusInPixels
{
    self.highPassFilter.radiusInPixels = highPassRadiusInPixels;
}
@end
