//
//  DHImagePosterizeFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@interface DHImagePosterizeFilter : DHImageBaseFilter {
    GLint colorLevelsUniform;
}

@property (nonatomic) float colorLevels;

@end
