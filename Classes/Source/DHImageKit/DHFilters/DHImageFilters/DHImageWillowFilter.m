//
//  DHImageWillowFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageWillowFilter.h"
#import "DHImageGrayScaleFilter.h"
#import "DHImageExposureFilter.h"
#import "DHImageContrastBrightnessFilter.h"

@interface DHImageWillowFilter ()
@property (nonatomic, strong) DHImageGrayScaleFilter *grayScalceFilter;
@property (nonatomic, strong) DHImageSaturationFilter *saturationFilter;
@property (nonatomic, strong) DHImageContrastBrightnessFilter *contrastFilter;
@property (nonatomic, strong) DHImageVignetteFilter *vignetteFilter;
@property (nonatomic, strong) DHImageToneCurveFilter *curveFilter;
@end

@implementation DHImageWillowFilter

- (instancetype) init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _grayScalceFilter = [[DHImageGrayScaleFilter alloc] init];
    [self addFilter:_grayScalceFilter];
    
    _saturationFilter = [[DHImageSaturationFilter alloc] init];
    _saturationFilter.saturation = 0.80;
    [self addFilter:_saturationFilter];
    [_grayScalceFilter addTarget:_saturationFilter];
    
    _vignetteFilter = [[DHImageVignetteFilter alloc] init];
    _vignetteFilter.vignetteColor = (GPUVector3){0.35, 0.33, 0.33};
    _vignetteFilter.vignetteStart = 0.2;
    _vignetteFilter.vignetteEnd = 0.9;
    [self addFilter:_vignetteFilter];
    [_saturationFilter addTarget:_vignetteFilter];
    
    _curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"willow-curve"];
    [self addFilter:_curveFilter];
    [_vignetteFilter addTarget:_curveFilter];
    
    _contrastFilter = [[DHImageContrastBrightnessFilter alloc] init];
    _contrastFilter.contrast = 1.01;
    _contrastFilter.brightness = 0.03;
    [self addFilter:_contrastFilter];
    [_curveFilter addTarget:_contrastFilter];
    
    self.initialFilters = @[_grayScalceFilter];
    self.terminalFilter = _contrastFilter;
    
    return self;
}

@end
