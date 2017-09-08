//
//  DHImageColorMultiplyBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageColorMultiplyBlendFilter.h"

NSString *const kDHImageMultiplyBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform mediump vec4 blendColor;
 uniform lowp float strength;
 uniform mediump float opacity;
 
 void main()
 {
     lowp vec4 base = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = mix(base, vec4(blendColor * base * opacity + blendColor * (1.0 - base.a) + base * (1.0 - opacity)), strength);
 }
 );

@implementation DHImageColorMultiplyBlendFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageMultiplyBlendFragmentShaderString];
    if (self) {
        blendColorUniform = [filterProgram uniformIndex:@"blendColor"];
        self.blendColor = [UIColor clearColor];
        
        opacityUniform = [filterProgram uniformIndex:@"opacity"];
        self.opacity = 1.f;
    }
    return self;
}

- (void) setBlendColor:(UIColor *)blendColor
{
    _blendColor = blendColor;
    CGFloat red, green, blue, alpha;
    [blendColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [self setVec4:(GPUVector4){red, green, blue, alpha} forUniform:blendColorUniform program:filterProgram];
}

- (void) setOpacity:(CGFloat)opacity
{
    _opacity = opacity;
    [self setFloat:opacity forUniform:opacityUniform program:filterProgram];
}
@end
