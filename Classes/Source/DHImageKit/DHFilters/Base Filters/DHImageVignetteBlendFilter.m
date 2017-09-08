//
//  DHImageVignetteBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/8.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageVignetteBlendFilter.h"

NSString *const kDHImageVignetteBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform mediump vec2 vignetteCenter;
 uniform mediump float vignetteStart;
 uniform mediump float vignetteEnd;
 
 uniform highp float strength;
 
 void main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     lowp float d = distance(textureCoordinate, vignetteCenter);
     lowp float percent = smoothstep(vignetteStart, vignetteEnd, d);
     gl_FragColor = mix(textureColor, mix(textureColor, textureColor2, percent), strength);
 }
 );


@implementation DHImageVignetteBlendFilter
- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageVignetteBlendFragmentShaderString];
    if (self) {
        vignetteCenterUniform = [filterProgram uniformIndex:@"vignetteCenter"];
        vignetteStartUniform = [filterProgram uniformIndex:@"vignetteStart"];
        vignetteEndUniform = [filterProgram uniformIndex:@"vignetteEnd"];
        
        self.vignetteCenter = (CGPoint){ 0.5f, 0.5f };
        self.vignetteStart = 0.3;
        self.vignetteEnd = 0.75;
    }
    return self;
}


- (void)setVignetteCenter:(CGPoint)newValue
{
    _vignetteCenter = newValue;
    
    [self setPoint:newValue forUniform:vignetteCenterUniform program:filterProgram];
}

- (void)setVignetteStart:(CGFloat)newValue;
{
    _vignetteStart = newValue;
    
    [self setFloat:_vignetteStart forUniform:vignetteStartUniform program:filterProgram];
}

- (void)setVignetteEnd:(CGFloat)newValue;
{
    _vignetteEnd = newValue;
    
    [self setFloat:_vignetteEnd forUniform:vignetteEndUniform program:filterProgram];
}
@end
