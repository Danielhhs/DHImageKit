//
//  DHImageMetalicFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageMetalicFilter.h"
#import "DHImageContrastBrightnessFilter.h"
#import "DHImageLevelsFilter.h"
#import "DHImageColorMultiplyBlendFilter.h"
#import "DHImageVignetteFilter.h"

@interface DHImageMetalicFilter ()
@property (nonatomic, strong) DHImageContrastBrightnessFilter *contrastBrightnessFilter;
@property (nonatomic, strong) DHImageLevelsFilter *levelsFilter;
@property (nonatomic, strong) DHImageColorMultiplyBlendFilter *multiplyFilter;
@property (nonatomic, strong) DHImageVignetteFilter *vignetteFilter;
@end

@implementation DHImageMetalicFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _contrastBrightnessFilter = [[DHImageContrastBrightnessFilter alloc] init];
        _contrastBrightnessFilter.contrast = 1.382;
        _contrastBrightnessFilter.brightness = -0.1;
        [self addFilter:_contrastBrightnessFilter];
        
        _levelsFilter = [[DHImageLevelsFilter alloc] init];
        [_levelsFilter setMin:0 gamma:0.86 max:1.f];
        [_contrastBrightnessFilter addTarget:_levelsFilter];
        [self addFilter:_levelsFilter];
        
        _multiplyFilter = [[DHImageColorMultiplyBlendFilter alloc] init];
        _multiplyFilter.blendColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:206.f/255.f alpha:0.86];
        [_levelsFilter addTarget:_multiplyFilter];
        [self addFilter:_multiplyFilter];
        
        _vignetteFilter = [[DHImageVignetteFilter alloc] init];
        _vignetteFilter.vignetteStart = 0.5;
        [_multiplyFilter addTarget:_vignetteFilter];
        [self addFilter:_vignetteFilter];
        
        self.initialFilters = @[_contrastBrightnessFilter];
        self.terminalFilter = _vignetteFilter;
    }
    return self;
}

@end
