//
//  DHColorDarkenBlendFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>
#import "DHImageUpdatable.h"

@interface DHColorDarkenBlendFilter : GPUImageFilter<DHImageUpdatable> {
    GLuint blendColorUniform;
}

@property (nonatomic, strong) UIColor *blendColor;

@end
