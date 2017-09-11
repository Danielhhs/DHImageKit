//
//  DHImageDissolveBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageDissolveBlendFilter.h"
NSString *const kDHImageDissolveBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform lowp float mixturePercent;
 
 uniform mediump float strength;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     
     gl_FragColor = mix(textureColor, mix(textureColor, textureColor2, mixturePercent), strength);
 }
 );

@implementation DHImageDissolveBlendFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageDissolveBlendFragmentShaderString];
    if (self) {
        mixUniform = [filterProgram uniformIndex:@"mixturePercent"];
        self.mix = 0.5;
    }
    return self;
}

- (void) setMix:(CGFloat)mix
{
    _mix = mix;
    [self setFloat:mix forUniform:mixUniform program:filterProgram];
}

@end
