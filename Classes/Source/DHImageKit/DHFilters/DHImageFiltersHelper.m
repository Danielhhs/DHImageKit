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
#import "DHImageKelvinFilter.h"
#import "DHImageHefeFilter.h"
#import "DHImageEarlybirdFilter.h"
#import "DHImageSutroFilter.h"
#import "DHImageToasterFilter.h"
#import "DHImageWillowFilter.h"
#import "DHImageLofiFilter.h"
#import "DHImageNormalFilter.h"
#import "DHImageIcyFilter.h"
#import "DHImageFoodFilter.h"

@implementation DHImageFiltersHelper

+ (DHImageFilter *)filterForFilterInfo:(DHImageFilterInfo *)filterInfo
{
    Class filterClass = filterInfo.filterClass;
    return [[filterClass alloc] init];
}

+ (NSArray *) availableFilters
{
    DHImageFilterInfo *gray = [DHImageFilterInfo filterInfoForFilterClass:[DHImageGrayFilter class] name:@"G1" type:DHImageFilterTypeGray];
    DHImageFilterInfo *oldFashion = [DHImageFilterInfo filterInfoForFilterClass:[DHImageOldFasionFilter class] name:@"V4" type:DHImageFilterTypeOldFashion];
    DHImageFilterInfo *fresh = [DHImageFilterInfo filterInfoForFilterClass:[DHImageFreshFilter class] name:@"F1" type:DHImageFilterTypeFresh];
    DHImageFilterInfo *metalic = [DHImageFilterInfo filterInfoForFilterClass:[DHImageMetalicFilter class] name:@"M5" type:DHImageFilterTypeMetalic];
    DHImageFilterInfo *gringham = [DHImageFilterInfo filterInfoForFilterClass:[DHImageGringhamFilter class] name:@"G2" type:DHImageFilterTypeGringham];
    DHImageFilterInfo *sierra = [DHImageFilterInfo filterInfoForFilterClass:[DHImageSierraFilter class] name:@"S1" type:DHImageFilterTypeSierra];
    DHImageFilterInfo *crema = [DHImageFilterInfo filterInfoForFilterClass:[DHImageCremaFilter class] name:@"C2" type:DHImageFilterTypeCrema];
    DHImageFilterInfo *rise = [DHImageFilterInfo filterInfoForFilterClass:[DHImageRiseFilter class] name:@"R3" type:DHImageFilterTypeRise];
    DHImageFilterInfo *lark = [DHImageFilterInfo filterInfoForFilterClass:[DHImageLarkFilter class] name:@"L1" type:DHImageFilterTypeLark];
    DHImageFilterInfo *nashville = [DHImageFilterInfo filterInfoForFilterClass:[DHImageNashvilleFilter class] name:@"N1" type:DHImageFilterTypeNashville];
    DHImageFilterInfo *clarendon = [DHImageFilterInfo filterInfoForFilterClass:[DHImageClarendonFilter class] name:@"C3" type:DHImageFilterTypeClarendon];
    DHImageFilterInfo *juno = [DHImageFilterInfo filterInfoForFilterClass:[DHImageJunoFilter class] name:@"J1" type:DHImageFilterTypeJuno];
    DHImageFilterInfo *amaro = [DHImageFilterInfo filterInfoForFilterClass:[DHImageAmaroFilter class] name:@"A3" type:DHImageFilterTypeAmaro];
    DHImageFilterInfo *hudson = [DHImageFilterInfo filterInfoForFilterClass:[DHImageHudsonFilter class] name:@"H1" type:DHImageFilterTypeAmaro];
    DHImageFilterInfo *valencia = [DHImageFilterInfo filterInfoForFilterClass:[DHImageValenciaFilter class] name:@"V8" type:DHImageFilterTypeAmaro];
    DHImageFilterInfo *xproll = [DHImageFilterInfo filterInfoForFilterClass:[DHImageXprollFilter class] name:@"X1" type:DHImageFilterTypeXProII];
    DHImageFilterInfo *walden = [DHImageFilterInfo filterInfoForFilterClass:[DHImageWaldenFilter class] name:@"LF1" type:DHImageFilterTypeWalden];
    DHImageFilterInfo *inkwell = [DHImageFilterInfo filterInfoForFilterClass:[DHImageInkWellFilter class] name:@"LF2" type:DHImageFilterTypeInkwell];
    DHImageFilterInfo *kelvin = [DHImageFilterInfo filterInfoForFilterClass:[DHImageKelvinFilter class] name:@"LF3" type:DHImageFilterTypeKelvin];
    DHImageFilterInfo *hefe = [DHImageFilterInfo filterInfoForFilterClass:[DHImageHefeFilter class] name:@"LF4" type:DHImageFilterTypeHefe];
    DHImageFilterInfo *earlyBird = [DHImageFilterInfo filterInfoForFilterClass:[DHImageEarlybirdFilter class] name:@"LF5" type:DHImageFilterTypeEarlyBird];
    DHImageFilterInfo *sutro = [DHImageFilterInfo filterInfoForFilterClass:[DHImageSutroFilter class] name:@"LF6" type:DHImageFilterTypeSutro];
    DHImageFilterInfo *toaster = [DHImageFilterInfo filterInfoForFilterClass:[DHImageToasterFilter class] name:@"LF7" type:DHImageFilterTypeToaster];
    DHImageFilterInfo *willow = [DHImageFilterInfo filterInfoForFilterClass:[DHImageWillowFilter class] name:@"LF8" type:DHImageFilterTypeWillow];
    DHImageFilterInfo *lomo = [DHImageFilterInfo filterInfoForFilterClass:[DHImageLofiFilter class] name:@"LF9" type:DHImageFilterTypeLomo];
    DHImageFilterInfo *normal = [DHImageFilterInfo filterInfoForFilterClass:[DHImageNormalFilter class] name:@"原始" type:DHImageFilterTypeNormal];
    DHImageFilterInfo *icy = [DHImageFilterInfo filterInfoForFilterClass:[DHImageIcyFilter class] name:@"I1" type:DHImageFilterTypeIcy];
    DHImageFilterInfo *food = [DHImageFilterInfo filterInfoForFilterClass:[DHImageFoodFilter class] name:@"F4" type:DHImageFilterTypeFood];
    return @[normal, gray, fresh, icy, food, metalic, gringham, sierra, crema, rise, oldFashion, lark, nashville, clarendon, juno, amaro, hudson, valencia, xproll, walden, inkwell, kelvin, hefe, earlyBird, sutro, toaster, willow, lomo];
}

+ (GPUImagePicture *) pictureWithImageNamed:(NSString *)imageName
{
    UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    
    return [[GPUImagePicture alloc] initWithImage:image];
    
}
@end
