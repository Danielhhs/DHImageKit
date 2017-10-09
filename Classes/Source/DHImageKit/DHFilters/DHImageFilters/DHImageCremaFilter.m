//
//  DHImageCremaFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageCremaFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageContrastBrightnessFilter.h"
#import "DHImageSaturationFilter.h"
@interface DHImageCremaFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@property (nonatomic, strong) DHImageSaturationFilter *saturationFilter;
@property (nonatomic, strong) DHImageContrastBrightnessFilter *contrastFilter;
@end

@implementation DHImageCremaFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"c2-curve"];
        [self addFilter:_toneCurveFilter];
        
        _saturationFilter = [[DHImageSaturationFilter alloc] init];
        _saturationFilter.saturation = 0.618;
        [_toneCurveFilter addTarget:_saturationFilter];
        [self addFilter:_toneCurveFilter];
        
        _contrastFilter = [[DHImageContrastBrightnessFilter alloc] init];
        _contrastFilter.contrast = 1.5f;
        _contrastFilter.brightness = 0.06;
        [_saturationFilter addTarget:_contrastFilter];
        [self addFilter:_contrastFilter];
        
        self.initialFilters = @[_toneCurveFilter];
        self.terminalFilter = _contrastFilter;
    }
    return self;
}

@end
