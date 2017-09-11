//
//  DHImageVividLightBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageVividLightBlendFilter.h"
NSString *const kDHImageVividLightBlendFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;

 uniform highp float opacity;

 uniform highp float strength;
 
 float blendColorBurn(float base, float blend) {
     return (blend==0.0)?blend:max((1.0-((1.0-base)/blend)),0.0);
 }
 
 float blendColorDodge(float base, float blend) {
     return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
 }
 
 float blendVividLight(float base, float blend) {
     return (blend<0.5)?blendColorBurn(base,(2.0*blend)):blendColorDodge(base,(2.0*(blend-0.5)));
 }
 
 vec3 blendVividLight(vec3 base, vec3 blend) {
     return vec3(blendVividLight(base.r,blend.r),blendVividLight(base.g,blend.g),blendVividLight(base.b,blend.b));
 }
 
 vec3 blendVividLight(vec3 base, vec3 blend, float opacityValue) {
     return (blendVividLight(base, blend) * opacity + base * (1.0 - opacityValue));
 }
 
 void main()
 {
     mediump vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump vec3 processedRGB = blendVividLight(textureColor.rgb, textureColor2.rgb, opacity);
     gl_FragColor = vec4(mix(textureColor.rgb, processedRGB, strength), textureColor.a);
 }
 );

@implementation DHImageVividLightBlendFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageVividLightBlendFragmentShaderString];
    if (self) {
        opacityUniform = [filterProgram uniformIndex:@"opacity"];
        self.opacity = 1.f;
    }
    return self;
}

- (void) setOpacity:(CGFloat)opacity
{
    _opacity = opacity;
    [self setFloat:opacity forUniform:opacityUniform program:filterProgram];
}

@end
