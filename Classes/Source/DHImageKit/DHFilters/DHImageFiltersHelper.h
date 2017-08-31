//
//  DHImageFiltersHelper.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>
#import "DHImageFilter.h"
#import "DHImageFilterInfo.h"

@interface DHImageFiltersHelper : NSObject

+ (NSArray <DHImageFilterInfo*> *) availableFilters;

+ (DHImageFilter *) filterForType:(DHImageFilterType)type;

+ (GPUImagePicture *) pictureWithImageNamed:(NSString *)imageName;
@end
