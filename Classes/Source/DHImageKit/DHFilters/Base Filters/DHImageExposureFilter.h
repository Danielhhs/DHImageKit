//
//  DHImageExposureFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@interface DHImageExposureFilter : DHImageBaseFilter
{
    GLint exposureUniform, gammaUniform;
}

// Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat exposure;
@property (readwrite, nonatomic) CGFloat gamma;


@end
