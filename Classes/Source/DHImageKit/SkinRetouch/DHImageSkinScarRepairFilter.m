//
//  DHImageSkinScarRepairFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinScarRepairFilter.h"
#import "DHImageGaussianBlurFilter.h"
#import "DHImageAddBlendFilter.h"
#import "DHImageColorInvertFilter.h"
#import "DHImageLinearLightBlendFilter.h"

NSString * const kDHImageSkinRepairCompositingFilterFragmentShaderString =
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
     lowp vec4 lowF = texture2D(inputImageTexture2, textureCoordinate2);
     lowp vec4 strengthMap = texture2D(inputImageTexture3, textureCoordinate3);
     gl_FragColor = vec4(mix(image.rgb, lowF.rgb, strengthMap.a * strength), image.a);
 }
 );

@interface DHImageSkinScarRepairFilter() {
    BOOL isFirstTouch;
    CGPoint normalSkinLocation;
    
    GLuint normalSkinLocationUniform, updateSkinLocationUniform, sampleRadiusUniform;
}
@property (nonatomic, strong) DHImageGaussianBlurFilter *lowFrequencyFilter;
@property (nonatomic, strong) DHImageDissolveBlendFilter *dissolveBlendFilter;

@property (nonatomic, strong) DHImageThreeInputFilter *compositeFilter;
@property (nonatomic, strong) DHImageSharpenFilter *sharpenFilter;
@end

@implementation DHImageSkinScarRepairFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        isFirstTouch = YES;
        _lowFrequencyFilter = [[DHImageGaussianBlurFilter alloc] init];
        _lowFrequencyFilter.blurRadiusInPixels = 30;
        [self addFilter:_lowFrequencyFilter];
        
        _dissolveBlendFilter = [[DHImageDissolveBlendFilter alloc] init];
        _dissolveBlendFilter.mix = 0.85;
        [self addFilter:_dissolveBlendFilter];
        [_lowFrequencyFilter addTarget:_dissolveBlendFilter atTextureLocation:1];
        
        _sharpenFilter = [[DHImageSharpenFilter alloc] init];
        _sharpenFilter.sharpness = 3;
        [self addFilter:_sharpenFilter];
        [_dissolveBlendFilter addTarget:_sharpenFilter];
        
        _compositeFilter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinRepairCompositingFilterFragmentShaderString];
        [self addFilter:self.compositeFilter];
        [_sharpenFilter addTarget:self.compositeFilter atTextureLocation:1];
        [self.strengthMask addTarget:self.compositeFilter atTextureLocation:2];
        
        self.initialFilters = @[_lowFrequencyFilter, _dissolveBlendFilter, _compositeFilter];
        self.terminalFilter = _compositeFilter;
        
    }
    return self;
}

@end
