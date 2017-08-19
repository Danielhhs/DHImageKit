//
//  DHColorFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageColorFilter.h"

@implementation DHImageColorFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.color = [UIColor whiteColor];
        self.strength = 1.f;
    }
    return self;
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    self.red = (red - 1) * self.strength + 1;
    self.blue = (blue - 1) * self.strength + 1;
    self.green = (green - 1) * self.strength + 1;
}

- (void) setStrength:(CGFloat)strength
{
    _strength = strength;
    CGFloat red, green, blue, alpha;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    self.red = (red - 1) * strength + 1;
    self.blue = (blue - 1) * strength + 1;
    self.green = (green - 1) * strength + 1;
}

@end
