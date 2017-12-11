//
//  DHImageFaceSkinningFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/12/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@interface DHImageFaceThinningFilter : DHImageBaseFilter {
    GLuint radiusUniform, aspectRatioUniform, arraySizeUniform, leftContourPointsUniform, rightContourPointsUniform, deltaArrayUniform;
    
}
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic, strong) NSArray *leftContourPoints;
@property (nonatomic, strong) NSArray *rightContourPoints;
@property (nonatomic, strong) NSArray *deltas;
@property (nonatomic) int arraySize;
@end
