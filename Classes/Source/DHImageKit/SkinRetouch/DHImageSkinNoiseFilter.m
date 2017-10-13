
//
//  DHImageSkinNoiseFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/13.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinNoiseFilter.h"
#import "DHImageOverlayBlendFilter.h"
#import "DHImageThreeInputFilter.h"

NSString * const kDHImageSkinTextureCompositingFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 varying highp vec2 textureCoordinate3;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 uniform highp float strength;
 
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 noised = texture2D(inputImageTexture2, textureCoordinate2);
     lowp vec4 strengthMap = texture2D(inputImageTexture3, textureCoordinate3);
     gl_FragColor = vec4(mix(image.rgb, noised.rgb, strengthMap.a * strength), image.a);
 }
 );

@interface DHImageSkinNoiseFilter()
@property (nonatomic, strong) GPUImagePicture *noiseSource;
@property (nonatomic, strong) DHImageOverlayBlendFilter *overlayBlendFilter;
@property (nonatomic, strong) DHImageThreeInputFilter *compositeFilter;
@end

@implementation DHImageSkinNoiseFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _overlayBlendFilter = [[DHImageOverlayBlendFilter alloc] init];
        [_overlayBlendFilter disableSecondFrameCheck];
        [self addFilter:_overlayBlendFilter];
        
        _noiseSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"noise_texture.png"]];
        [_noiseSource addTarget:_overlayBlendFilter atTextureLocation:1];
        [_noiseSource processImage];
        
        _compositeFilter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinTextureCompositingFilterFragmentShaderString];
        [self addFilter:_compositeFilter];
        [_overlayBlendFilter addTarget:_compositeFilter atTextureLocation:1];
        [self.strengthMask addTarget:_compositeFilter atTextureLocation:2];
        
        self.initialFilters = @[_overlayBlendFilter, _compositeFilter];
        self.terminalFilter = _compositeFilter;
    }
    return self;
}

@end
