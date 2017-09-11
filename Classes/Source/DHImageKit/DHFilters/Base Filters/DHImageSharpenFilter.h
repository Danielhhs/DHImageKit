//
//  DHImageSharpenFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@interface DHImageSharpenFilter : DHImageBaseFilter{
    GLint sharpnessUniform;
    GLint imageWidthFactorUniform, imageHeightFactorUniform;
}

// Sharpness ranges from -4.0 to 4.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat sharpness;

@end
