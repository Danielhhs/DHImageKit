//
//  DHImageVignetteBlendFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/8.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageTwoInputFilter.h"

@interface DHImageVignetteBlendFilter : DHImageTwoInputFilter
{
    GLint vignetteCenterUniform, vignetteStartUniform, vignetteEndUniform;
}

// the center for the vignette in tex coords (defaults to 0.5, 0.5)
@property (nonatomic, readwrite) CGPoint vignetteCenter;

// The normalized distance from the center where the vignette effect starts. Default of 0.5.
@property (nonatomic, readwrite) CGFloat vignetteStart;

// The normalized distance from the center where the vignette effect ends. Default of 0.75.
@property (nonatomic, readwrite) CGFloat vignetteEnd;
@end
