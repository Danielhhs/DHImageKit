//
//  DHImageRGBFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@interface DHImageRGBFilter : DHImageBaseFilter
{
    GLint redUniform;
    GLint greenUniform;
    GLint blueUniform;
}

// Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
@property (readwrite, nonatomic) CGFloat red;
@property (readwrite, nonatomic) CGFloat green;
@property (readwrite, nonatomic) CGFloat blue;


@end
