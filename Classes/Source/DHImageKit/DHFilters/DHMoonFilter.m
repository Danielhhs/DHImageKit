//
//  DHMoonFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHMoonFilter.h"
#import "DHIFFiltersHelper.h"

NSString *const kDHMoonShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@interface DHMoonFilter () {
    GPUImagePicture *mapPicture;
}
@end
@implementation DHMoonFilter

- (instancetype) init
{
    self = [super initWithFragmentShaderFromString:kDHMoonShaderString];
    
    if (self) {
        mapPicture = [DHIFFiltersHelper pictureWithImageNamed:@"1977map"];
        [mapPicture addTarget:self atTextureLocation:1];
        [mapPicture processImage];
    }
    return self;
}

- (CGImageRef)newCGImageByFilteringCGImage:(CGImageRef)imageToFilter;
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithCGImage:imageToFilter];
    
    [self useNextFrameForImageCapture];
    [stillImageSource addTarget:(id<GPUImageInput>)self atTextureLocation:0];
    [stillImageSource processImage];
    
    CGImageRef processedImage = [self newCGImageFromCurrentlyProcessedOutput];
    
    [stillImageSource removeTarget:(id<GPUImageInput>)self];
    return processedImage;
}

@end
