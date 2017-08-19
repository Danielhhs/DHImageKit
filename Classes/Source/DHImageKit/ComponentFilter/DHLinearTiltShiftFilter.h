//
//  DHLinearTiltShiftFilter.h
//  DHChat
//
//  Created by 黄鸿森 on 2017/7/19.
//  Copyright © 2017年 lindved. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHTiltShiftFilter.h"

@interface DHLinearTiltShiftFilter : DHTiltShiftFilter

/// The normalized location of the center of the in-focus area in the image; default is 0.5
@property(readwrite, nonatomic) CGFloat center;

/// The normalized location of the range of the in-focus area in the image; default is 0.1
@property(readwrite, nonatomic) CGFloat range;
@end
