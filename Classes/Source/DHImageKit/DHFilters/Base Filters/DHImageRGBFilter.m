//
//  DHImageRGBFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageRGBFilter.h"
NSString *const kDHImageRGBFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform highp float redAdjustment;
 uniform highp float greenAdjustment;
 uniform highp float blueAdjustment;
 
 uniform highp float opacity;
 
 uniform mediump float strength;
 
 void main()
 {
     highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     highp vec4 adjustedColor = vec4(textureColor.r * redAdjustment * opacity, textureColor.g * greenAdjustment * opacity, textureColor.b * blueAdjustment * opacity, textureColor.a);
     gl_FragColor = vec4(mix(textureColor.rgb, adjustedColor.rgb, strength), 1.0);
 }
 );
@implementation DHImageRGBFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kDHImageRGBFragmentShaderString]))
    {
        return nil;
    }
    
    redUniform = [filterProgram uniformIndex:@"redAdjustment"];
    self.red = 1.0;
    
    greenUniform = [filterProgram uniformIndex:@"greenAdjustment"];
    self.green = 1.0;
    
    blueUniform = [filterProgram uniformIndex:@"blueAdjustment"];
    self.blue = 1.0;
    
    opacityUniform = [filterProgram uniformIndex:@"opacity"];
    self.opacity = 1.f;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setRed:(CGFloat)newValue;
{
    _red = newValue;
    
    [self setFloat:_red forUniform:redUniform program:filterProgram];
}

- (void)setGreen:(CGFloat)newValue;
{
    _green = newValue;
    
    [self setFloat:_green forUniform:greenUniform program:filterProgram];
}

- (void)setBlue:(CGFloat)newValue;
{
    _blue = newValue;
    
    [self setFloat:_blue forUniform:blueUniform program:filterProgram];
}

- (void) setOpacity:(CGFloat)opacity
{
    _opacity = opacity;
    [self setFloat:_opacity forUniform:opacityUniform program:filterProgram];
}
@end
