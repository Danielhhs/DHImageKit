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
 uniform lowp float strength;
 
 void main()
 {
     lowp vec4 base = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 overlayer = texture2D(inputImageTexture2, textureCoordinate2);
     
     gl_FragColor = vec4(mix(base.rgb, overlayer * base + overlayer * (1.0 - base.a) + base * (1.0 - overlayer.a).rgb), base.a);
 }
 );

@implementation DHImageColorMultiplyBlendFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageMultiplyBlendFragmentShaderString];
    if (self) {
    }
    return self;
}
@end
