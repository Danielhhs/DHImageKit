//
//  DHImageStrengthMapExposureFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/5.
//

#import "DHImageStrengthMapExposureFilter.h"
NSString *const kDHImageStrengthMapExposureFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D strengthMap;
 uniform highp float exposure;
 
 void main()
 {
     highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     highp vec4 strength = texture2D(strengthMap, textureCoordinate2);
     gl_FragColor = vec4(mix(textureColor.rgb, textureColor.rgb * pow(2.0, exposure), strength.r), textureColor.w);
 }
 );
@implementation DHImageStrengthMapExposureFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kDHImageStrengthMapExposureFragmentShaderString]))
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
