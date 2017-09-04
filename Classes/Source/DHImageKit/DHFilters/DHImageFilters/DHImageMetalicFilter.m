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

@interface DHImageMetalicFilter ()
@property (nonatomic, strong) DHImageContrastBrightnessFilter *contrastBrightnessFilter;
@property (nonatomic, strong) DHImageLevelsFilter *levelsFilter;
@end

@implementation DHImageMetalicFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _contrastBrightnessFilter = [[DHImageContrastBrightnessFilter alloc] init];
        _contrastBrightnessFilter.contrast = 1.5;
        _contrastBrightnessFilter.brightness = -0.2;
        [self addFilter:_contrastBrightnessFilter];
        
        _levelsFilter = [[DHImageLevelsFilter alloc] init];
        [_levelsFilter setMin:0 gamma:0.69 max:1.f];
        [_contrastBrightnessFilter addTarget:_levelsFilter];
        [self addFilter:_levelsFilter];
        
        self.initialFilters = @[_contrastBrightnessFilter];
        self.terminalFilter = _levelsFilter;
    }
    return self;
}

@end
