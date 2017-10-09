//
//  DHImageMetalicFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageMetalicFilter.h"
#import "DHImageSixInputFilter.h"
#import "DHImageFiltersHelper.h"

NSString *const kDHFBrannanShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;  //process
 uniform sampler2D inputImageTexture3;  //blowout
 uniform sampler2D inputImageTexture4;  //contrast
 uniform sampler2D inputImageTexture5;  //luma
 uniform sampler2D inputImageTexture6;  //screen
 
 uniform mediump float strength;
 
 mat3 saturateMatrix = mat3(
                            1.105150,
                            -0.044850,
                            -0.046000,
                            -0.088050,
                            1.061950,
                            -0.089200,
                            -0.017100,
                            -0.017100,
                            1.132900);
 
 vec3 luma = vec3(.3, .59, .11);
 
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
     
     texel = saturateMatrix * texel;
     
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec3 sampled;
     lookup.y = 0.5;
     lookup.x = texel.r;
     sampled.r = texture2D(inputImageTexture3, lookup).r;
     lookup.x = texel.g;
     sampled.g = texture2D(inputImageTexture3, lookup).g;
     lookup.x = texel.b;
     sampled.b = texture2D(inputImageTexture3, lookup).b;
     float value = smoothstep(0.0, 1.0, d);
     texel = mix(sampled, texel, value);
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture4, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture4, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture4, lookup).b;
     
     
     lookup.x = dot(texel, luma);
     texel = mix(texture2D(inputImageTexture5, lookup).rgb, texel, .5);
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture6, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture6, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture6, lookup).b;
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
 }
 );
@interface DHImageMetalicFilter ()
@property (nonatomic, strong) DHImageSixInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *processPicture;
@property (nonatomic, strong) GPUImagePicture *blowoutPicture;
@property (nonatomic, strong) GPUImagePicture *contrastPicture;
@property (nonatomic, strong) GPUImagePicture *lumaPicture;
@property (nonatomic, strong) GPUImagePicture *screenPicture;
@end

@implementation DHImageMetalicFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageSixInputFilter alloc] initWithFragmentShaderFromString:kDHFBrannanShaderString];
        [self addFilter:_filter];
        
        _processPicture = [DHImageFiltersHelper pictureWithImageNamed:@"metalicProcess"];
        [_processPicture addTarget:_filter atTextureLocation:1];
        [_processPicture processImage];
        
        _blowoutPicture = [DHImageFiltersHelper pictureWithImageNamed:@"metalicBlowout"];
        [_blowoutPicture addTarget:_filter atTextureLocation:2];
        [_blowoutPicture processImage];
        
        _contrastPicture = [DHImageFiltersHelper pictureWithImageNamed:@"metalicContrast"];
        [_contrastPicture addTarget:_filter atTextureLocation:3];
        [_contrastPicture processImage];
        
        _lumaPicture = [DHImageFiltersHelper pictureWithImageNamed:@"metalicLuma"];
        [_lumaPicture addTarget:_filter atTextureLocation:4];
        [_lumaPicture processImage];
        
        _screenPicture = [DHImageFiltersHelper pictureWithImageNamed:@"metalicScreen"];
        [_screenPicture addTarget:_filter atTextureLocation:5];
        [_screenPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
