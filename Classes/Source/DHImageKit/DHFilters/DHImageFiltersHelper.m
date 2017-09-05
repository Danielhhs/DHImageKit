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
#import "DHImageCremaFilter.h"
#import "DHImageRiseFilter.h"
#import "DHImageLarkFilter.h"
#import "DHImageNashvilleFilter.h"
#import "DHImageClarendonFilter.h"
#import "DHImageJunoFilter.h"
#import "DHImageAmaroFilter.h"
#import "DHImageHudsonFilter.h"
#import "DHImageValenciaFilter.h"
#import "DHImageXprollFilter.h"
#import "DHImageWaldenFilter.h"
#import "DHImageInkWellFilter.h"

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
    DHImageFilterInfo *crema = [DHImageFilterInfo filterInfoForFilterClass:[DHImageCremaFilter class] name:@"Crema" type:DHImageFilterTypeCrema];
    DHImageFilterInfo *rise = [DHImageFilterInfo filterInfoForFilterClass:[DHImageRiseFilter class] name:@"Rise" type:DHImageFilterTypeRise];
    DHImageFilterInfo *lark = [DHImageFilterInfo filterInfoForFilterClass:[DHImageLarkFilter class] name:@"Lark" type:DHImageFilterTypeLark];
    DHImageFilterInfo *nashville = [DHImageFilterInfo filterInfoForFilterClass:[DHImageNashvilleFilter class] name:@"Nashville" type:DHImageFilterTypeNashville];
    DHImageFilterInfo *clarendon = [DHImageFilterInfo filterInfoForFilterClass:[DHImageClarendonFilter class] name:@"Clarendon" type:DHImageFilterTypeClarendon];
    DHImageFilterInfo *juno = [DHImageFilterInfo filterInfoForFilterClass:[DHImageJunoFilter class] name:@"Juno" type:DHImageFilterTypeJuno];
    DHImageFilterInfo *amaro = [DHImageFilterInfo filterInfoForFilterClass:[DHImageAmaroFilter class] name:@"Amaro" type:DHImageFilterTypeAmaro];
    DHImageFilterInfo *hudson = [DHImageFilterInfo filterInfoForFilterClass:[DHImageHudsonFilter class] name:@"Hundson" type:DHImageFilterTypeAmaro];
    DHImageFilterInfo *valencia = [DHImageFilterInfo filterInfoForFilterClass:[DHImageValenciaFilter class] name:@"Valencia" type:DHImageFilterTypeAmaro];
    DHImageFilterInfo *xproll = [DHImageFilterInfo filterInfoForFilterClass:[DHImageXprollFilter class] name:@"X Pro II" type:DHImageFilterTypeXProII];
    DHImageFilterInfo *walden = [DHImageFilterInfo filterInfoForFilterClass:[DHImageWaldenFilter class] name:@"Walden" type:DHImageFilterTypeWalden];
    DHImageFilterInfo *inkwell = [DHImageFilterInfo filterInfoForFilterClass:[DHImageInkWellFilter class] name:@"Inkwell" type:DHImageFilterTypeInkwell];
    return @[gray, oldFashion, fresh, metalic, gringham, sierra, crema, rise, lark, nashville, clarendon, juno, amaro, hudson, valencia, xproll, walden, inkwell];
}

+ (GPUImagePicture *) pictureWithImageNamed:(NSString *)imageName
{
    UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    
    return [[GPUImagePicture alloc] initWithImage:image];
    
}
@end
