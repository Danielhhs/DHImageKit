//
//  DHImageFalseColorFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface DHImageFalseColorFilter : GPUImageFilter
{
    GLint firstColorUniform, secondColorUniform, intensityUniform;
}

// The first and second colors specify what colors replace the dark and light areas of the image, respectively. The defaults are (0.0, 0.0, 0.5) amd (1.0, 0.0, 0.0).
@property(readwrite, nonatomic) GPUVector4 firstColor;
@property(readwrite, nonatomic) GPUVector4 secondColor;

//intensity determins how much the pixel will be updated by luminance; range is (0, 1); 0 will show the original color while 1 will show the refactored color;
@property (nonatomic) CGFloat intensity;

- (void)setFirstColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;
- (void)setSecondColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;
@end
