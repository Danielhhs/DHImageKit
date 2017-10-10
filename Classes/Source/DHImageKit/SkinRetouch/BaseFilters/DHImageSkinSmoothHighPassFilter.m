//
//  DHImageSkinSmoothHighPassFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinSmoothHighPassFilter.h"
NSString * const kDHImageSkinSmoothHighPassFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main() {
     highp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     highp vec4 blurredImage = texture2D(inputImageTexture2, textureCoordinate);
     gl_FragColor = vec4((image.rgb - blurredImage.rgb + vec3(0.5,0.5,0.5)), image.a);
 }
 );

@interface DHImageSkinSmoothHighPassFilter ()
@property (nonatomic, strong) GPUImageGaussianBlurFilter *blurFilter;
@property (nonatomic, strong) GPUImageTwoInputFilter *highPassFilter;
@end

@implementation DHImageSkinSmoothHighPassFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [self addFilter:_blurFilter];
        
        _highPassFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinSmoothHighPassFilterFragmentShaderString];
        [_blurFilter addTarget:_highPassFilter atTextureLocation:1];
        
        self.initialFilters = @[_blurFilter, _highPassFilter];
        self.terminalFilter = _highPassFilter;
    }
    return self;
}

- (void) setRadiusInPixels:(CGFloat)radiusInPixels
{
    _radiusInPixels = radiusInPixels;
    self.blurFilter.blurRadiusInPixels = radiusInPixels;
}

- (void) updateWithStrength:(double)strength
{
    
}

@end
