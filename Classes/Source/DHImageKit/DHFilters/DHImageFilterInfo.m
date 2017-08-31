//
//  DHFilterInfo.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFilterInfo.h"

@implementation DHImageFilterInfo

+ (DHImageFilterInfo *) filterInfoForFilterClass:(Class)filterClass
                                            name:(NSString *)name
                                            type:(DHImageFilterType)filterType
{
    DHImageFilterInfo *info = [[DHImageFilterInfo alloc] init];
    info.filterName = name;
    info.filterType = filterType;
    info.filterClass = filterClass;
    return info;
}

@end
