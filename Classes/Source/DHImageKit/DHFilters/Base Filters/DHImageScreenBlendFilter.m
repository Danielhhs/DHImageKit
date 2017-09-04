//
//  DHImageScreenBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageScreenBlendFilter.h"

NSString *const kDHImageScreenBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform highp float strength;
 
 void main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2) * 0.6;
     mediump vec4 whiteColor = vec4(1.0);
     mediump vec4 processedColor = whiteColor - ((whiteColor - textureColor2) * (whiteColor - textureColor));
     gl_FragColor = mix(textureColor, processedColor, strength);
 }
);

@implementation DHImageScreenBlendFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageScreenBlendFragmentShaderString];
    if (self) {
    }
    return self;
}

@end
