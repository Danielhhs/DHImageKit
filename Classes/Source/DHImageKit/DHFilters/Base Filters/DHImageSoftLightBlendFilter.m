//
//  DHImageSoftLightBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSoftLightBlendFilter.h"
NSString *const kDHImageSoftLightBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform highp float strength;
 
 void main()
 {
     mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
     mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     lowp float alphaDivisor = base.a + step(base.a, 0.0); // Protect against a divide-by-zero blacking out things in the output
     mediump vec4 processedColor = base * (overlay.a * (base / alphaDivisor) + (2.0 * overlay * (1.0 - (base / alphaDivisor)))) + overlay * (1.0 - base.a) + base * (1.0 - overlay.a);
     gl_FragColor = vec4(mix(base.rgb, processedColor.rgb, strength), 1.0);
//     gl_FragColor = overlay;
 }
 );
@implementation DHImageSoftLightBlendFilter
- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageSoftLightBlendFragmentShaderString];
    if (self) {
        
    }
    return self;
}

- (void) newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex
{
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
}
@end
