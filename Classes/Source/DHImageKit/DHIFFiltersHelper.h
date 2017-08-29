//
//  FiltersHelper.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/6/22.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstaFilters.h"

typedef NS_ENUM(NSInteger, DHFilter) {
    DHFilterNormal,
    DHFilter1977,
    DHFilterAmaro,
    DHFilterBrannan,
    DHFilterEarlyBird,
    DHFilterHefe,
    DHFilterHudson,
    DHFilterInkwell,
    DHFilterLomofi,
    DHFilterLordKelvin,
    DHFilterNashville,
    DHFilterRise,
    DHFilterSierra,
    DHFilterSutro,
    DHFilterToaster,
    DHFilterValencia,
    DHFilterWalden,
    DHFilterXproll,
};

@interface DHIFFiltersHelper : NSObject

+ (NSArray *) availableFilters;
+ (IFImageFilter *) filterForType:(DHFilter)type;
+ (GPUImagePicture *) pictureWithImageNamed:(NSString *)imageName;
@end
