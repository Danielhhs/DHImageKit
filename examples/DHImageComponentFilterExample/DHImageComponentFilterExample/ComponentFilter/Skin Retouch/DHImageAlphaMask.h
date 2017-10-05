//
//  DHImageAlphaMask.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

@interface DHImageAlphaMask : GPUImageOutput

@property (nonatomic) NSInteger touchRadius;  //Default is 20 pixel
@property (nonatomic) CGFloat stepValue;      //Default is 0.2

- (instancetype) initWithWidth:(NSInteger)width height:(NSInteger)height;   //Width and height are measured by pixel
- (void) startTouchingWithPosition:(CGPoint)position;

- (void) updateWithTouchPosition:(CGPoint)position
                      completion:(void(^)(void))completion;

- (void) finishUpdating;

- (BOOL) processWithCompletion:(void(^)(void))completion;
@end
