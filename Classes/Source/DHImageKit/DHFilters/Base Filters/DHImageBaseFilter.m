//
//  DHImageBaseFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@implementation DHImageBaseFilter

- (instancetype) initWithFragmentShaderFromString:(NSString *)fragmentShaderString
{
    self = [super initWithFragmentShaderFromString:fragmentShaderString];
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
