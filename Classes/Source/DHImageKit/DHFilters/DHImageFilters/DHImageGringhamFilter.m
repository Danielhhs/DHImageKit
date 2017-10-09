//
//  DHImageGringhamFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageGringhamFilter.h"
#import "DHImageToneCurveFilter.h"

@interface DHImageGringhamFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@end

@implementation DHImageGringhamFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"g2-curve"];
        
        [self addFilter:_toneCurveFilter];
        
        self.initialFilters = @[_toneCurveFilter];
        self.terminalFilter = _toneCurveFilter;
    }
    return self;
}

@end
