//
//  DHColorFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface DHImageColorFilter : GPUImageRGBFilter

@property (nonatomic, strong) UIColor *color;

@property (nonatomic) CGFloat strength;

@end
