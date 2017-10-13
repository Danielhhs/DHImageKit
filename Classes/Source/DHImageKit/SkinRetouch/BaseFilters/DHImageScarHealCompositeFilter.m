//
//  DHImageScarHealCompositeFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/12.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageScarHealCompositeFilter.h"

NSString * const kDHImageSkinHealingCompositingFilterFragmentShaderString =
SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform highp vec2 updateCenter;
 uniform highp float radius;
 
 uniform highp float strength;
 
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     vec2 pointToCenter = gl_FragCoord.xy - updateCenter;
     if (length(pointToCenter) > radius) {
         gl_FragColor = image;
     } else {
         lowp vec4 lowF = texture2D(inputImageTexture2, textureCoordinate2);
         float dissolve = length(pointToCenter) / radius;
         gl_FragColor = vec4(mix(image.rgb, lowF.rgb, strength * (1.0 - dissolve)), image.a);
     }
//     lowp vec4 lowF = texture2D(inputImageTexture2, textureCoordinate2);
//     gl_FragColor = lowF;
 }
 );

@interface DHImageScarHealCompositeFilter()   {
    GLuint updateCenterUniform,radiusUniform;
}
@end

@implementation DHImageScarHealCompositeFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageSkinHealingCompositingFilterFragmentShaderString];
    if (self) {
        updateCenterUniform = [filterProgram uniformIndex:@"updateCenter"];
        radiusUniform = [filterProgram uniformIndex:@"radius"];
        [self updateWithLocation:CGPointMake(-10000, -10000)];
    }
    return self;
}

- (void) setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setFloat:radius forUniform:radiusUniform program:filterProgram];
}

- (void) updateWithLocation:(CGPoint)location
{
    [self setPoint:location forUniform:updateCenterUniform program:filterProgram];
}

- (void) updateWithStrength:(double)strength
{
    [super updateWithStrength:strength];
}

@end
