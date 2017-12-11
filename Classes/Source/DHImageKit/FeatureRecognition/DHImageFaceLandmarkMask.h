//
//  DHImageFaceLandmarkMask.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/11/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>


typedef NS_OPTIONS(NSInteger, DHImageFaceFeature) {
    DHImageFaceFeatureLeftEye = 1 << 0,
    DHImageFaceFeatureRightEye = 1 << 1,
    DHImageFaceFeatureLip = 1 << 2,
    DHImageFaceFeatureTeeth = 1 << 3,
    DHImageFaceFeatureNose = 1 << 4,
};

@interface DHImageFaceLandmarkMask : GPUImageOutput

- (instancetype) initWithImage:(UIImage *)image
                  faceFeatures:(DHImageFaceFeature)features;

- (instancetype) initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
                        faceFeatures:(DHImageFaceFeature)features;

- (CGPoint) leftPupilPosition;
- (CGPoint) rightPupilPosition;

- (NSArray *) leftContourPoints;
- (NSArray *) rightContourPoints;

- (void)generateMask;
- (BOOL)generateMaskWithCompletion:(void (^)(void))completion;
@end
