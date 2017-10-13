//
//  DHImageSkinFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinFilter.h"

@interface DHImageSkinFilter()
@property (nonatomic, strong, readwrite) DHImageStrengthMask *strengthMask;
@property (nonatomic) CGFloat scale;
@end

@implementation DHImageSkinFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _scale = [UIScreen mainScreen].scale;
        _strengthMask = [[DHImageStrengthMask alloc] initWithWidth:size.width height:size.height];
    }
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    self.currentInputSize = newSize;
}

- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
{
    CGPoint locInRealSize = CGPointMake(location.x * self.currentInputSize.width / self.scale, location.y * self.currentInputSize.height / self.scale);
    [_strengthMask updateWithTouchLocation:locInRealSize completion:completion];
}

- (void) finishUpdating
{
    [_strengthMask finishUpdating];
}

- (void) updateWithStrength:(CGFloat)strength
{
    [super updateWithStrength:strength];
    [self.strengthMask informTargetsForFrameReadyWithCompletion:^{
        
    }];
}
@end
