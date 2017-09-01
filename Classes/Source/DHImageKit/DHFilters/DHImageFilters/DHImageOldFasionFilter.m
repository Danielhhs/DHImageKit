//
//  DHImageOldFasionFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageOldFasionFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageColorDarkenBlendFilter.h"
#import "DHImageScreenBlendFilter.h"
#import "DHImageFiltersHelper.h"

@interface DHImageOldFasionFilter () {
    GPUImagePicture *screenPicture;
}
@property (nonatomic, strong) DHImageToneCurveFilter *curveFilter;
@property (nonatomic, strong) DHImageColorDarkenBlendFilter *darkenFilter;
@property (nonatomic, strong) DHImageScreenBlendFilter *screenBlendFilter;

@end

@implementation DHImageOldFasionFilter

- (instancetype) init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"old-fashion"];
    [self addFilter:_curveFilter];
    
    _darkenFilter = [[DHImageColorDarkenBlendFilter alloc] init];
    _darkenFilter.blendColor = [UIColor colorWithRed:227.f / 255.f green:228.f / 255.f blue:143.f / 255.f alpha:1.f];
    [self addFilter:_darkenFilter];
    [_curveFilter addTarget:_darkenFilter];
    
    _screenBlendFilter = [[DHImageScreenBlendFilter alloc] init];
    [self addFilter:_screenBlendFilter];
    [_darkenFilter addTarget:_screenBlendFilter atTextureLocation:0];
    
    screenPicture = [DHImageFiltersHelper pictureWithImageNamed:@"old-fashion-screen"];
    [screenPicture addTarget:_screenBlendFilter atTextureLocation:1];
    [screenPicture processImage];
    
    self.initialFilters = @[_curveFilter];
    self.terminalFilter = _screenBlendFilter;
    
    return self;
}

- (NSString *) name
{
    return @"Old Fashion";
}

@end
