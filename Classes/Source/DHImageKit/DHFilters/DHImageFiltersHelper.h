//
//  DHImageFiltersHelper.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>

typedef NS_ENUM(NSInteger, DHImageFilterType) {
    DHImageFilterTypeMoon,
};

@interface DHImageFiltersHelper : NSObject

+ (NSArray *) availableFilters;

+ (GPUImageFilter *) filterForType:(DHImageFilterType)type;
@end
