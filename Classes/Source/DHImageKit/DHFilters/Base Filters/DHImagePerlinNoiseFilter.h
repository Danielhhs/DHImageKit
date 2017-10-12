//
//  DHImagePerlinNoiseFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>

@interface DHImagePerlinNoiseFilter : DHImageBaseFilter
{
    GLint scaleUniform, colorStartUniform, colorFinishUniform;
}

@property (readwrite, nonatomic) GPUVector4 colorStart;
@property (readwrite, nonatomic) GPUVector4 colorFinish;

@property (readwrite, nonatomic) float scale;

@end
