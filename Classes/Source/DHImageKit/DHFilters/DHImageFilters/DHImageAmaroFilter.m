//
//  DHImageAmaroFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageAmaroFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHAmaroShaderString = SHADER_STRING
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
     
     vec3 vignetted;
     vignetted.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     vignetted.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     vignetted.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(vignetted.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(vignetted.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(vignetted.b, .83333)).b;
     mapped.a = 1.0;
     
     gl_FragColor = vec4(mix(texel.rgb, mapped.rgb, strength), 1.0);
 }
 );

@interface DHImageAmaroFilter ()
@property (nonatomic, strong) DHImageFourInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *blowoutPicture;
@property (nonatomic, strong) GPUImagePicture *overlayPicture;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@end

@implementation DHImageAmaroFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageFourInputFilter alloc] initWithFragmentShaderFromString:kDHAmaroShaderString];
        [self addFilter:_filter];
        
        _blowoutPicture = [DHImageFiltersHelper pictureWithImageNamed:@"blackboard1024"];
        [_blowoutPicture addTarget:_filter atTextureLocation:1];
        [_blowoutPicture processImage];
        
        _overlayPicture = [DHImageFiltersHelper pictureWithImageNamed:@"overlayMap"];
        [_overlayPicture addTarget:_filter atTextureLocation:2];
        [_overlayPicture processImage];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"amaroMap"];
        [_mapPicture addTarget:_filter atTextureLocation:3];
        [_mapPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
