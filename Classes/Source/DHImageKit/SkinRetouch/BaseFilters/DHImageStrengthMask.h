//
//  DHImageStrengthMask.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/7.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface DHImageStrengthMask : GPUImageOutput
- (instancetype) initWithWidth:(CGFloat)awidth height:(CGFloat)aheight;
- (void) updateWithTouchLocation:(CGPoint)location
                      completion:(void (^)(void))completion;

- (void) finishUpdating;

- (void) informTargetsForFrameReadyWithCompletion:(void (^)(void))completion;
@end
