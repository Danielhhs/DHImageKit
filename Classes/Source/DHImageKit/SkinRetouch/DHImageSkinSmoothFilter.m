//
//  DHImageSkinSmoothFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinSmoothFilter.h"
#import "DHImageColorInvertFilter.h"

@interface DHImageSkinSmoothFilter ()
@property (nonatomic, strong) DHImageColorInvertFilter *colorInvertFilter;
@end

@implementation DHImageSkinSmoothFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _colorInvertFilter = [[DHImageColorInvertFilter alloc] init];
        [self addFilter:_colorInvertFilter];
        
        self.initialFilters = @[_colorInvertFilter];
        self.terminalFilter = _colorInvertFilter;
    }
    return self;
}

- (void) updateWithStrength:(double)strength
{
    self.strength = strength;
    for (int i = 0; i < self.filterCount; i++) {
        id<DHImageUpdatable> updatable = (id<DHImageUpdatable>)[self filterAtIndex:i];
        [updatable updateWithStrength:strength];
    }
}

@end
