//
//  DHImageExposureFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageExposureFilter.h"
NSString *const kDHImageExposureFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform highp float exposure;
 uniform highp float strength;
 
 void main()
 {
     highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4(mix(textureColor.rgb, textureColor.rgb * pow(2.0, exposure), strength), textureColor.w);
 }
 );
@implementation DHImageExposureFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kDHImageExposureFragmentShaderString]))
    {
        return nil;
    }
    
    exposureUniform = [filterProgram uniformIndex:@"exposure"];
    self.exposure = 0.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setExposure:(CGFloat)newValue;
{
    _exposure = newValue;
    
    [self setFloat:_exposure forUniform:exposureUniform program:filterProgram];
}
@end
