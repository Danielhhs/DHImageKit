//
//  DHImageLofiFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageLofiFilter.h"
#import "DHImageThreeInputFilter.h"
#import "DHImageFiltersHelper.h"

NSString *const kDHLomofiShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 uniform mediump float strength;
 
 void main()
 {
     
     vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
     vec3 texel;
     vec2 red = vec2(originalTexel.r, 0.16666);
     vec2 green = vec2(originalTexel.g, 0.5);
     vec2 blue = vec2(originalTexel.b, 0.83333);
     
     texel.rgb = vec3(
                      texture2D(inputImageTexture2, red).r,
                      texture2D(inputImageTexture2, green).g,
                      texture2D(inputImageTexture2, blue).b);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength),1.0);
 }
 );

@interface DHImageLofiFilter ()
@property (nonatomic, strong) DHImageThreeInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@property (nonatomic, strong) GPUImagePicture *vignettePicture;

@end

@implementation DHImageLofiFilter


- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHLomofiShaderString];
        [self addFilter:_filter];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"lomoMap"];
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
