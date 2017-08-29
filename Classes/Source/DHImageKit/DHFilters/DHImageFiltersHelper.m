//
//  DHImageFiltersHelper.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFiltersHelper.h"
#import "DHMoonFilter.h"

@implementation DHImageFiltersHelper

+ (GPUImageFilter *)filterForType:(DHImageFilterType)type
{
    switch (type) {
        case DHImageFilterTypeMoon:
            return [[DHMoonFilter alloc] init];
            break;
        default:
            break;
    }
    return nil;
}

+ (NSArray *) availableFilters
{
    return @[@"Moon"];
}
@end
