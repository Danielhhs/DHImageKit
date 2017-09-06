//
//  DHImageSutroFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSutroFilter.h"
#import "DHImageSixInputFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHSutroShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //sutroMap;
 uniform sampler2D inputImageTexture3; //sutroMetal;
 uniform sampler2D inputImageTexture4; //softLight
 uniform sampler2D inputImageTexture5; //sutroEdgeburn
 uniform sampler2D inputImageTexture6; //sutroCurves
 
 uniform mediump float strength;
 
 void main()
 {
     
     vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
     vec3 texel;
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, originalTexel.r);
     texel.r = texture2D(inputImageTexture2, lookup).r;
     lookup.y = originalTexel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     lookup.y = originalTexel.b;
     texel.b	= texture2D(inputImageTexture2, lookup).b;
     
     vec3 rgbPrime = vec3(0.1019, 0.0, 0.0);
     float m = dot(vec3(.3, .59, .11), texel.rgb) - 0.03058;
     texel = mix(texel, rgbPrime + m, 0.32);
     
     vec3 metal = texture2D(inputImageTexture3, textureCoordinate).rgb;
     texel.r = texture2D(inputImageTexture4, vec2(metal.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture4, vec2(metal.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture4, vec2(metal.b, texel.b)).b;
     
     texel = texel * texture2D(inputImageTexture5, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture6, vec2(texel.r, .16666)).r;
     texel.g = texture2D(inputImageTexture6, vec2(texel.g, .5)).g;
     texel.b = texture2D(inputImageTexture6, vec2(texel.b, .83333)).b;
     
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
 }
 );

@interface DHImageSutroFilter ()
@property (nonatomic, strong) DHImageSixInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@property (nonatomic, strong) GPUImagePicture *metalPicture;
@property (nonatomic, strong) GPUImagePicture *softLightPicture;
@property (nonatomic, strong) GPUImagePicture *edgeBurnPicture;
@property (nonatomic, strong) GPUImagePicture *curvesPicture;
@end
@implementation DHImageSutroFilter
- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageSixInputFilter alloc] initWithFragmentShaderFromString:kDHSutroShaderString];
        [self addFilter:_filter];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"vignetteMap"];
        [_mapPicture addTarget:_filter atTextureLocation:1];
        [_mapPicture processImage];
        
        _metalPicture = [DHImageFiltersHelper pictureWithImageNamed:@"sutroMetal"];
        [_metalPicture addTarget:_filter atTextureLocation:2];
        [_metalPicture processImage];
        
        _softLightPicture = [DHImageFiltersHelper pictureWithImageNamed:@"softLight"];
        [_softLightPicture addTarget:_filter atTextureLocation:3];
        [_softLightPicture processImage];
        
        _edgeBurnPicture = [DHImageFiltersHelper pictureWithImageNamed:@"sutroEdgeBurn"];
        [_edgeBurnPicture addTarget:_filter atTextureLocation:4];
        [_edgeBurnPicture processImage];
        
        _curvesPicture = [DHImageFiltersHelper pictureWithImageNamed:@"sutroCurves"];
        [_curvesPicture addTarget:_filter atTextureLocation:5];
        [_curvesPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}
@end
