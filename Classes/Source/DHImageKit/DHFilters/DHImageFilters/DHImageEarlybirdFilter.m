//
//  DHImageEarlybirdFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageEarlybirdFilter.h"
#import "DHImageSixInputFilter.h"
#import "DHImageFiltersHelper.h"
#define pow pow
NSString *const kDHEarlybirdShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //earlyBirdCurves
 uniform sampler2D inputImageTexture3; //earlyBirdOverlay
 uniform sampler2D inputImageTexture4; //vig
 uniform sampler2D inputImageTexture5; //earlyBirdBlowout
 uniform sampler2D inputImageTexture6; //earlyBirdMap
 
 uniform mediump float strength;
 
 const mat3 saturate = mat3(
                            1.210300,
                            -0.089700,
                            -0.091000,
                            -0.176100,
                            1.123900,
                            -0.177400,
                            -0.034200,
                            -0.034200,
                            1.265800);
 const vec3 rgbPrime = vec3(0.25098, 0.14640522, 0.0);
 const vec3 desaturate = vec3(.3, .59, .11);
 
 void main()
 {
     
     vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
     vec3 texel;
     
     
     vec2 lookup;
     lookup.y = 0.5;
     
     lookup.x = originalTexel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     
     lookup.x = originalTexel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     
     lookup.x = originalTexel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     float desaturatedColor;
     vec3 result;
     desaturatedColor = dot(desaturate, texel);
     
     
     lookup.x = desaturatedColor;
     result.r = texture2D(inputImageTexture3, lookup).r;
     lookup.x = desaturatedColor;
     result.g = texture2D(inputImageTexture3, lookup).g;
     lookup.x = desaturatedColor;
     result.b = texture2D(inputImageTexture3, lookup).b;
     
     texel = saturate * mix(texel, result, .5);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     
     vec3 sampled;
     lookup.y = .5;
     
     /*
      lookup.x = texel.r;
      sampled.r = texture2D(inputImageTexture4, lookup).r;
      
      lookup.x = texel.g;
      sampled.g = texture2D(inputImageTexture4, lookup).g;
      
      lookup.x = texel.b;
      sampled.b = texture2D(inputImageTexture4, lookup).b;
      
      float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
      texel = mix(texel, sampled, value);
      */
     
     //---
     
     lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture4, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture4, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture4, lookup).b;
     float value = smoothstep(0.0, 1.25, pow(d, 1.35)/1.65);
     
     //---
     
     lookup.x = texel.r;
     sampled.r = texture2D(inputImageTexture5, lookup).r;
     lookup.x = texel.g;
     sampled.g = texture2D(inputImageTexture5, lookup).g;
     lookup.x = texel.b;
     sampled.b = texture2D(inputImageTexture5, lookup).b;
     texel = mix(sampled, texel, value);
     
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture6, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture6, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture6, lookup).b;
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
 }
 );

@interface DHImageEarlybirdFilter ()
@property (nonatomic, strong) DHImageSixInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *curvePicture;
@property (nonatomic, strong) GPUImagePicture *overlayPicture;
@property (nonatomic, strong) GPUImagePicture *vignettePicture;
@property (nonatomic, strong) GPUImagePicture *blowoutPicture;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@end

@implementation DHImageEarlybirdFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageSixInputFilter alloc] initWithFragmentShaderFromString:kDHEarlybirdShaderString];
        [self addFilter:_filter];
        
        _curvePicture = [DHImageFiltersHelper pictureWithImageNamed:@"earlyBirdCurves"],
        [_curvePicture addTarget:_filter atTextureLocation:1];
        [_curvePicture processImage];
        
        _overlayPicture = [DHImageFiltersHelper pictureWithImageNamed:@"earlybirdOverlayMap"],
        [_overlayPicture addTarget:_filter atTextureLocation:2];
        [_overlayPicture processImage];
        
        _vignettePicture = [DHImageFiltersHelper pictureWithImageNamed:@"vignetteMap"],
        [_vignettePicture addTarget:_filter atTextureLocation:3];
        [_vignettePicture processImage];
        
        _blowoutPicture = [DHImageFiltersHelper pictureWithImageNamed:@"earlybirdBlowout"],
        [_blowoutPicture addTarget:_filter atTextureLocation:4];
        [_blowoutPicture processImage];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"earlybirdMap"],
        [_mapPicture addTarget:_filter atTextureLocation:5];
        [_mapPicture processImage];
        
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
