//
//  DHImageSkinHealFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageScarHealFilter.h"
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString * const kDHImageSkinHealingFilterFragmentShaderString =
SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform highp vec2 goodSkinCenter;
 uniform highp vec2 badSkinCenter;
 uniform highp float radius;
 uniform highp vec2 resolution;
 
 uniform highp float strength;
 
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     
     if (goodSkinCenter.x < 0.0) {
         gl_FragColor = image;
         return;
     }
     
     vec2 pointToBadCenter = gl_FragCoord.xy - badSkinCenter;
     float distanceToBadCenter = length(pointToBadCenter);
     if (distanceToBadCenter < radius) {
         vec2 centerVector = goodSkinCenter - badSkinCenter;
         vec2 mappedVector = gl_FragCoord.xy + centerVector;
         vec2 mappedTexCoords = mappedVector / resolution;
         gl_FragColor = texture2D(inputImageTexture, mappedTexCoords);
//         gl_FragColor = vec4(1.0);
     } else {
         gl_FragColor = image;
     }
 }
 );
#endif

@interface DHImageScarHealFilter() {
    BOOL firstTouch;
    GLuint goodSkinCenterUniform, badSkinCenterUniform, radiusUniform, resolutionUniform;
}
@property (nonatomic) CGSize resolution;
@property (nonatomic) CGPoint goodSkinCenter;
@property (nonatomic) CGPoint badSkinCenter;
@end

@implementation DHImageScarHealFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithFragmentShaderFromString:kDHImageSkinHealingFilterFragmentShaderString];
    if (self) {
        firstTouch = YES;
        goodSkinCenterUniform = [filterProgram uniformIndex:@"goodSkinCenter"];
        badSkinCenterUniform = [filterProgram uniformIndex:@"badSkinCenter"];
        radiusUniform = [filterProgram uniformIndex:@"radius"];
        resolutionUniform = [filterProgram uniformIndex:@"resolution"];
        
        self.resolution = size;
    }
    return self;
}

- (void) finishUpdating
{
    firstTouch = YES;
}

- (void) setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setFloat:radius forUniform:radiusUniform program:filterProgram];
}

- (void) setBadSkinCenter:(CGPoint)badSkinCenter
{
    _badSkinCenter = badSkinCenter;
    [self setPoint:_badSkinCenter forUniform:badSkinCenterUniform program:filterProgram];
}

- (void) setGoodSkinCenter:(CGPoint)goodSkinCenter
{
    _goodSkinCenter = goodSkinCenter;
    [self setPoint:_goodSkinCenter forUniform:goodSkinCenterUniform program:filterProgram];
}

- (void) setResolution:(CGSize)resolution
{
    _resolution = resolution;
    [self setSize:resolution forUniform:resolutionUniform program:filterProgram];
}

- (void) newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex
{
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
}

- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
{
    if (firstTouch) {
        firstTouch = NO;
        self.badSkinCenter = location;
    } else {
        self.goodSkinCenter = location;
    }
    if (completion) {
        completion();
    }
}

@end
