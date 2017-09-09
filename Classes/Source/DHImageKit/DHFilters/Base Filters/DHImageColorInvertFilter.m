//
//  DHImageColorInvertFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageColorInvertFilter.h"
NSString *const kDHImageInvertFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform mediump float strength;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4(mix(textureColor.rgb, (1.0 - textureColor.rgb), strength), textureColor.w);
 }
 );

@implementation DHImageColorInvertFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageInvertFragmentShaderString];
    if (self){
        
    }
    return self;
}

@end
