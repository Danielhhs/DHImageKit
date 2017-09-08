//
//  DHImageIcyFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/8.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageIcyFilter.h"
#import "DHImageWarmthFilter.h"
#import "DHImageFiltersHelper.h"
#import "DHImageScreenBlendFilter.h"
#import "DHImageVignetteBlendFilter.h"

@interface DHImageIcyFilter ()
@property (nonatomic, strong) DHImageWarmthFilter *warmthFilter;
@property (nonatomic, strong) DHImageVignetteBlendFilter *vignetteFilter;
@property (nonatomic, strong) DHImageScreenBlendFilter *screenBlendFilter;
@property (nonatomic, strong) GPUImagePicture *icePicture;
@property (nonatomic, strong) GPUImagePicture *snowPicture;
@end

@implementation DHImageIcyFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _warmthFilter = [[DHImageWarmthFilter alloc] init];
        _warmthFilter.temperature = 3900;
        [self addFilter:_warmthFilter];
        
        _vignetteFilter = [[DHImageVignetteBlendFilter alloc] init];
        _icePicture = [DHImageFiltersHelper pictureWithImageNamed:@"ice-texture"];
        [_icePicture addTarget:_vignetteFilter atTextureLocation:1];
        [_icePicture processImage];
        [self addFilter:_vignetteFilter];
        [_warmthFilter addTarget:_vignetteFilter];
        
        _screenBlendFilter = [[DHImageScreenBlendFilter alloc] init];
        _screenBlendFilter.opacity = 0.5;
        _snowPicture = [DHImageFiltersHelper pictureWithImageNamed:@"snow-texture"];
        [_snowPicture addTarget:_screenBlendFilter atTextureLocation:1];
        [_snowPicture processImage];
        [self addFilter:_screenBlendFilter];
        [_vignetteFilter addTarget:_screenBlendFilter];
        
        self.initialFilters = @[_warmthFilter];
        self.terminalFilter = _screenBlendFilter;
    }
    return self;
}

@end
