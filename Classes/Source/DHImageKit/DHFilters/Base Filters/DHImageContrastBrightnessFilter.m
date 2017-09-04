//
//  DHImageContrastBrightnessFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageContrastBrightnessFilter.h"
#import "DHImageConstants.h"

NSString *const kDHImageContrastBrightnessFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform lowp float contrast;
 uniform lowp float brightness;
 uniform lowp float strength;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     highp vec4 contrastColor = vec4(((textureColor.rgb - vec3(0.5)) * contrast + vec3(0.5)), textureColor.w);
     
     gl_FragColor = vec4(mix(textureColor.rgb, (contrastColor.rgb + vec3(brightness)), strength), contrastColor.w);
 }
 );

@interface DHImageContrastBrightnessFilter () {
    CGFloat benchmarkBrightness, benchmarkContrast;
}

@end

@implementation DHImageContrastBrightnessFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageContrastBrightnessFragmentShaderString];
    
    if (self) {
        brightnessUniform = [filterProgram uniformIndex:@"brightness"];
        contrastUniform = [filterProgram uniformIndex:@"contrast"];
        
        self.brightness = 0.f;
        self.contrast = 1.f;
        
        benchmarkContrast = 0.f;
        benchmarkContrast = 1.f;
    }
    
    return self;
}

- (void) setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setFloat:brightness forUniform:brightnessUniform program:filterProgram];
}

- (void) setContrast:(CGFloat)contrast
{
    _contrast = contrast;
    [self setFloat:contrast forUniform:contrastUniform program:filterProgram];
}

@end
