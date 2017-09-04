//
//  DHImageFiltersHelper.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFiltersHelper.h"
#import "DHImageGrayFilter.h"
#import "DHImageOldFasionFilter.h"
#import "DHImageFreshFilter.h"
#import "DHImageMetalicFilter.h"
#import "DHImageGringhamFilter.h"
#import "DHImageSierraFilter.h"

@implementation DHImageFiltersHelper

+ (DHImageFilter *)filterForFilterInfo:(DHImageFilterInfo *)filterInfo
{
    Class filterClass = filterInfo.filterClass;
    return [[filterClass alloc] init];
}

+ (NSArray *) availableFilters
{
    DHImageFilterInfo *gray = [DHImageFilterInfo filterInfoForFilterClass:[DHImageGrayFilter class] name:@"Gray" type:DHImageFilterTypeGray];
    DHImageFilterInfo *oldFashion = [DHImageFilterInfo filterInfoForFilterClass:[DHImageOldFasionFilter class] name:@"Old Fashion" type:DHImageFilterTypeOldFashion];
    DHImageFilterInfo *fresh = [DHImageFilterInfo filterInfoForFilterClass:[DHImageFreshFilter class] name:@"Fresh" type:DHImageFilterTypeFresh];
    DHImageFilterInfo *metalic = [DHImageFilterInfo filterInfoForFilterClass:[DHImageMetalicFilter class] name:@"Metalic" type:DHImageFilterTypeMetalic];
    DHImageFilterInfo *gringham = [DHImageFilterInfo filterInfoForFilterClass:[DHImageGringhamFilter class] name:@"Gringham" type:DHImageFilterTypeGringham];
    DHImageFilterInfo *sierra = [DHImageFilterInfo filterInfoForFilterClass:[DHImageSierraFilter class] name:@"Sierra" type:DHImageFilterTypeSierra];
    return @[gray, oldFashion, fresh, metalic, gringham, sierra];
}

+ (GPUImagePicture *) pictureWithImageNamed:(NSString *)imageName
{
    UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    
    return [[GPUImagePicture alloc] initWithImage:image];
    
}
@end
