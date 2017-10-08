//
//  DHImageMapStrengthDissolveBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/5.
//

#import "DHImageMapStrengthDissolveBlendFilter.h"
NSString *const kDHImageMapStrengthDissolveBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 varying highp vec3 textureCoordinate3;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D strengthMap;
 uniform lowp float mixturePercent;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     lowp vec4 strength = texture2D(strengthMap, textureCoordinate3);
     
     gl_FragColor = mix(textureColor, mix(textureColor, textureColor2, mixturePercent), strength.r);
 }
 );
@implementation DHImageMapStrengthDissolveBlendFilter
- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageMapStrengthDissolveBlendFragmentShaderString];
    if (self) {
    }
    return self;
}
@end
