//
//  DHImageTwoInputFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/30.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <GPUImage/GPUImage.h>
#import "DHImageUpdatable.h"

extern NSString *const kDHImageTwoInputTextureVertexShaderString;

@interface DHImageTwoInputFilter : GPUImageFilter<DHImageUpdatable>
{
    GPUImageFramebuffer *secondInputFramebuffer;
    
    GLint filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    GLint strengthUniform;
    GPUImageRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
}

- (void)disableFirstFrameCheck;
- (void)disableSecondFrameCheck;



@end
