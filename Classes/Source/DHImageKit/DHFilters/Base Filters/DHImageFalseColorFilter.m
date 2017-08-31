//
//  DHImageFalseColorFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFalseColorFilter.h"
NSString *const kDHFalseColorFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform float intensity;
 uniform vec3 firstColor;
 uniform vec3 secondColor;
 
 const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     float luminance = dot(textureColor.rgb, luminanceWeighting);
     
     gl_FragColor = vec4(mix(textureColor.rgb, mix(firstColor.rgb, secondColor.rgb, luminance), intensity), textureColor.a);
 }
 );

@implementation DHImageFalseColorFilter

@synthesize firstColor = _firstColor;
@synthesize secondColor = _secondColor;
@synthesize intensity = _intensity;

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHFalseColorFragmentShaderString];
    if (self) {
        firstColorUniform = [filterProgram uniformIndex:@"firstColor"];
        secondColorUniform = [filterProgram uniformIndex:@"secondColor"];
        intensityUniform = [filterProgram uniformIndex:@"intensity"];
        
        self.firstColor = (GPUVector4){0.f, 0.f, 0.5f, 1.f};
        self.secondColor = (GPUVector4){1.f, 0.f, 0.f, 1.f};
        self.intensity = 1.f;
    }
    return self;
}

- (void)setFirstColor:(GPUVector4)newValue;
{
    _firstColor = newValue;
    
    [self setFirstColorRed:_firstColor.one green:_firstColor.two blue:_firstColor.three];
}

- (void)setSecondColor:(GPUVector4)newValue;
{
    _secondColor = newValue;
    
    [self setSecondColorRed:_secondColor.one green:_secondColor.two blue:_secondColor.three];
}

- (void)setFirstColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;
{
    GPUVector3 firstColor = {redComponent, greenComponent, blueComponent};
    
    [self setVec3:firstColor forUniform:firstColorUniform program:filterProgram];
}

- (void)setSecondColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;
{
    GPUVector3 secondColor = {redComponent, greenComponent, blueComponent};
    
    [self setVec3:secondColor forUniform:secondColorUniform program:filterProgram];
}

- (void) setIntensity:(CGFloat)intensity
{
    _intensity = intensity;
    [self setFloat:intensity forUniform:intensityUniform program:filterProgram];
}

@end
