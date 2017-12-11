//
//  DHImageFaceSkinningFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/12/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFaceThinningFilter.h"

NSString * const kDHImageFaceThinningFilterFragmentShader = SHADER_STRING
(
 precision highp float;
 const int MAX_CONTOUR_POINT_COUNT = 5;
 
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform highp float radius;
 
 uniform highp float aspectRatio;
 uniform float leftContourPoints[MAX_CONTOUR_POINT_COUNT*2];
 uniform float rightContourPoints[MAX_CONTOUR_POINT_COUNT*2];
 uniform float deltaArray[MAX_CONTOUR_POINT_COUNT];
 uniform int arraySize;
 
 highp vec2 warpPositionToUse(vec2 currentPoint, vec2 contourPointA,  vec2 contourPointB, float radius, float delta, float aspectRatio)
{
    vec2 positionToUse = currentPoint;
    vec2 currentPointToUse = vec2(currentPoint.x, currentPoint.y * aspectRatio + 0.5 - 0.5 * aspectRatio);
    vec2 contourPointAToUse = vec2(contourPointA.x, contourPointA.y * aspectRatio + 0.5 - 0.5 * aspectRatio);
    float r = distance(currentPointToUse, contourPointAToUse);
    
    if(r < radius) {
        vec2 dir = normalize(contourPointB - contourPointA);
        float dist = radius * radius - r * r;
        
        float alpha = dist / (dist + (r-delta) * (r-delta));
        alpha = alpha * alpha;
        positionToUse = positionToUse - alpha * delta * dir;
    }
    return positionToUse;
}
 
 void main() {
     vec2 positionToUse = textureCoordinate;
     for(int i = 0; i < arraySize; i++) {
         positionToUse = warpPositionToUse(positionToUse, vec2(leftContourPoints[i * 2], leftContourPoints[i * 2 + 1]), vec2(rightContourPoints[i * 2], rightContourPoints[i * 2 + 1]), radius, deltaArray[i], aspectRatio);
         positionToUse = warpPositionToUse(positionToUse, vec2(rightContourPoints[i * 2], rightContourPoints[i * 2 + 1]), vec2(leftContourPoints[i * 2], leftContourPoints[i * 2 + 1]), radius, deltaArray[i], aspectRatio);
     }
     gl_FragColor = texture2D(inputImageTexture, positionToUse);
 }
 
 );

@implementation DHImageFaceThinningFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageFaceThinningFilterFragmentShader];
    if (self) {
        radiusUniform = [filterProgram uniformIndex:@"radius"];
        aspectRatioUniform = [filterProgram uniformIndex:@"aspectRatio"];
        arraySizeUniform = [filterProgram uniformIndex:@"arraySize"];
        deltaArrayUniform = [filterProgram uniformIndex:@"deltaArray"];
        leftContourPointsUniform = [filterProgram uniformIndex:@"leftContourPoints"];
        rightContourPointsUniform = [filterProgram uniformIndex:@"rightContourPoints"];
    }
    return self;
}

- (void) setRadius:(CGFloat)radius
{
    [self setFloat:radius forUniform:radiusUniform program:filterProgram];
}

- (void) setAspectRatio:(CGFloat)aspectRatio
{
    [self setFloat:aspectRatio forUniform:aspectRatioUniform program:filterProgram];
}

- (void) setLeftContourPoints:(NSArray *)leftContourPoints
{
    GLfloat *points = malloc(sizeof(GLfloat) * [leftContourPoints count]);
    for (int i = 0; i < [leftContourPoints count]; i++) {
        points[i] = [leftContourPoints[i] floatValue];
    }
    [self setFloatArray:points length:(GLsizei)[leftContourPoints count] forUniform:leftContourPointsUniform program:filterProgram];
    free(points);
}

- (void) setRightContourPoints:(NSArray *)rightContourPoints
{
    GLfloat *points = malloc(sizeof(GLfloat) * [rightContourPoints count]);
    for (int i = 0; i < [rightContourPoints count]; i++) {
        points[i] = [rightContourPoints[i] floatValue];
    }
    [self setFloatArray:points length:(GLsizei)[rightContourPoints count] forUniform:rightContourPointsUniform program:filterProgram];
    free(points);
}

- (void) setArraySize:(int)arraySize
{
    [self setInteger:arraySize forUniform:arraySizeUniform program:filterProgram];
}

- (void) setDeltas:(NSArray *)deltas
{
    GLfloat *points = malloc([deltas count] * sizeof(GLfloat));
    for (int i = 0; i < [deltas count]; i++) {
        points[i] = [deltas[i] floatValue];
    }
    [self setFloatArray:points length:(GLsizei)[deltas count] forUniform:deltaArrayUniform program:filterProgram];
}

@end
