//
//  DHImageInkWellFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageInkWellFilter.h"
#import "DHImageTwoInputFilter.h"
#import "DHImageFiltersHelper.h"
NSString *const kDHInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform mediump float strength;
 
 void main()
 {
     vec3 originalTexel = texture2D(inputImageTexture, textureCoordinate).rgb;
     vec3 texel = vec3(dot(vec3(0.3, 0.6, 0.1), originalTexel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
     gl_FragColor = vec4(mix(originalTexel, texel, strength), 1.0);
 }
 );

@interface DHImageInkWellFilter ()
@property (nonatomic, strong) DHImageTwoInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *mapPicture;
@end

@implementation DHImageInkWellFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageTwoInputFilter alloc] initWithFragmentShaderFromString:kDHInkWellShaderString];
        [self addFilter:_filter];
        
        _mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"i1Map"];
        [_mapPicture addTarget:_filter atTextureLocation:1];
        [_mapPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
