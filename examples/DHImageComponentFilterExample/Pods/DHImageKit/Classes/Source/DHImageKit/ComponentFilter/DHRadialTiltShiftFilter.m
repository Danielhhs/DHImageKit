//
//  DHRadialTIltShiftFilter.m
//  DHChat
//
//  Created by 黄鸿森 on 2017/7/19.
//  Copyright © 2017年 lindved. All rights reserved.
//

#import "DHRadialTiltShiftFilter.h"

NSString *const kDHRadialTiltShiftFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform highp vec2 center;
 uniform highp float radius;
 uniform highp float focusFallOffRate;
 
 uniform highp float maskAlpha;
 
 void main()
 {
     lowp vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     highp float d = distance(center, textureCoordinate2);
     
     lowp float blurIntensity = smoothstep(radius - focusFallOffRate, radius, d);
     
     lowp vec4 whiteBlend = vec4(1.0);
     lowp vec4 mixedColor = mix(sharpImageColor, blurredImageColor, blurIntensity);
     
     blurIntensity = clamp (blurIntensity, 0.0, 0.7 * maskAlpha);
     
     gl_FragColor = vec4(mix(mixedColor.rgb, whiteBlend.rgb, blurIntensity), whiteBlend.a);
 }
 );

@interface DHRadialTiltShiftFilter ()
@end

@implementation DHRadialTiltShiftFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _center = CGPointMake(0.5, 0.5);
        _radius = 0.2;
    }
    return self;
}

- (NSString *) tiltShiftFilterFragmentShaderString
{
    return kDHRadialTiltShiftFragmentShaderString;
}

- (void) setCenter:(CGPoint)center
{
    _center = center;
    [[self tiltShiftFilter] setPoint:center forUniformName:@"center"];
}

- (void) setRadius:(CGFloat)radius
{
    _radius = radius;
    [[self tiltShiftFilter] setFloat:radius forUniformName:@"radius"];
}

@end
