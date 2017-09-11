//
//  DHImageHighPassFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageHighPassFilter.h"

@implementation DHImageHighPassFilter
- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    // Start with a low pass filter to define the component to be removed
    lowPassFilter = [[DHImageLowPassFilter alloc] init];
    [self addFilter:lowPassFilter];
    
    // Take the difference of the current frame from the low pass filtered result to get the high pass
    differenceBlendFilter = [[DHImageDifferenceBlendFilter alloc] init];
    [self addFilter:differenceBlendFilter];
    
    // Texture location 0 needs to be the original image for the difference blend
    [lowPassFilter addTarget:differenceBlendFilter atTextureLocation:1];
    
    self.initialFilters = [NSArray arrayWithObjects:lowPassFilter, differenceBlendFilter, nil];
    self.terminalFilter = differenceBlendFilter;
    
    self.filterStrength = 0.5;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setFilterStrength:(CGFloat)newValue;
{
    lowPassFilter.filterStrength = newValue;
}

- (CGFloat)filterStrength;
{
    return lowPassFilter.filterStrength;
}

@end
