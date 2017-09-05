//
//  DHImageNashvilleFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageNashvilleFilter.h"
#import "DHImageTwoInputFilter.h"
#import "DHImageFiltersHelper.h"

NSString *const kDHNashvilleShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform mediump float strength;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     vec3 mappedTexel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     gl_FragColor = vec4(mix(texel, mappedTexel, strength), 1.0);
 }
 );
@interface DHImageNashvilleFilter ()
@property (nonatomic, strong) DHImageTwoInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *picture;
@end

@implementation DHImageNashvilleFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageTwoInputFilter alloc] initWithFragmentShaderFromString:kDHNashvilleShaderString];
        
        _picture = [DHImageFiltersHelper pictureWithImageNamed:@"nashvilleMap"];
        [_picture addTarget:_filter atTextureLocation:1];
        [_picture processImage];
        
        [self addFilter:_filter];
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
