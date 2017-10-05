//
//  DHImageAlphaMask.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageAlphaMask.h"
#import <CoreGraphics/CoreGraphics.h>
#import <GPUImage/GPUImage.h>
#import <GLKit/GLKit.h>

#define kBrushPixelStep 3

@interface DHImageAlphaMask() {
    unsigned char *data;
    NSInteger length;
    CGFloat screenScale;
    NSInteger width, height;
    dispatch_semaphore_t semaphore;
    dispatch_queue_t processingQueue;
}
@property (nonatomic) CGPoint lastTouchPosition;
@end

#define DHIMAGE_MASK_MIN_VALUE 0
#define DHIMAGE_MASK_MAX_VALUE 255

#define DHIMAGE_MASK_BYTES_PER_PIXEL 4

@implementation DHImageAlphaMask

- (instancetype) initWithWidth:(NSInteger)awidth height:(NSInteger)aheight
{
    self = [super init];
    if (self) {
        width = awidth;
        height = aheight;
        length = width * height * DHIMAGE_MASK_BYTES_PER_PIXEL;
        _touchRadius = 40;
        _stepValue = 0.02;
        semaphore = dispatch_semaphore_create(0);
        processingQueue = dispatch_queue_create("cn.daniel.ImageAlphaMaskQueue", NULL);
        dispatch_semaphore_signal(semaphore);
        data = calloc(length, sizeof(unsigned char));
        screenScale = [UIScreen mainScreen].scale;
        for (NSInteger i = 0; i < length; i++) {
            data[i] = DHIMAGE_MASK_MIN_VALUE;
        }
        _lastTouchPosition = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        
        runSynchronouslyOnVideoProcessingQueue(^{
            [GPUImageContext useImageProcessingContext];
            
            outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:CGSizeMake(width, height) onlyTexture:YES];
            [outputFramebuffer disableReferenceCounting];
            
            glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
            if (self.shouldSmoothlyScaleOutput)
            {
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            }
            // no need to use self.outputTextureOptions here since pictures need this texture formats and type
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
            
            if (self.shouldSmoothlyScaleOutput)
            {
                glGenerateMipmap(GL_TEXTURE_2D);
            }
            glBindTexture(GL_TEXTURE_2D, 0);
        });
    }
    return self;
}

- (void) updateWithTouchPosition:(CGPoint)position
                      completion:(void(^)(void))completion
{
    [self _updateWithLocationInView:position];
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext useImageProcessingContext];
        
        outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:CGSizeMake(width, height) onlyTexture:YES];
        [outputFramebuffer disableReferenceCounting];
        
        glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
        if (self.shouldSmoothlyScaleOutput)
        {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        }
        // no need to use self.outputTextureOptions here since pictures need this texture formats and type
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
        
        if (self.shouldSmoothlyScaleOutput)
        {
            glGenerateMipmap(GL_TEXTURE_2D);
        }
        glBindTexture(GL_TEXTURE_2D, 0);
        [self processWithCompletion:^{
            if (completion) {
                completion();
            }
            self.lastTouchPosition = position;
        }];
    });
}

- (void) finishUpdating
{
    _lastTouchPosition = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
}

- (BOOL) processWithCompletion:(void(^)(void))completion
{
    if (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) != 0) {
        return NO;
    }
    runAsynchronouslyOnVideoProcessingQueue(^{
        for (id<GPUImageInput> currentTarget in self.targets) {
            NSInteger index = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:index] integerValue];
            
            [currentTarget setCurrentlyReceivingMonochromeInput:NO];
            [currentTarget setInputSize:CGSizeMake(width, height) atIndex:textureIndexOfTarget];
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
            [currentTarget newFrameReadyAtTime:kCMTimeIndefinite atIndex:textureIndexOfTarget];
            
        }
        
        dispatch_semaphore_signal(semaphore);
        if (completion) {
            completion();
        }
    });
    return YES;
}

- (BOOL) _hasPreviousTouch
{
    if (_lastTouchPosition.x == CGFLOAT_MAX && _lastTouchPosition.y == CGFLOAT_MAX) {
        return NO;
    } else {
        return YES;
    }
}

- (void) _updateWithLocationInView:(CGPoint)location
{
    if ([self _hasPreviousTouch]) {
        [self _updateWithNonFirstTouchWithLocation:location];
    } else {
        [self _updateWithFirstTouchWithLocation:location];
    }
}

