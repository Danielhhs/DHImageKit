//
//  DHImageContrastBrightnessFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHImageBaseFilter.h"
@interface DHImageContrastBrightnessFilter : DHImageBaseFilter {
    GLint brightnessUniform, contrastUniform;
}

@property (nonatomic) CGFloat brightness;
@property (nonatomic) CGFloat contrast;

@end
