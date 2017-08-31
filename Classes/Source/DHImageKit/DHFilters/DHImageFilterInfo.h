//
//  DHFilterInfo.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, DHImageFilterType) {
    DHImageFilterTypeGray,
};

@interface DHImageFilterInfo : NSObject
@property (nonatomic) DHImageFilterType filterType;
@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) Class filterClass;

+ (DHImageFilterInfo *) filterInfoForFilterClass:(Class)filterClass
                                            name:(NSString *)name
                                            type:(DHImageFilterType)filterType;
@end