- (void) _updateWithFirstTouchWithLocation:(CGPoint)location
{
    dispatch_async(processingQueue, ^{
        NSInteger leftMost = MAX(0, location.x - self.touchRadius) * screenScale;
        NSInteger rightMost = MIN(location.x + self.touchRadius, width) * screenScale;
        NSInteger topMost = MAX(0,location.y - self.touchRadius) * screenScale;
        NSInteger bottomMost = MIN(location.y + self.touchRadius, height) * screenScale;
        for (NSInteger x = leftMost; x <= rightMost; x++) {
            for (NSInteger y = topMost; y < bottomMost; y++) {
                NSInteger lx = x - location.x * screenScale;
                NSInteger ly = y - location.y * screenScale;
                CGFloat length = sqrt(lx * lx + ly * ly) / ((CGFloat)self.touchRadius * screenScale);
                CGFloat v = 1.f - [self smoothStepFromMin:0 toMax:1 x:length];
                [self updateDataForPointAtX:x y:y value:v];
            }
        }
    });
}

- (void) _updateWithNonFirstTouchWithLocation:(CGPoint)location
{
    dispatch_async(processingQueue, ^{
        CGFloat xDif = (location.x - _lastTouchPosition.x);
        CGFloat yDif = (location.y - _lastTouchPosition.y);
        NSInteger count = MAX(ceilf(sqrtf(xDif * xDif + yDif * yDif) / kBrushPixelStep), 1);
        for (int i = 0; i < count; i++) {
            CGFloat percent = ((CGFloat)i) / count;
            NSInteger x = _lastTouchPosition.x + xDif * percent;
            NSInteger y = _lastTouchPosition.y + yDif *percent;
            [self _updateWithFirstTouchWithLocation:CGPointMake(x, y)];
        }
    });
}

- (CGFloat) smoothStepFromMin:(CGFloat)min
                        toMax:(CGFloat)max
                            x:(CGFloat)x
{
    CGFloat t = (x - min) / (max - min);
    t = [self clampValue:t forMin:min max:max];
    return t * t * (3.0 - 2.0 * t);
}

- (CGFloat) clampValue:(CGFloat)value
                forMin:(CGFloat)min
                   max:(CGFloat)max
{
    if (value < min) {
        return min;
    } else if (value > max) {
        return max;
    } else {
        return value;
    }
}

- (void) updateDataForPointAtX:(NSInteger)x
                             y:(NSInteger)y
                         value:(CGFloat)value
{
    NSInteger index = (y * width + x) * DHIMAGE_MASK_BYTES_PER_PIXEL;
    NSInteger componentValue = value * DHIMAGE_MASK_MAX_VALUE * self.stepValue;
    data[index] = MIN(componentValue + data[index], DHIMAGE_MASK_MAX_VALUE);
    data[index + 1] =  MIN(componentValue + data[index + 1], DHIMAGE_MASK_MAX_VALUE);
    data[index + 2] =  MIN(componentValue + data[index + 2], DHIMAGE_MASK_MAX_VALUE);
    data[index + 3] =  MIN(componentValue + data[index + 3], DHIMAGE_MASK_MAX_VALUE);
}

- (CGRect) _containerRectForLocation:(CGPoint)location
{
    NSInteger leftMost, rightMost, topMost, bottomMost;
    if (location.x > _lastTouchPosition.x) {
        leftMost = _lastTouchPosition.x - self.touchRadius;
        rightMost = location.x + self.touchRadius;
    } else {
        leftMost =  location.x - self.touchRadius;
        rightMost = _lastTouchPosition.x + self.touchRadius;
    }
    if (location.y > _lastTouchPosition.y) {
        topMost = _lastTouchPosition.y - self.touchRadius;
        bottomMost = location.y + self.touchRadius;
    } else {
        topMost = location.y - self.touchRadius;
        bottomMost = _lastTouchPosition.y + self.touchRadius;
    }
    leftMost = MAX(0, leftMost * screenScale);
    rightMost = MIN(rightMost * screenScale, width);
    topMost = MAX(0, topMost * screenScale);
    bottomMost = MIN(bottomMost * screenScale, height);
    CGRect rect = CGRectMake(leftMost, topMost, rightMost, bottomMost);
    return rect;
}

@end
