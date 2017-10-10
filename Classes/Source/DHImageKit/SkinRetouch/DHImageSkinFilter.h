//
//  DHImageSkinFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFilterGroup.h"
#import "DHImageSkinSmootherRadius.h"
#import "DHImageSkinSmoothMaskFilter.h"
#import "DHImageSharpenFilter.h"
#import "DHImageStrengthMask.h"
#import "DHImageDissolveBlendFilter.h"

@interface DHImageSkinFilter : DHImageFilterGroup
- (instancetype) initWithSize:(CGSize)size;

@property (nonatomic, strong) DHImageSkinSmootherRadius *radius;
@property (nonatomic) CGFloat amount;
@property (nonatomic) CGFloat sharpnessFactor;
- (void) updateWithTouchLocation:(CGPoint)location
                      completion:(void (^)(void))completion;

- (void) finishUpdating;

//InternalFilters
@property (nonatomic, strong, readonly) DHImageSkinSmoothMaskFilter *maskFilter;
@property (nonatomic, strong, readonly) DHImageSharpenFilter *sharpenFilter;
@property (nonatomic, strong, readonly) DHImageStrengthMask *strengthMask;
@property (nonatomic, strong, readonly) DHImageDissolveBlendFilter *dissolveBlendFilter;
@end
