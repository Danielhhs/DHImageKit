//
//  DHImageStrengthMapExposureFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/5.
//

#import <GPUImage/GPUImage.h>

@interface DHImageStrengthMapExposureFilter : GPUImageTwoInputFilter
{
    GLint exposureUniform, gammaUniform;
}

// Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat exposure;
@property (readwrite, nonatomic) CGFloat gamma;


@end
