//
//  DHImageFreshFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFreshFilter.h"
#import "DHImageToneCurveFilter.h"

@interface DHImageFreshFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *curveFilter;
@end

@implementation DHImageFreshFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"fresh"];
        [self addFilter:_curveFilter];
        
        self.initialFilters = @[_curveFilter];
        self.terminalFilter = _curveFilter;
    }
    return self;
}

@end
