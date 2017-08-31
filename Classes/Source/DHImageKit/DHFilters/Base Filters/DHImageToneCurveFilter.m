//
//  DHImageCurveToneFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageToneCurveFilter.h"

@interface DHImageToneCurveFilter ()
@property (nonatomic, strong) NSArray *originalCurvePoints;
@end

@implementation DHImageToneCurveFilter

- (instancetype) initWithACVData:(NSData *)data
{
    self = [super initWithACVData:data];
    if (self) {
        _originalCurvePoints = [self.rgbCompositeControlPoints copy];
    }
    return self;
}

- (void) updateWithStrength:(double)strength
{
    NSMutableArray *values = [NSMutableArray array];
    for (NSValue *value in self.originalCurvePoints) {
        CGSize size = [value CGSizeValue];
        CGFloat difference = size.height - size.width;
        size.height = size.width + difference * strength;
        [values addObject:[NSValue valueWithCGSize:size]];
    }
    [self setRgbCompositeControlPoints:values];
}

@end
