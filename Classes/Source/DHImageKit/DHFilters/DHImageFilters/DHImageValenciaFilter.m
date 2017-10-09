//
//  DHImageValenciaFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageValenciaFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHValenciaShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //map
 uniform sampler2D inputImageTexture3; //gradMap
 
 uniform mediump float strength;
 
 mat3 saturateMatrix = mat3(
                            1.1402,
                            -0.0598,
                            -0.061,
                            -0.1174,
                            1.0826,
                            -0.1186,
                            -0.0228,
                            -0.0228,
                            1.1772);
 
 vec3 lumaCoeffs = vec3(.3, .59, .11);
 
 void main()
 {
     vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec3 texel = vec3(
                  texture2D(inputImageTexture2, vec2(originalTexel.r, .1666666)).r,
                  texture2D(inputImageTexture2, vec2(originalTexel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(originalTexel.b, .8333333)).b
                  );
     
     texel = saturateMatrix * texel;
     float luma = dot(lumaCoeffs, texel);
     texel = vec3(
                  texture2D(inputImageTexture3, vec2(luma, texel.r)).r,
                  texture2D(inputImageTexture3, vec2(luma, texel.g)).g,
                  texture2D(inputImageTexture3, vec2(luma, texel.b)).b);
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
 }
 );

@interface DHImageValenciaFilter ()
@property (nonatomic, strong) DHImageThreeInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@property (nonatomic, strong) GPUImagePicture *gradientMapPicture;
@end

@implementation DHImageValenciaFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHValenciaShaderString];
        [self addFilter:_filter];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"v1Map"];
        [_mapPicture addTarget:_filter atTextureLocation:1];
        [_mapPicture processImage];
        
        _gradientMapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"v1GradientMap"];
        [_gradientMapPicture addTarget:_filter atTextureLocation:2];
        [_gradientMapPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
