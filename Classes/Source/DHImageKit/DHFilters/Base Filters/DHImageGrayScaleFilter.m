//
//  DHImageGrayScaleFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageGrayScaleFilter.h"
NSString *const kDHImageLuminanceFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform float strength;
 
 const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, W);
     
     gl_FragColor = vec4( mix(textureColor.rgb,vec3(luminance), strength), textureColor.a);
 }
 );

@implementation DHImageGrayScaleFilter
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    if (!currentlyReceivingMonochromeInput)
    {
        [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
    }
}

- (BOOL)wantsMonochromeInput;
{
    //    return YES;
    return NO;
}

- (BOOL)providesMonochromeOutput;
{
    //    return YES;
    return NO;
}


#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kDHImageLuminanceFragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}
@end
