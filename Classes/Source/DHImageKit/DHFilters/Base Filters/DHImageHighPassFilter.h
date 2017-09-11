//
//  DHImageHighPassFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFilterGroup.h"
#import "DHImageLowPassFilter.h"
#import "DHImageDifferenceBlendFilter.h"

@interface DHImageHighPassFilter : DHImageFilterGroup
{
    DHImageLowPassFilter *lowPassFilter;
    DHImageDifferenceBlendFilter *differenceBlendFilter;
}

// This controls the degree by which the previous accumulated frames are blended and then subtracted from the current one. This ranges from 0.0 to 1.0, with a default of 0.5.
@property(readwrite, nonatomic) CGFloat filterStrength;


@end
