//
//  DHImageSkinSmoothRadius.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GLKit/GLKit.h>


typedef NS_ENUM(NSInteger, DHImageSkinSmootherUnit) {
    DHImageSkinSmootherUnitPixel = 0,
    DHImageSkinSmootherUnitFractionOfImage = 1,
};

@interface DHImageSkinSmootherRadius : NSObject <NSCopying, NSSecureCoding>
@property (nonatomic) CGFloat value;
@property (nonatomic) DHImageSkinSmootherUnit unit;


- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)radiusInPixels:(CGFloat)pixels;
+ (instancetype)radiusAsFractionOfImageWidth:(CGFloat)fraction;
@end
