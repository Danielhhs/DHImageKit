//
//  FiltersHelper.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/6/22.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHIFFiltersHelper.h"

@implementation DHIFFiltersHelper
+ (NSArray *) availableFilters
{
    return @[@"Normal", @"1977", @"Amaro", @"Brannan", @"EarlyBird", @"Hefe", @"Hudson", @"Inkwell", @"Lomofi", @"LordKelvin", @"Nashville", @"Rise", @"Sierra", @"Sutro", @"Toaster", @"Valencia", @"Walden", @"Xproll"];
}

+ (IFImageFilter *) filterForType:(DHFilter)filterType
{
    switch (filterType) {
        case DHFilter1977:
            return [[IF1977Filter alloc] init];
        case DHFilterAmaro:
            return [[IFAmaroFilter alloc] init];
        case DHFilterBrannan:
            return [[IFBrannanFilter alloc] init];
        case DHFilterEarlyBird:
            return [[IFEarlybirdFilter alloc] init];
        case DHFilterHefe:
            return [[IFHefeFilter alloc] init];
        case DHFilterHudson:
            return [[IFHudsonFilter alloc] init];
        case DHFilterInkwell:
            return [[IFInkwellFilter alloc] init];
        case DHFilterLomofi:
            return [[IFLomofiFilter alloc] init];
        case DHFilterLordKelvin:
            return [[IFLordKelvinFilter alloc] init];
        case DHFilterNashville:
            return [[IFNashvilleFilter alloc] init];
        case DHFilterNormal:
            return [[IFNormalFilter alloc] init];
        case DHFilterRise:
            return [[IFRiseFilter alloc] init];
        case DHFilterSierra:
            return [[IFSierraFilter alloc] init];
        case DHFilterSutro:
            return [[IFSutroFilter alloc] init];
        case DHFilterToaster:
            return [[IFToasterFilter alloc] init];
        case DHFilterValencia:
            return [[IFValenciaFilter alloc] init];
        case DHFilterWalden:
            return [[IFWaldenFilter alloc] init];
        case DHFilterXproll:
            return [[IFXproIIFilter alloc] init];
        default:
            break;
    }
    return nil;
}
@end
