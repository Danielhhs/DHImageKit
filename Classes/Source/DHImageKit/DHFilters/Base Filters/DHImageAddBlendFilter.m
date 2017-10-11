//
//  DHImageAddBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageAddBlendFilter.h"

NSString *const kDHImageAddBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform highp float scale;
 uniform highp float strength;
 
 void main()
 {
     lowp vec4 base = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2) ;
     
     mediump float r;
     if (overlay.r * base.a + base.r * overlay.a >= overlay.a * base.a) {
         r = overlay.a * base.a + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);
     } else {
         r = overlay.r + base.r;
     }
     
     mediump float g;
     if (overlay.g * base.a + base.g * overlay.a >= overlay.a * base.a) {
         g = overlay.a * base.a + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);
     } else {
         g = overlay.g + base.g;
     }
     
     mediump float b;
     if (overlay.b * base.a + base.b * overlay.a >= overlay.a * base.a) {
         b = overlay.a * base.a + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
     } else {
         b = overlay.b + base.b;
     }
     
     mediump float a = overlay.a + base.a - overlay.a * base.a;
     
     mediump vec4 processedColor = vec4(r, g, b, a);
     gl_FragColor = vec4(mix(base.rgb, processedColor.rgb / scale, strength), a);
 }
 );

@implementation DHImageAddBlendFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kDHImageAddBlendFragmentShaderString]))
    {
        return nil;
    }
    scaleUniform = [filterProgram uniformIndex:@"scale"];
    self.scale = 1.f;
    return self;
}

- (void) setScale:(CGFloat)scale
{
    _scale = scale;
    [self setFloat:scale forUniform:scaleUniform program:filterProgram];
}
@end
