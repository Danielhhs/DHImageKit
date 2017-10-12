//
//  DHImageSkinHealingFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/12.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinHealingFilter.h"
#import "DHImageScarHealFilter.h"

@interface DHImageSkinHealingFilter() {
    BOOL isFirstTouch;
}
@property (nonatomic, strong) DHImageScarHealFilter *scarHealFilter;
@end

@implementation DHImageSkinHealingFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        isFirstTouch = YES;
        _scarHealFilter = [[DHImageScarHealFilter alloc] initWithSize:size];
        [self addFilter:_scarHealFilter];
        
        self.initialFilters = @[_scarHealFilter];
        self.terminalFilter = _scarHealFilter;
    }
    return self;
}

- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
{
    if (isFirstTouch) {
        isFirstTouch = NO;
        [self.scarHealFilter updateWithTouchLocation:location completion:completion];
    }
}

- (void) finishUpdating
{
    isFirstTouch = YES;
}

@end
