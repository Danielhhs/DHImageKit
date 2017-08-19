//
//  DHLinearTiltShiftFilter.m
//  DHChat
//
//  Created by 黄鸿森 on 2017/7/19.
//  Copyright © 2017年 lindved. All rights reserved.
//

#import "DHLinearTiltShiftFilter.h"

NSString *const kDHLinearTiltShiftFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform highp float topFocusLevel;
 uniform highp float bottomFocusLevel;
 uniform highp float focusFallOffRate;
 
 uniform highp float maskAlpha;
 
 void main()
 {
     lowp vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     lowp float blurIntensity = 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.y);
     blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.y);
     
         lowp vec4 whiteBlend = vec4(1.0);
         lowp vec4 mixedColor = mix(sharpImageColor, blurredImageColor, blurIntensity);
         
         blurIntensity = clamp (blurIntensity, 0.0, 0.7 * maskAlpha);
         
         gl_FragColor = vec4(mix(mixedColor.rgb, whiteBlend.rgb, blurIntensity), whiteBlend.a);
    }
 );

@implementation DHLinearTiltShiftFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    self.center = 0.5;
    self.range = 0.1;
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSString *) tiltShiftFilterFragmentShaderString
{
    return kDHLinearTiltShiftFragmentShaderString;
}
- (void)setCenter:(CGFloat)center
{
    _center = center;
    [[self tiltShiftFilter] setFloat:center - self.range forUniformName:@"topFocusLevel"];
    [[self tiltShiftFilter] setFloat:center + self.range forUniformName:@"bottomFocusLevel"];
}

- (void)setRange:(CGFloat)range
{
    _range = range;
    [[self tiltShiftFilter] setFloat:self.center - self.range forUniformName:@"topFocusLevel"];
    [[self tiltShiftFilter] setFloat:self.center + self.range forUniformName:@"bottomFocusLevel"];
}

@end
