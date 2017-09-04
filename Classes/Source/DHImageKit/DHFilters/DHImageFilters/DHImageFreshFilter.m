//
//  DHImageFreshFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFreshFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageContrastBrightnessFilter.h"

@interface DHImageFreshFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *curveFilter;
@property (nonatomic, strong) DHImageContrastBrightnessFilter *contrastFilter;
@end

@implementation DHImageFreshFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"fresh"];
        [self addFilter:_curveFilter];
        
        _contrastFilter = [[DHImageContrastBrightnessFilter alloc] init];
        _contrastFilter.brightness = -0.05;
        [_curveFilter addTarget:_contrastFilter];
        [self addFilter:_contrastFilter];
        
        self.initialFilters = @[_curveFilter];
        self.terminalFilter = _contrastFilter;
    }
    return self;
}

@end
