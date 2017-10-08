//
//  DHImageSkinSmoothFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHImageFilterGroup.h"

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

@interface DHImageSkinSmoothFilter : DHImageFilterGroup
@property (nonatomic) CGFloat amount;
@property (nonatomic, strong) NSArray *controlPoints;
@property (nonatomic, strong) DHImageSkinSmootherRadius *radius;
@property (nonatomic) CGFloat sharpnessFactor;

- (void) updateWithTouchLocation:(CGPoint)location
                      completion:(void (^)(void))completion;

- (void) finishUpdating;
@end
