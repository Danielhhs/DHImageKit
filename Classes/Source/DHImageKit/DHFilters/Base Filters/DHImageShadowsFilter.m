//
//  DHImageShadowsFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/23.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageShadowsFilter.h"
NSString *const kDHImageShadowsFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 uniform float shadows;
 uniform float strength;
 
 varying highp vec2 textureCoordinate;
 
 const vec3 luminanceWeight = vec3(0.3, 0.3, 0.3);
 const float shadowsLuminance = 0.66;
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, luminanceWeight);
     
     if (luminance < shadowsLuminance) {
         gl_FragColor = vec4(textureColor.rgb * shadows, textureColor.a);
     } else {
         gl_FragColor = textureColor;
     }
 }
 );

@implementation DHImageShadowsFilter
- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageShadowsFragmentShaderString];
    if (self) {
        shadowsUniform = [filterProgram uniformIndex:@"shadows"];
        self.shadows = 1.f;
    }
    return self;
}

- (void) setShadows:(CGFloat)shadows
{
    _shadows = shadows;
    [self setFloat:shadows forUniform:shadowsUniform program:filterProgram];
}
@end
