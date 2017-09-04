//
//  DHImageSaturationFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSaturationFilter.h"
NSString *const kDHImageSaturationFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float saturation;
 
 // Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham
 const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp float luminance = dot(textureColor.rgb, luminanceWeighting);
     lowp vec3 greyScaleColor = vec3(luminance);
     
     gl_FragColor = vec4(mix(greyScaleColor, textureColor.rgb, saturation), textureColor.w);
     
 }
 );
@implementation DHImageSaturationFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kDHImageSaturationFragmentShaderString]))
    {
        return nil;
    }
    
    saturationUniform = [filterProgram uniformIndex:@"saturation"];
    self.saturation = 1.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setSaturation:(CGFloat)newValue;
{
    _saturation = newValue;
    
    [self setFloat:_saturation forUniform:saturationUniform program:filterProgram];
}

- (void) updateWithStrength:(double)strength
{
    CGFloat saturation = (1 - self.saturation) * (1.f - strength) + self.saturation;
    [self setFloat:saturation forUniform:saturationUniform program:filterProgram];
    
}
@end
