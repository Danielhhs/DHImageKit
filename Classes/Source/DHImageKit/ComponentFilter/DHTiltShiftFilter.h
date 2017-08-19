//
//  DHTiltShiftFilter.h
//  DHChat
//
//  Created by 黄鸿森 on 2017/7/19.
//  Copyright © 2017年 lindved. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface DHTiltShiftFilter : GPUImageFilterGroup {
    GPUImageGaussianBlurFilter *blurFilter;
    GPUImageFilter *tiltShiftFilter;
}

/// The radius of the underlying blur, in pixels. This is 5.0 by default.
@property(readwrite, nonatomic) CGFloat blurRadiusInPixels;

/// The rate at which the image gets blurry away from the in-focus region, default 0.2
@property(readwrite, nonatomic) CGFloat focusFallOffRate;

/// The alpha of the mask to show which part is blurred
@property (nonatomic) CGFloat maskAlpha;

- (void) showMaskForPicture:(GPUImagePicture *)picture;
- (void) hideMaskForPicture:(GPUImagePicture *)picture
                   duration:(NSTimeInterval)duration;

//Override to provide fragment shader for tilt shift filter
- (NSString *) tiltShiftFilterFragmentShaderString;

- (GPUImageFilter *) tiltShiftFilter;

@end
