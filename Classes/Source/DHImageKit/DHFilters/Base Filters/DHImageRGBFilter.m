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
 
 void main()
 {
     highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4(textureColor.r * redAdjustment, textureColor.g * greenAdjustment, textureColor.b * blueAdjustment, textureColor.a);
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

- (void) updateWithStrength:(double)strength
{
    CGFloat r,g,b;
    r = (1.f - self.red) * (1.f - strength) + self.red;
    g = (1.f - self.green) * (1.f - strength) + self.green;
    b = (1.f - self.blue) * (1.f - strength) + self.blue;
    
    [self setFloat:r forUniform:redUniform program:filterProgram];
    [self setFloat:g forUniform:greenUniform program:filterProgram];
    [self setFloat:b forUniform:blueUniform program:filterProgram];
}


@end
