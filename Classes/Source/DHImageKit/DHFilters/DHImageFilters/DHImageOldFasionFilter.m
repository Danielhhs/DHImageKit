//
//  DHImageOldFasionFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageOldFasionFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageColorDarkenBlendFilter.h"

@interface DHImageOldFasionFilter ()
@property (nonatomic, strong) DHImageToneCurveFilter *curveFilter;
@property (nonatomic, strong) DHImageColorDarkenBlendFilter *darkenFilter;

@end

@implementation DHImageOldFasionFilter

- (instancetype) init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"old-fashion"];
    [self addFilter:_curveFilter];
    
    _darkenFilter = [[DHImageColorDarkenBlendFilter alloc] init];
    _darkenFilter.blendColor = [UIColor colorWithRed:211.f / 255.f green:1.f blue:215.f / 255.f alpha:1.f];
    [self addFilter:_darkenFilter];
    [_curveFilter addTarget:_darkenFilter];
    
    self.initialFilters = @[_curveFilter];
    self.terminalFilter = _darkenFilter;
    
    return self;
}

- (NSString *) name
{
    return @"Old Fashion";
}

@end
