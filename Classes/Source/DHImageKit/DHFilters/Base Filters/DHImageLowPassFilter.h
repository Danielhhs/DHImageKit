//
//  DHImageLowPassFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFilterGroup.h"
#import "DHImageBuffer.h"
#import "DHImageDissolveBlendFilter.h"

@interface DHImageLowPassFilter : DHImageFilterGroup
{
    DHImageBuffer *bufferFilter;
    DHImageDissolveBlendFilter *dissolveBlendFilter;
}

// This controls the degree by which the previous accumulated frames are blended with the current one. This ranges from 0.0 to 1.0, with a default of 0.5.
@property(readwrite, nonatomic) CGFloat filterStrength;


@end
