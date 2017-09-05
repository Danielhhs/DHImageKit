//
//  DHImageXprollFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageXprollFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHXproIIShaderString = SHADER_STRING
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
     
     vec3 texel;
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, originalTexel.r);
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = originalTexel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = originalTexel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     vec2 red = vec2(texel.r, 0.16666);
     vec2 green = vec2(texel.g, 0.5);
     vec2 blue = vec2(texel.b, .83333);
     texel.r = texture2D(inputImageTexture2, red).r;
     texel.g = texture2D(inputImageTexture2, green).g;
     texel.b = texture2D(inputImageTexture2, blue).b;
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
     
 }
 );

@interface DHImageXprollFilter ()
@property (nonatomic, strong) DHImageThreeInputFilter *filter;

@property (nonatomic, strong) GPUImagePicture *mapPicture;
@property (nonatomic, strong) GPUImagePicture *vignettePicture;
@end

@implementation DHImageXprollFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHXproIIShaderString];
        [self addFilter:_filter];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"xproMap"];
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
