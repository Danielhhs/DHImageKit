//
//  DHImageGrayFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/30.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageGrayFilter.h"
#import "DHImageFalseColorFilter.h"

@interface DHImageGrayFilter () {
    DHImageFalseColorFilter *falseColorFilter;
    GPUImageToneCurveFilter *curveFilter;
}

@property (nonatomic) GPUVector4 originalFirstColor;
@property (nonatomic, strong) NSArray *originalCurvePoints;
@end

@implementation DHImageGrayFilter

- (instancetype) init
{
    self = [super init];
    
    _originalFirstColor = (GPUVector4) {0.098, 0.098, 0.098, 1.f};
    
    falseColorFilter = [[DHImageFalseColorFilter alloc] init];
    falseColorFilter.firstColor = _originalFirstColor;
    falseColorFilter.secondColor = (GPUVector4) {1.f, 1.f, 1.f, 1.f};
    falseColorFilter.intensity = 1.f;
    [self addFilter:falseColorFilter];
    
    curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"moon-curve"];
    [self addFilter:curveFilter];
    _originalCurvePoints = [[curveFilter rgbCompositeControlPoints] copy];
    [falseColorFilter addTarget:curveFilter];
    
    self.initialFilters = @[falseColorFilter];
    self.terminalFilter = curveFilter;
    return self;
}

- (void) updateWithStrength:(CGFloat)strength
{
    NSMutableArray *values = [NSMutableArray array];
    for (NSValue *value in self.originalCurvePoints) {
        CGSize size = [value CGSizeValue];
        CGFloat difference = size.height - size.width;
        size.height = size.width + difference * strength;
        [values addObject:[NSValue valueWithCGSize:size]];
    }
    [curveFilter setRgbCompositeControlPoints:values];
    [falseColorFilter setIntensity:strength];
}

- (NSString *) name
{
    return @"Gray";
}

@end
