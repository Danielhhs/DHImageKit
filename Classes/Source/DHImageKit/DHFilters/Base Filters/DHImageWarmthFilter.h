//
//  DHImageWarmthFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/8.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@interface DHImageWarmthFilter : DHImageBaseFilter
{
    GLint temperatureUniform, tintUniform;
}
//choose color temperature, in degrees Kelvin
@property(readwrite, nonatomic) CGFloat temperature;

//adjust tint to compensate
@property(readwrite, nonatomic) CGFloat tint;


@end
