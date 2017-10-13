
//
//  DHImageSkinNoiseFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/13.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinNoiseFilter.h"
#import "DHImageOverlayBlendFilter.h"

@interface DHImageSkinNoiseFilter()
@property (nonatomic, strong) GPUImagePicture *noiseSource;
@property (nonatomic, strong) DHImageOverlayBlendFilter *overlayBlendFilter;
@end

@implementation DHImageSkinNoiseFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _overlayBlendFilter = [[DHImageOverlayBlendFilter alloc] init];
        [_overlayBlendFilter disableSecondFrameCheck];
        [self addFilter:_overlayBlendFilter];
        
        _noiseSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"noise_texture.png"]];
        [_noiseSource addTarget:_overlayBlendFilter atTextureLocation:1];
        
        self.initialFilters = @[_overlayBlendFilter];
        self.terminalFilter = _overlayBlendFilter;
    }
    return self;
}

@end
