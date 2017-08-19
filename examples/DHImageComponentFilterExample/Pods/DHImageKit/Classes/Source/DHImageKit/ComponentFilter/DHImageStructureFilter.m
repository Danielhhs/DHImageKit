//
//  DHImageStructureFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageStructureFilter.h"

@implementation DHImageStructureFilter

- (void) setLevel:(CGFloat)level
{
    _level = level;
    
    [self setRedMin:level gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    [self setBlueMin:level gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
    [self setGreenMin:level gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
}

@end
