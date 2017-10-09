//
//  DHImageClarendonFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageClarendonFilter.h"

@interface DHImageClarendonFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *curveFilter;
@end

@implementation DHImageClarendonFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"c1-curve"];
        [self addFilter:_curveFilter];
        
        self.initialFilters = @[_curveFilter];
        self.terminalFilter = _curveFilter;
    }
    return self;
}

@end
