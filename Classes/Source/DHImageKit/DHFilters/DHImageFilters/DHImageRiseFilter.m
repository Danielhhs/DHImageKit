//
//  DHImageRiseFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/4.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageRiseFilter.h"
#import "DHImageFiltersHelper.h"
#import "DHImageFourInputFilter.h"
NSString *const kDHImageRiseShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;
 uniform sampler2D inputImageTexture3; //overlay;
 uniform sampler2D inputImageTexture4; //map
 
 uniform mediump float strength;
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
     
     texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     
     vec4 mapped;
     mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
     mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
     mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
     mapped.a = 1.0;
     
     gl_FragColor = vec4(mix(texel.rgb, mapped.rgb, strength), mapped.a);
 }
 );

@interface DHImageRiseFilter () {
    GPUImagePicture *blowOutPicture;
    GPUImagePicture *overlayPicture;
    GPUImagePicture *mapPicture;
    DHImageFourInputFilter *filter;
}

@end

@implementation DHImageRiseFilter

- (id)init
{
    self = [super init];
    if (self) {
        filter = [[DHImageFourInputFilter alloc] initWithFragmentShaderFromString:kDHImageRiseShaderString];
        
        blowOutPicture = [DHImageFiltersHelper pictureWithImageNamed:@"blackboard1024"];
        overlayPicture = [DHImageFiltersHelper pictureWithImageNamed:@"overlayMap"];
        mapPicture = [DHImageFiltersHelper pictureWithImageNamed:@"r1Map"];
        
        [blowOutPicture addTarget:filter atTextureLocation:1];
        [blowOutPicture processImage];
        
        [overlayPicture addTarget:filter atTextureLocation:2];
        [overlayPicture processImage];
        
        [mapPicture addTarget:filter atTextureLocation:3];
        [mapPicture processImage];
        
        [self addFilter:filter];
        self.initialFilters = @[filter];
        self.terminalFilter = filter;
    }
    return self;
}
@end
