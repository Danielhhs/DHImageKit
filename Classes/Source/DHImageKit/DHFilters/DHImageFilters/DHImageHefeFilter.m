//
//  DHImageHefeFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageHefeFilter.h"
#import "DHImageSixInputFilter.h"
#import "DHImageFiltersHelper.h"

NSString *const kDHHefeShaderString = SHADER_STRING
(
precision lowp float;

varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;  //edgeBurn
uniform sampler2D inputImageTexture3;  //hefeMap
uniform sampler2D inputImageTexture4;  //hefeGradientMap
uniform sampler2D inputImageTexture5;  //hefeSoftLight
uniform sampler2D inputImageTexture6;  //hefeMetal

uniform mediump float strength;
 
void main()
{
    vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
    vec3 edge = texture2D(inputImageTexture2, textureCoordinate).rgb;
    vec3 texel = originalTexel * edge;
    
    texel = vec3(
                 texture2D(inputImageTexture3, vec2(texel.r, .16666)).r,
                 texture2D(inputImageTexture3, vec2(texel.g, .5)).g,
                 texture2D(inputImageTexture3, vec2(texel.b, .83333)).b);
    
    vec3 luma = vec3(.30, .59, .11);
    vec3 gradSample = texture2D(inputImageTexture4, vec2(dot(luma, texel), .5)).rgb;
    vec3 final = vec3(
                      texture2D(inputImageTexture5, vec2(gradSample.r, texel.r)).r,
                      texture2D(inputImageTexture5, vec2(gradSample.g, texel.g)).g,
                      texture2D(inputImageTexture5, vec2(gradSample.b, texel.b)).b
                      );
    
    vec3 metal = texture2D(inputImageTexture6, textureCoordinate).rgb;
    vec3 metaled = vec3(
                        texture2D(inputImageTexture5, vec2(metal.r, texel.r)).r,
                        texture2D(inputImageTexture5, vec2(metal.g, texel.g)).g,
                        texture2D(inputImageTexture5, vec2(metal.b, texel.b)).b
                        );
    
    gl_FragColor = vec4(mix(originalTexel ,metaled, strength), 1.0);
}
);

@interface DHImageHefeFilter ()
@property (nonatomic, strong) DHImageSixInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *edgeBurnPicture;
@property (nonatomic, strong) GPUImagePicture *hefeMapPicture;
@property (nonatomic, strong) GPUImagePicture *hefeGradientMapPicture;
@property (nonatomic, strong) GPUImagePicture *hefeSoftLightPicture;
@property (nonatomic, strong) GPUImagePicture *hefeMetalPicture;

@end

@implementation DHImageHefeFilter
- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageSixInputFilter alloc] initWithFragmentShaderFromString:kDHHefeShaderString];
        [self addFilter:_filter];
        
        _edgeBurnPicture = [DHImageFiltersHelper pictureWithImageNamed:@"edgeBurn"];
        [_edgeBurnPicture addTarget:_filter atTextureLocation:1];
        [_edgeBurnPicture processImage];
        
        _hefeMapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"hefeMap"];
        [_hefeMapPicture addTarget:_filter atTextureLocation:2];
        [_hefeMapPicture processImage];
        
        _hefeGradientMapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"hefeGradientMap"];
        [_hefeGradientMapPicture addTarget:_filter atTextureLocation:3];
        [_hefeGradientMapPicture processImage];
        
        _hefeSoftLightPicture = [DHImageFiltersHelper pictureWithImageNamed:@"hefeSoftLight"];
        [_hefeSoftLightPicture addTarget:_filter atTextureLocation:4];
        [_hefeSoftLightPicture processImage];
        
        _hefeMetalPicture = [DHImageFiltersHelper pictureWithImageNamed:@"hefeMetal"];
        [_hefeMetalPicture addTarget:_filter atTextureLocation:5];
        [_hefeMetalPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}
@end
