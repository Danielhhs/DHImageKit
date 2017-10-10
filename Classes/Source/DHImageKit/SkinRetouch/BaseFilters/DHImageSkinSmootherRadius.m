//
//  DHImageSkinSmoothRadius.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinSmootherRadius.h"

@implementation DHImageSkinSmootherRadius
+ (instancetype) radiusInPixels:(CGFloat)pixels
{
    DHImageSkinSmootherRadius *radius = [DHImageSkinSmootherRadius new];
    radius.value = pixels;
    radius.unit = DHImageSkinSmootherUnitPixel;
    return radius;
}

+ (instancetype) radiusAsFractionOfImageWidth:(CGFloat)fraction
{
    DHImageSkinSmootherRadius *radius = [DHImageSkinSmootherRadius new];
    radius.unit = DHImageSkinSmootherUnitFractionOfImage;
    radius.value = fraction;
    return radius;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.value = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(value))] floatValue];
        self.unit = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(unit))] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.value) forKey:NSStringFromSelector(@selector(value))];
    [aCoder encodeObject:@(self.unit) forKey:NSStringFromSelector(@selector(unit))];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
