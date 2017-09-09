//
//  DHImageFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/30.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHImageFilterGroup.h"

@interface DHImageFilter : DHImageFilterGroup

- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString sources:(NSArray<GPUImagePicture*>*)sources;
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;

- (NSString*)name;
@end
