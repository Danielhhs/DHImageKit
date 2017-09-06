//
//  DHImageNormalFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageNormalFilter.h"

@interface DHImageNormalFilter ()
@property (nonatomic, strong) GPUImageFilter *filter;
@end

@implementation DHImageNormalFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[GPUImageFilter alloc] init];
        [self addFilter:_filter];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
