//
//  DHImageDifferenceBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageDifferenceBlendFilter.h"
NSString *const kDHImageDifferenceBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform mediump float strength;
 
 void main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     gl_FragColor = vec4(abs(textureColor2.rgb - textureColor.rgb), textureColor.a);
 }
 );

@implementation DHImageDifferenceBlendFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageDifferenceBlendFragmentShaderString];
    if (self) {
        
    }
    return self;
}

@end
