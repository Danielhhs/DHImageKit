//
//  DHImageOperation.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHImageConstants.h"

@interface DHImageOperation : NSObject <NSCopying>

@property (nonatomic) DHImageEditComponent component;
@property (nonatomic) DHImageEidtComponentSubType subType;
@property (nonatomic) NSDictionary *fromValues;
@property (nonatomic) NSDictionary *toValues;

@end
