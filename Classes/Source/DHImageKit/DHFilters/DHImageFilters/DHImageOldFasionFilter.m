//
//  DHImageOldFasionFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageOldFasionFilter.h"

@interface DHImageOldFasionFilter ()
@property (nonatomic, strong) GPUImageToneCurveFilter *curveFilter;
@end

@implementation DHImageOldFasionFilter

- (instancetype) init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"old-fasion.acv"];
    [self addFilter:_curveFilter];
    
    self.initialFilters = @[_curveFilter];
    self.terminalFilter = _curveFilter;
    
    return self;
}

- (void) updateWithStrength:(double)strength
{
    
}

@end
