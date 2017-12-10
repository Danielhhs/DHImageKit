//
//  DHImageChangeLipColorFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/11/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>

@interface DHImageChangeLipColorFilter : DHImageTwoInputFilter {
    GLuint colorUniform;
}

@property (nonatomic) GPUVector4 color;
@end
