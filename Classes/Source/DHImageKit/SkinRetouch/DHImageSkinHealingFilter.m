//
//  DHImageSkinHealingFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/12.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinHealingFilter.h"
#import "DHImageScarHealFilter.h"
#import "DHImageGaussianBlurFilter.h"
#import "DHImageScarHealCompositeFilter.h"

@interface DHImageSkinHealingFilter()
@property (nonatomic, strong) DHImageScarHealFilter *scarHealFilter;
@property (nonatomic, strong) DHImageGaussianBlurFilter *lowFrequencyFilter;
@property (nonatomic, strong) DHImageScarHealCompositeFilter *compositeFilter;
@property (nonatomic) CGPoint updateCenter;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint firstTouchLocation;
@property (nonatomic) BOOL isFirstTouch;
@end

@implementation DHImageSkinHealingFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _size = size;
        self.isFirstTouch = YES;
        
        _lowFrequencyFilter = [[DHImageGaussianBlurFilter alloc] init];
        _lowFrequencyFilter.blurRadiusInPixels = 0;
        [self addFilter:_lowFrequencyFilter];
        
        _scarHealFilter = [[DHImageScarHealFilter alloc] initWithSize:size];
        [self addFilter:_scarHealFilter];
        [_lowFrequencyFilter addTarget:_scarHealFilter];
        
        _compositeFilter = [[DHImageScarHealCompositeFilter alloc] init];
        [self addFilter:_compositeFilter];
        [_scarHealFilter addTarget:_compositeFilter atTextureLocation:1];
        
        self.initialFilters = @[_lowFrequencyFilter, _compositeFilter];
        self.terminalFilter = _compositeFilter;
        self.radius = size.width / 15;
    }
    return self;
}

- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
{
    location.x *= self.size.width;
    location.y *= self.size.height;
    if (self.isFirstTouch) {
        self.firstTouchLocation = location;
        self.isFirstTouch = NO;
    }
    [self.scarHealFilter updateWithTouchLocation:location completion:^{
        [self.compositeFilter updateWithLocation:self.firstTouchLocation];
        if (completion) {
            completion();
        }
    }];
}

- (void) finishUpdating
{
    self.isFirstTouch = YES;
    [self.scarHealFilter finishUpdating];
}

- (void) setRadius:(CGFloat)radius
{
    _radius = radius;
    self.compositeFilter.radius = radius;
    self.scarHealFilter.radius = radius;
}

@end
