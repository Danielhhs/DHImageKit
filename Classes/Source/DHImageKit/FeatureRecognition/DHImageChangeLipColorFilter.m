//
//  DHImageChangeLipColorFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/11/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageChangeLipColorFilter.h"

NSString * const kDHImageChangeFilterColorFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform highp float strength;
 uniform highp vec4 color;
 
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 strengthMap = texture2D(inputImageTexture2, textureCoordinate2);
     
     if (strengthMap.r > 0.0) {
         lowp float alphaDivisor = image.a + step(image.a, 0.0); // Protect against a divide-by-zero blacking out things in the output
         mediump vec4 processedColor = image * (color.a * (image / alphaDivisor) + (2.0 * color * (1.0 - (image / alphaDivisor)))) + color * (1.0 - image.a) + image * (1.0 - color.a);
         gl_FragColor = vec4(mix(image.rgb, processedColor.rgb, strength), 1.0);
     } else {
         gl_FragColor = image;
     }
//     gl_FragColor = strengthMap;
 }
 );

@implementation DHImageChangeLipColorFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageChangeFilterColorFilterFragmentShaderString];
    if (self) {
        colorUniform = [filterProgram uniformIndex:@"color"];
    }
    return self;
}

- (void) setColor:(GPUVector4)color
{
    _color = color;
    [self setVec4:color forUniform:colorUniform program:filterProgram];
}

@end
