//
//  DHImageFilterGroup.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFilterGroup.h"

@implementation DHImageFilterGroup


- (void) updateWithStrength:(double)strength
{
    self.strength = strength;
    for (int i = 0; i < self.filterCount; i++) {
        id<DHImageUpdatable> updatable = (id<DHImageUpdatable>)[self filterAtIndex:i];
        [updatable updateWithStrength:strength];
    }
}

@end
