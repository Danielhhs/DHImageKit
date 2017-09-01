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
@property (nonatomic, strong) NSArray *originalRedCurvePoints;
@property (nonatomic, strong) NSArray *originalGreenCurvePoints;
@property (nonatomic, strong) NSArray *originalBlueCurvePoints;
@end

@implementation DHImageToneCurveFilter

- (instancetype) initWithACVData:(NSData *)data
{
    self = [super initWithACVData:data];
    if (self) {
        _originalCurvePoints = [self.rgbCompositeControlPoints copy];
        _originalRedCurvePoints = [self.redControlPoints copy];
        _originalGreenCurvePoints = [self.greenControlPoints copy];
        _originalBlueCurvePoints = [self.blueControlPoints copy];
    }
    return self;
}

- (void) updateWithStrength:(double)strength
{
    [self setRgbCompositeControlPoints:[self _updatedControlPointsForControlPoints:self.originalCurvePoints
                                                                      withStrength:strength]];
    [self setRedControlPoints:[self _updatedControlPointsForControlPoints:self.originalRedCurvePoints
                                                             withStrength:strength]];
    [self setGreenControlPoints:[self _updatedControlPointsForControlPoints:self.originalGreenCurvePoints
                                                               withStrength:strength]];
    [self setBlueControlPoints:[self _updatedControlPointsForControlPoints:self.originalBlueCurvePoints
                                                              withStrength:strength]];
}

- (NSArray *)_updatedControlPointsForControlPoints:(NSArray *)controlPoints
                                      withStrength:(CGFloat)strength
{
    NSMutableArray *values = [NSMutableArray array];
    for (NSValue *value in controlPoints) {
        CGSize size = [value CGSizeValue];
        CGFloat difference = size.height - size.width;
        size.height = size.width + difference * strength;
        [values addObject:[NSValue valueWithCGSize:size]];
    }
    return values;
}
@end
