//
//  DHImageColorMultiplyBlendFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>
#import "DHImageBaseFilter.h"

@interface DHImageColorMultiplyBlendFilter : DHImageBaseFilter {
    GLuint blendColorUniform, opacityUniform;
}

@property (nonatomic, strong) UIColor *blendColor;
@property (nonatomic) CGFloat opacity;

@end
