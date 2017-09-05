//
//  DHImageHudsonFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageHudsonFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHHudsonShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;
 uniform sampler2D inputImageTexture3; //overlay;
 uniform sampler2D inputImageTexture4; //map
 
 uniform mediump float strength;
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     
     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     vec3 overlayMap;
     overlayMap.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     overlayMap.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     overlayMap.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(overlayMap.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(overlayMap.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(overlayMap.b, .83333)).b;
     mapped.a = 1.0;
     
     gl_FragColor = vec4(mix(texel.rgb, mapped.rgb, strength), mapped.a);
 }
 );

@interface DHImageHudsonFilter ()
@property (nonatomic, strong) DHImageFourInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *blowOutPicture;
@property (nonatomic, strong) GPUImagePicture *overlayPicture;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@end

@implementation DHImageHudsonFilter

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        _filter = [[DHImageFourInputFilter alloc] initWithFragmentShaderFromString:kDHHudsonShaderString];
        [self addFilter:_filter];
        
        _blowOutPicture = [DHImageFiltersHelper pictureWithImageNamed:@"hudsonBackground"];
        [_blowOutPicture addTarget:_filter atTextureLocation:1];
        [_blowOutPicture processImage];
        
        _overlayPicture = [DHImageFiltersHelper pictureWithImageNamed:@"overlayMap"];
        [_overlayPicture addTarget:_filter atTextureLocation:2];
        [_overlayPicture processImage];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"hudsonMap"];
        [_mapPicture addTarget:_filter atTextureLocation:3];
        [_mapPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
