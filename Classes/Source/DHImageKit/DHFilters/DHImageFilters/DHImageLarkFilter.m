//
//  DHImageLarkFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageLarkFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageContrastBrightnessFilter.h"
@interface DHImageLarkFilter()
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@property (nonatomic, strong) DHImageContrastBrightnessFilter *brightnessFilter;
@end

@implementation DHImageLarkFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"l1-curve"];
        [self addFilter:_toneCurveFilter];
        
        _brightnessFilter = [[DHImageContrastBrightnessFilter alloc] init];
        _brightnessFilter.brightness = 0.0618;
        [self addFilter:_brightnessFilter];
        [_toneCurveFilter addTarget:_brightnessFilter];
        
        self.initialFilters = @[_toneCurveFilter];
        self.terminalFilter = _brightnessFilter;
    }
    return self;
}
@end
