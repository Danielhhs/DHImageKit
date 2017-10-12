//
//  DHImageSkinHealFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>

@interface DHImageSkinHealFilter : DHImageBaseFilter

- (instancetype) initWithSize:(CGSize)size;

@property (nonatomic) CGFloat radius;

- (void) updateWithTouchLocation:(CGPoint)location
                      completion:(void (^)(void))completion;

- (void) finishUpdating;

@end
