//
//  DHImageFoodFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFoodFilter.h"
#import "DHImageContrastBrightnessFilter.h"
#import "DHImagePosterizeFilter.h"
#import "DHImageLevelsFilter.h"
#import "DHImageSaturationFilter.h"

@interface DHImageFoodFilter ()
@property (nonatomic, strong) DHImageContrastBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) DHImagePosterizeFilter *posterizeFilter;
@property (nonatomic, strong) DHImageLevelsFilter *levelsFilter;
@property (nonatomic, strong) DHImageSaturationFilter *saturationFilter;
@end

@implementation DHImageFoodFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _brightnessFilter = [[DHImageContrastBrightnessFilter alloc] init];
        _brightnessFilter.brightness = 0.15;
        _brightnessFilter.contrast = 1.382;
        [self addFilter:_brightnessFilter];
        
        _posterizeFilter = [[DHImagePosterizeFilter alloc] init];
        _posterizeFilter.colorLevels = 25.f;
        [self addFilter:_posterizeFilter];
        [_brightnessFilter addTarget:_posterizeFilter];
        
        _levelsFilter = [[DHImageLevelsFilter alloc] init];
        [_levelsFilter setMin:7.f / 255.f gamma:1.1 max:239.f/255.f];
        [_posterizeFilter addTarget:_levelsFilter];
        [self addFilter:_levelsFilter];
        
        _saturationFilter = [[DHImageSaturationFilter alloc] init];
        _saturationFilter.saturation = 1.3;
        [self addFilter:_saturationFilter];
        [_levelsFilter addTarget:_saturationFilter];
        
        self.initialFilters = @[_brightnessFilter];
        self.terminalFilter = _saturationFilter;
    }
    return self;
}

@end
