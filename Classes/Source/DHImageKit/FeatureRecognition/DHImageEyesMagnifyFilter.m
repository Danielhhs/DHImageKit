//
//  DHImageEyesMagnifyFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/12/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageEyesMagnifyFilter.h"

#define pow pow

NSString * const kDHImageEyesMagnifyFilterFragmentShader = SHADER_STRING
(
 precision highp float;
 
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 uniform highp float scaleRatio;// 缩放系数，0无缩放，大于0则放大
 uniform highp float radius;// 缩放算法的作用域半径
 uniform highp vec2 leftEyeCenterPosition; // 左眼控制点，越远变形越小
 uniform highp vec2 rightEyeCenterPosition; // 右眼控制点
 uniform float aspectRatio; // 所处理图像的宽高比
 
 highp vec2 warpPositionToUse(vec2 centerPostion, vec2 currentPosition, float radius, float scaleRatio, float aspectRatio)
 {
     vec2 positionToUse = currentPosition;
     
     vec2 currentPositionToUse = vec2(currentPosition.x, currentPosition.y * aspectRatio + 0.5 - 0.5 * aspectRatio);
     vec2 centerPostionToUse = vec2(centerPostion.x, centerPostion.y * aspectRatio + 0.5 - 0.5 * aspectRatio);
     
     float r = distance(currentPositionToUse, centerPostionToUse);
     
     if(r < radius)
     {
         float alpha = 1.0 - scaleRatio * pow(r / radius - 1.0, 2.0);
         positionToUse = centerPostion + alpha * (currentPosition - centerPostion);
     }
     
     return positionToUse;
 }
 
 void main()
 {
     vec2 positionToUse = warpPositionToUse(leftEyeCenterPosition, textureCoordinate, radius, scaleRatio, aspectRatio);
     
     positionToUse = warpPositionToUse(rightEyeCenterPosition, positionToUse, radius, scaleRatio, aspectRatio);
     
     gl_FragColor = texture2D(inputImageTexture, positionToUse);
 }
);

@implementation DHImageEyesMagnifyFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageEyesMagnifyFilterFragmentShader];
    if (self) {
        scaleRatioUniform = [filterProgram uniformIndex:@"scaleRatio"];
        radiusUniform = [filterProgram uniformIndex:@"radius"];
        leftEyeCenterUniform = [filterProgram uniformIndex:@"leftEyeCenterPosition"];
        rightEyeCenterUniform = [filterProgram uniformIndex:@"rightEyeCenterPosition"];
        aspectRatioUniform = [filterProgram uniformIndex:@"aspectRatio"];
    }
    return self;
}

- (void) setScaleRatio:(CGFloat)scaleRatio
{
    NSLog(@"scale ratio = %g", scaleRatio);
    [self setFloat:scaleRatio forUniform:scaleRatioUniform program:filterProgram];
}

- (void) setRadius:(CGFloat)radius
{
    [self setFloat:radius forUniform:radiusUniform program:filterProgram];
}

- (void) setLeftEyeCenterPosition:(CGPoint)leftEyeCenterPosition
{
    [self setPoint:leftEyeCenterPosition forUniform:leftEyeCenterUniform program:filterProgram];
}

- (void) setRightEyeCenterPosition:(CGPoint)rightEyeCenterPosition
{
    [self setPoint:rightEyeCenterPosition forUniform:rightEyeCenterUniform program:filterProgram];
}

- (void) setAspectRatio:(CGFloat)aspectRatio
{
    [self setFloat:aspectRatio forUniform:aspectRatioUniform program:filterProgram];
}

@end
