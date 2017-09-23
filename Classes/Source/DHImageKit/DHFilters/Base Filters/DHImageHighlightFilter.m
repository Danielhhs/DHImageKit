//
//  DHImageHighlightFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/23.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageHighlightFilter.h"
NSString *const kDHImageHighlightFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 uniform float highlights;
 uniform float strength;
 
 varying highp vec2 textureCoordinate;
 
 const vec3 luminanceWeight = vec3(0.3, 0.3, 0.3);
 const float highlightLuminance = 0.66;
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, luminanceWeight);
     
     if (luminance > highlightLuminance) {
         gl_FragColor = vec4(textureColor.rgb * highlights, textureColor.a);
     } else {
         gl_FragColor = textureColor;
     }
 }
 );

@implementation DHImageHighlightFilter
- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageHighlightFragmentShaderString];
    if (self) {
        highlightUniform = [filterProgram uniformIndex:@"highlights"];
        self.highlights = 1.f;
    }
    return self;
}

- (void) setHighlights:(CGFloat)highlights
{
    _highlights = highlights;
    [self setFloat:highlights forUniform:highlightUniform program:filterProgram];
}
@end
