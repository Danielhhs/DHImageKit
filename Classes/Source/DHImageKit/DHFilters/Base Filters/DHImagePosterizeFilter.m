//
//  DHImagePosterizeFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImagePosterizeFilter.h"

NSString *const kDHImagePosterizeFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform highp float colorLevels;
 
 uniform mediump float strength;
 
 void main()
 {
     highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     highp vec4 processedColor = floor((textureColor * colorLevels) + vec4(0.5)) / colorLevels;
     gl_FragColor = mix(textureColor, processedColor, strength);
 }
 );

@implementation DHImagePosterizeFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImagePosterizeFragmentShaderString];
    if (self) {
        colorLevelsUniform = [filterProgram uniformIndex:@"colorLevels"];
        self.colorLevels = 10.f;
    }
    return self;
}

- (void) setColorLevels:(float)colorLevels
{
    _colorLevels = colorLevels;
    [self setFloat:colorLevels forUniform:colorLevelsUniform program:filterProgram];
}

@end
