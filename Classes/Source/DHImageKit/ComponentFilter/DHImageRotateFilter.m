//
//  DHRotateFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageRotateFilter.h"
#import "DHImageHelper.h"

@implementation DHImageRotateFilter

- (void) setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    CGFloat xTranslation = [DHImageHelper CGAffineTransformGetTranslateX:self.affineTransform];
    CGFloat yTranslation = [DHImageHelper CGAffineTransformGetTranslateY:self.affineTransform];
    CGFloat radians = [DHImageHelper DegreesToRadians:rotation];
    CGFloat scale = 1 + MIN(fabs(sin(radians)), fabs(cos(radians)));
    CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity,xTranslation, yTranslation);
    transform = CGAffineTransformScale(transform, scale, scale);
    transform = CGAffineTransformRotate(transform, radians);
    self.affineTransform = transform;
}

@end
