//
//  DHImageLinearBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageLinearLightBlendFilter.h"
NSString *const kDHImageLinearLightBlendFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform highp float scale;
 uniform highp float strength;
 
 float blendLinearBurn(float base, float blend) {
     // Note : Same implementation as BlendSubtractf
     return max(base+blend-1.0,0.0);
 }
 
 float blendLinearDodge(float base, float blend) {
     // Note : Same implementation as BlendAddf
     return min(base+blend,1.0);
 }
 
 float blendLinearLight(float base, float blend) {
     return blend<0.5?blendLinearBurn(base,(2.0*blend)):blendLinearDodge(base,(2.0*(blend-0.5)));
 }
 
 vec3 blendLinearLight(vec3 base, vec3 blend) {
     return vec3(blendLinearLight(base.r,blend.r),blendLinearLight(base.g,blend.g),blendLinearLight(base.b,blend.b));
 }
 
 vec3 blendLinearLight(vec3 base, vec3 blend, float opacity) {
     return (blendLinearLight(base, blend) * opacity + base * (1.0 - opacity));
 }
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     mediump vec3 processedRGB = blendLinearLight(base.rgb, overlay.rgb);
     gl_FragColor = vec4(mix(base.rgb, processedRGB, strength), (base.a + overlay.a) / 2.0);
 }
 );
     
     
@implementation DHImageLinearLightBlendFilter
- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageLinearLightBlendFragmentShaderString];
    if (self) {
        scaleUniform = [filterProgram uniformIndex:@"scale"];
        self.scale = 0.f;
    }
    return self;
}

- (void) setScale:(CGFloat)scale
{
    _scale = scale;
    [self setFloat:scale forUniform:scaleUniform program:filterProgram];
}
@end
