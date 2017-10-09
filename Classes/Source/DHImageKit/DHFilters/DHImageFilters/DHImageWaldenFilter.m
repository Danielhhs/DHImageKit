//
//  DHImageWaldenFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageWaldenFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHWaldenShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //map
 uniform sampler2D inputImageTexture3; //vigMap
 
 uniform mediump float strength;
 
 void main()
 {
     
     vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
    
     vec3 texel = vec3(
                  texture2D(inputImageTexture2, vec2(originalTexel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(originalTexel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(originalTexel.b, .83333)).b);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
 }
 );
@interface DHImageWaldenFilter ()
@property (nonatomic, strong) DHImageThreeInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@property (nonatomic, strong) GPUImagePicture *vignettePicture;
@end

@implementation DHImageWaldenFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHWaldenShaderString];
        [self addFilter:_filter];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"w1Map"];
        [_mapPicture addTarget:_filter atTextureLocation:1];
        [_mapPicture processImage];
        
        _vignettePicture = [DHImageFiltersHelper pictureWithImageNamed:@"vignetteMap"];
        [_vignettePicture addTarget:_filter atTextureLocation:2];
        [_vignettePicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
