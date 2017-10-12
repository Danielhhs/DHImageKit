//
//  DHImageSkinHealFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinHealFilter.h"
#define sin sin
#define cos cos
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString * const kDHImageSkinHealingFilterFragmentShaderString =
SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform highp vec2 touchCenter;
 uniform highp float radius;
 uniform highp vec2 resolution;
 
 uniform highp float strength;
 
 const float c_pai = 3.1415926;
 
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     vec2 pointToCenter = gl_FragCoord.xy - touchCenter;
     float distanceToCenter = length(pointToCenter);
     if (radius <= 1.0 || distanceToCenter > radius) {
         gl_FragColor = image;
     } else {
         vec4 sum = vec4(0.0);
         for (float i = 0.0; i < 12.0; i += 1.0) {
             float angle = i / 12.0 * c_pai;
             vec2 v1 = vec2(radius * cos(angle), radius * sin(angle));
             vec2 newTexCoord = (touchCenter + v1) / resolution;
             sum += texture2D(inputImageTexture, newTexCoord);
         }
         vec4 average = sum / 12.0;
         vec4 centerColor = texture2D(inputImageTexture, touchCenter / resolution);
         vec2 edgePoint = (pointToCenter / distanceToCenter * radius + touchCenter) / resolution;
         vec4 edgeColor = texture2D(inputImageTexture, edgePoint);
         vec3 gradientRGB = mix(centerColor.rgb, edgeColor.rgb, distanceToCenter / radius);
         gl_FragColor = vec4(mix(image.rgb, gradientRGB, 0.6), 1.0);
//         gl_FragColor = vec4(vec3(distanceToCenter / radius), 1.0);
     }
 }
 );
#endif

@interface DHImageSkinHealFilter() {
    GLuint centerUniform, radiusUniform, resolutionUniform;
}
@property (nonatomic) CGSize resolution;
@property (nonatomic) CGPoint center;
@end

@implementation DHImageSkinHealFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithFragmentShaderFromString:kDHImageSkinHealingFilterFragmentShaderString];
    if (self) {
        centerUniform = [filterProgram uniformIndex:@"touchCenter"];
        radiusUniform = [filterProgram uniformIndex:@"radius"];
        resolutionUniform = [filterProgram uniformIndex:@"resolution"];
        
        self.radius = 30;
        self.resolution = size;
        self.center = CGPointMake(size.width / 2, size.height / 2);
    }
    return self;
}

- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
{
    self.center = location;
    if (completion) {
        completion();
    }
}

- (void) finishUpdating
{
    
}

- (void) setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setFloat:radius forUniform:radiusUniform program:filterProgram];
}

- (void) setResolution:(CGSize)resolution
{
    _resolution = resolution;
    [self setSize:resolution forUniform:resolutionUniform program:filterProgram];
}

- (void) setCenter:(CGPoint)center
{
    _center = center;
    [self setPoint:center forUniform:centerUniform program:filterProgram];
}

- (void) newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex
{
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
}

@end
