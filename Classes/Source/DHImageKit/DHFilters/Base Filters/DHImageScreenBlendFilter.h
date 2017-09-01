//
//  DHImageScreenBlendFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHImageTwoInputFilter.h"

@interface DHImageScreenBlendFilter : DHImageTwoInputFilter {
    GLint strengthUniform;
}

@end
