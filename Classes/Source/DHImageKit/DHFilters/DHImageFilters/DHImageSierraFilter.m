//
//  DHImageSierraFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSierraFilter.h"
#import "DHImageContrastBrightnessFilter.h"
#import "DHImageRGBFilter.h"
@interface DHImageSierraFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@property (nonatomic, strong) DHImageLevelsFilter *levelsFilter;
@property (nonatomic, strong) DHImageContrastBrightnessFilter *contrastFilter;
@property (nonatomic, strong) DHImageRGBFilter *rgbFilter;
@property (nonatomic, strong) DHImageVignetteFilter *vignetteFilter;
@end

@implementation DHImageSierraFilter

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"sierra-curve"];
        [self addFilter:_toneCurveFilter];
        
        _levelsFilter = [[DHImageLevelsFilter alloc] init];
        [_levelsFilter setMin:20.f / 255.f gamma:1.f max:1.f];
        [_toneCurveFilter addTarget:_levelsFilter];
        [self addFilter:_levelsFilter];
        
        _contrastFilter = [[DHImageContrastBrightnessFilter alloc] init];
        _contrastFilter.brightness = -0.02f;
        _contrastFilter.contrast = 1.25f;
        [_levelsFilter addTarget:_contrastFilter];
        [self addFilter:_contrastFilter];
        
        _rgbFilter = [[DHImageRGBFilter alloc] init];
        _rgbFilter.red = 0.97;
        _rgbFilter.green = 0.93;
        _rgbFilter.blue = 0.96;
        [_contrastFilter addTarget:_rgbFilter];
        [self addFilter:_rgbFilter];
        
        _vignetteFilter = [[DHImageVignetteFilter alloc] init];
        _vignetteFilter.vignetteStart = 0.35;
        _vignetteFilter.vignetteColor = (GPUVector3){0.15, 0.15, 0.15};
        [_rgbFilter addTarget:_vignetteFilter];
        [self addFilter:_vignetteFilter];
        
        self.initialFilters = @[_toneCurveFilter];
        self.terminalFilter = _vignetteFilter;
    }
    return self;
}

@end
