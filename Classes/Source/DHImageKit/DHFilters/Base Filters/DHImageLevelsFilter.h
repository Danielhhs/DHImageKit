//
//  DHImageLevelsFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHImageBaseFilter.h"

@interface DHImageLevelsFilter : DHImageBaseFilter
{
    GLint minUniform;
    GLint midUniform;
    GLint maxUniform;
    GLint minOutputUniform;
    GLint maxOutputUniform;
    
    GPUVector3 minVector, midVector, maxVector, minOutputVector, maxOutputVector;
}

/** Set levels for the red channel */
- (void)setRedMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut;

- (void)setRedMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max;

/** Set levels for the green channel */
- (void)setGreenMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut;

- (void)setGreenMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max;

/** Set levels for the blue channel */
- (void)setBlueMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut;

- (void)setBlueMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max;

/** Set levels for all channels at once */
- (void)setMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max minOut:(CGFloat)minOut maxOut:(CGFloat)maxOut;
- (void)setMin:(CGFloat)min gamma:(CGFloat)mid max:(CGFloat)max;

@end
