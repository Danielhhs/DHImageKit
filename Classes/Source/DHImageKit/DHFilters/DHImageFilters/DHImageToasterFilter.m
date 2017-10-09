//
//  DHImageToasterFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/6.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageToasterFilter.h"
#import "DHImageSixInputFilter.h"
#import "DHImageFiltersHelper.h"

NSString *const kDHToasterShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //toasterMetal
 uniform sampler2D inputImageTexture3; //toasterSoftlight
 uniform sampler2D inputImageTexture4; //toasterCurves
 uniform sampler2D inputImageTexture5; //toasterOverlayMapWarm
 uniform sampler2D inputImageTexture6; //toasterColorshift
 
 uniform mediump float strength;
 
 void main()
 {
     lowp vec3 texel;
     mediump vec2 lookup;
     vec2 blue;
     vec2 green;
     vec2 red;
     lowp vec4 tmpvar_1;
     tmpvar_1 = texture2D (inputImageTexture, textureCoordinate);
     vec4 originalTexel = tmpvar_1;
     texel = tmpvar_1.xyz;
     lowp vec4 tmpvar_2;
     tmpvar_2 = texture2D (inputImageTexture2, textureCoordinate);
     lowp vec2 tmpvar_3;
     tmpvar_3.x = tmpvar_2.x;
     tmpvar_3.y = tmpvar_1.x;
     texel.x = texture2D (inputImageTexture3, tmpvar_3).x;
     lowp vec2 tmpvar_4;
     tmpvar_4.x = tmpvar_2.y;
     tmpvar_4.y = tmpvar_1.y;
     texel.y = texture2D (inputImageTexture3, tmpvar_4).y;
     lowp vec2 tmpvar_5;
     tmpvar_5.x = tmpvar_2.z;
     tmpvar_5.y = tmpvar_1.z;
     texel.z = texture2D (inputImageTexture3, tmpvar_5).z;
     red.x = texel.x;
     red.y = 0.16666;
     green.x = texel.y;
     green.y = 0.5;
     blue.x = texel.z;
     blue.y = 0.833333;
     texel.x = texture2D (inputImageTexture4, red).x;
     texel.y = texture2D (inputImageTexture4, green).y;
     texel.z = texture2D (inputImageTexture4, blue).z;
     mediump vec2 tmpvar_6;
     tmpvar_6 = ((2.0 * textureCoordinate) - 1.0);
     mediump vec2 tmpvar_7;
     tmpvar_7.x = dot (tmpvar_6, tmpvar_6);
     tmpvar_7.y = texel.x;
     lookup = tmpvar_7;
     texel.x = texture2D (inputImageTexture5, tmpvar_7).x;
     lookup.y = texel.y;
     texel.y = texture2D (inputImageTexture5, lookup).y;
     lookup.y = texel.z;
     texel.z = texture2D (inputImageTexture5, lookup).z;
     red.x = texel.x;
     green.x = texel.y;
     blue.x = texel.z;
     texel.x = texture2D (inputImageTexture6, red).x;
     texel.y = texture2D (inputImageTexture6, green).y;
     texel.z = texture2D (inputImageTexture6, blue).z;
     lowp vec4 tmpvar_8;
     tmpvar_8.w = 1.0;
     tmpvar_8.xyz = texel;
     gl_FragColor = vec4(mix(originalTexel.rgb, tmpvar_8.rgb, strength), 1.0);
 }
 );

@interface DHImageToasterFilter ()
@property (nonatomic, strong) DHImageSixInputFilter *filter;
@property (nonatomic, strong) GPUImagePicture *metalPicture;
@property (nonatomic, strong) GPUImagePicture *softLightPicture;
@property (nonatomic, strong) GPUImagePicture *curvesPicture;
@property (nonatomic, strong) GPUImagePicture *overlayPicture;
@property (nonatomic, strong) GPUImagePicture *shiftPicture;
@end
@implementation DHImageToasterFilter

- (instancetype) init
{
    self = [super init];
    if (self) {
        _filter = [[DHImageSixInputFilter alloc] initWithFragmentShaderFromString:kDHToasterShaderString];
        [self addFilter:_filter];
        
        _metalPicture = [DHImageFiltersHelper pictureWithImageNamed:@"t1Metal"];
        [_metalPicture addTarget:_filter atTextureLocation:1];
        [_metalPicture processImage];
        
        _softLightPicture = [DHImageFiltersHelper pictureWithImageNamed:@"t1SoftLight"];
        [_softLightPicture addTarget:_filter atTextureLocation:2];
        [_softLightPicture processImage];
        
        _curvesPicture = [DHImageFiltersHelper pictureWithImageNamed:@"t1Curves"];
        [_curvesPicture addTarget:_filter atTextureLocation:3];
        [_curvesPicture processImage];
        
        _overlayPicture = [DHImageFiltersHelper pictureWithImageNamed:@"t1OverlayMapWarm"];
        [_overlayPicture addTarget:_filter atTextureLocation:4];
        [_overlayPicture processImage];
        
        _shiftPicture = [DHImageFiltersHelper pictureWithImageNamed:@"t1ColorShift"];
        [_shiftPicture addTarget:_filter atTextureLocation:5];
        [_shiftPicture processImage];
        
        self.initialFilters = @[_filter];
        self.terminalFilter = _filter;
    }
    return self;
}

@end
