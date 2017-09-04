//
//  DHImageGrayFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/30.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageGrayFilter.h"
#import "DHImageFalseColorFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageContrastBrightnessFilter.h"

@interface DHImageGrayFilter () {
    DHImageFalseColorFilter *falseColorFilter;
    DHImageToneCurveFilter *curveFilter;
    DHImageContrastBrightnessFilter *contrastFilter;
}

@property (nonatomic) GPUVector4 originalFirstColor;
@end

@implementation DHImageGrayFilter

- (instancetype) init
{
    self = [super init];
    
    _originalFirstColor = (GPUVector4) {0.098, 0.098, 0.098, 1.f};
    
    falseColorFilter = [[DHImageFalseColorFilter alloc] init];
    falseColorFilter.firstColor = _originalFirstColor;
    falseColorFilter.secondColor = (GPUVector4) {1.f, 1.f, 1.f, 1.f};
    [falseColorFilter updateWithStrength:1.f];
    [self addFilter:falseColorFilter];
    
    curveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"gray-curve"];
    [self addFilter:curveFilter];
    [falseColorFilter addTarget:curveFilter];
    
    contrastFilter = [[DHImageContrastBrightnessFilter alloc] init];
    contrastFilter.contrast = 1.2f;
    [self addFilter:contrastFilter];
    [curveFilter addTarget:contrastFilter];
    
    self.initialFilters = @[falseColorFilter];
    self.terminalFilter = contrastFilter;
    return self;
}

- (NSString *) name
{
    return @"Gray";
}

@end
