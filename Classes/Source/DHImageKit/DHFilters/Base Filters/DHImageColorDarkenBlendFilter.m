//
//  DHColorDarkenBlendFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageColorDarkenBlendFilter.h"
NSString *const kDHImageDarkenBlendColorFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;

 uniform highp vec4 blendColor;
 
 void main()
 {
     lowp vec4 base = texture2D(inputImageTexture, textureCoordinate);
     
     gl_FragColor = vec4(min(blendColor.rgb * base.a, base.rgb * blendColor.a) + blendColor.rgb * (1.0 - base.a) + base.rgb * (1.0 - blendColor.a), 1.0);
 }
 );

@interface DHImageColorDarkenBlendFilter () {
    CGFloat red, green, blue, alpha;
}

@end

@implementation DHImageColorDarkenBlendFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHImageDarkenBlendColorFragmentShaderString];
    
    if (self) {
        blendColorUniform = [filterProgram uniformIndex:@"blendColor"];
    }
    
    self.blendColor = [UIColor clearColor];
    return self;
}

- (void) setBlendColor:(UIColor *)blendColor
{
    _blendColor = blendColor;
    [blendColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [self setVec4:(GPUVector4){red, green, blue, alpha}
       forUniform:blendColorUniform
          program:filterProgram];
}

- (void) updateWithStrength:(double)strength
{
    [self setVec4:(GPUVector4){red * strength, green * strength, blue * strength, alpha * strength}
       forUniform:blendColorUniform
          program:filterProgram];
}
@end
