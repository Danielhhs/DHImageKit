//
//  DHImageEyesMagnifyFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/12/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>

@interface DHImageEyesMagnifyFilter : DHImageBaseFilter {
    GLuint scaleRatioUniform, radiusUniform, leftEyeCenterUniform, rightEyeCenterUniform, aspectRatioUniform;
}
@property (nonatomic) CGFloat scaleRatio;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGPoint leftEyeCenterPosition;
@property (nonatomic) CGPoint rightEyeCenterPosition;
@property (nonatomic) CGFloat aspectRatio;
@end
