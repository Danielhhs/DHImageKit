//
//  DHImageJunoFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageJunoFilter.h"

@interface DHImageJunoFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *curveFilter;
@property (nonatomic, strong) DHImageVignetteFilter *vignetteFilter;
@end

@implementation DHImageJunoFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _vignetteFilter = [[DHImageVignetteFilter alloc] init];
        _vignetteFilter.vignetteColor = (GPUVector3) {0.3, 0.3, 0.3};
        _vignetteFilter.vignetteStart = 0.5;
        [self addFilter:_vignetteFilter];
        
        _curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"juno-curve"];
        [self addFilter:_curveFilter];
        [_vignetteFilter addTarget:_curveFilter];
        
        self.initialFilters = @[_vignetteFilter];
        self.terminalFilter = _curveFilter;
    }
    return self;
}

@end
