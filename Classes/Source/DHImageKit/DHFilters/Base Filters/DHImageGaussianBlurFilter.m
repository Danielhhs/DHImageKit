//
//  DHImageGaussianBlurFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageGaussianBlurFilter.h"

@implementation DHImageGaussianBlurFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        strengthUniform = [filterProgram uniformIndex:@"strength"];
        [self updateWithStrength:1.f];
    }
    return self;
}

- (void) updateWithStrength:(double)strength
{
    [self setFloat:strength forUniform:strengthUniform program:filterProgram];
}

@end
