//
//  DHImageOldFasionFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageOldFasionFilter.h"
#import "DHImageOverlayBlendFilter.h"
#import "DHImageFiltersHelper.h"
#import "DHImageColorMultiplyBlendFilter.h"

@interface DHImageOldFasionFilter () {
    GPUImagePicture *screenPicture;
}
@property (nonatomic, strong) DHImageOverlayBlendFilter *blendFilter;
@property (nonatomic, strong) GPUImagePicture *blendPicture;
@property (nonatomic, strong) DHImageFalseColorFilter *gradientFilter;
@property (nonatomic, strong) DHImageColorMultiplyBlendFilter *multiplyFilter;
@end

@implementation DHImageOldFasionFilter

- (instancetype) init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _blendFilter = [[DHImageOverlayBlendFilter alloc] init];
    _blendPicture = [DHImageFiltersHelper pictureWithImageNamed:@"old-picture-texture"];
    [_blendPicture addTarget:_blendFilter atTextureLocation:1];
    [self addFilter:_blendFilter];
    [_blendPicture processImage];
    
    _gradientFilter = [[DHImageFalseColorFilter alloc] init];
    _gradientFilter.firstColor = (GPUVector4){49.f / 255.f, 31.f / 255.f, 0.f, 1.f};
    _gradientFilter.secondColor = (GPUVector4){1.f, 1.f, 1.f, 1.f};
    [self addFilter:_gradientFilter];
    [_blendFilter addTarget:_gradientFilter];
    
    _multiplyFilter = [[DHImageColorMultiplyBlendFilter alloc] init];
    _multiplyFilter.blendColor = [UIColor colorWithRed:1.f green:213.f / 255.f blue:0.f alpha:1];
    _multiplyFilter.opacity = 0.50;
    [_gradientFilter addTarget:_multiplyFilter];
    [self addFilter:_multiplyFilter];
    
    self.initialFilters = @[_blendFilter];
    self.terminalFilter = _multiplyFilter;
    
    return self;
}

- (NSString *) name
{
    return @"Old Fashion";
}

@end
