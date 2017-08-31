//
//  DHImageFiltersHelper.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFiltersHelper.h"
#import "DHImageGrayFilter.h"

@implementation DHImageFiltersHelper

+ (DHImageFilter *)filterForType:(DHImageFilterType)type
{
    switch (type) {
        case DHImageFilterTypeGray:
            return [[DHImageGrayFilter alloc] init];
            break;
        default:
            break;
    }
    return nil;
}

+ (NSArray *) availableFilters
{
    DHImageFilterInfo *filterInfo = [DHImageFilterInfo filterInfoForFilterClass:[DHImageGrayFilter class] name:@"Gray" type:DHImageFilterTypeGray];
    return @[filterInfo];
}

+ (GPUImagePicture *) pictureWithImageNamed:(NSString *)imageName
{
    UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    
    return [[GPUImagePicture alloc] initWithImage:image];
    
}
@end
