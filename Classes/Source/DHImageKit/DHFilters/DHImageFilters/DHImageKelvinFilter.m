//
//  DHImageKelvinFIlter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageKelvinFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHLordKelvinShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform mediump float strength;
 
 void main()
 {
     vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec3 texel;
     vec2 lookup;
     lookup.y = .5;
     
     lookup.x = originalTexel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     
     lookup.x = originalTexel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     
     lookup.x = originalTexel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
 }
 );

@interface DHImageKelvinFilter ()
@property (nonatomic, strong) DHImageTwoInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@end

@implementation DHImageKelvinFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageTwoInputFilter alloc] initWithFragmentShaderFromString:kDHLordKelvinShaderString];
        [self addFilter:_filter];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"k1Map"];
        [_mapPicture addTarget:_filter atTextureLocation:1];
        [_mapPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
