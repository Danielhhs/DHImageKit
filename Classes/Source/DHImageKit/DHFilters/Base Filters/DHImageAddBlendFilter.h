//
//  DHImageAddBlendFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>

@interface DHImageAddBlendFilter : DHImageTwoInputFilter {
    GLuint scaleUniform;
}
@property (nonatomic) CGFloat scale;    //between 1.0 and 2.0
@end
