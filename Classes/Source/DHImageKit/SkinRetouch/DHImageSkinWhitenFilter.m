//
//  DHImageSkinWhitenFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageSkinWhitenFilter.h"
#import "DHImageSkinSmoothMaskFilter.h"
#import "DHImageExposureFilter.h"
#import "DHImageDissolveBlendFilter.h"
#import "DHImageToneCurveFilter.h"
#import "DHImageSharpenFilter.h"
#import "DHImageStrengthMask.h"
#import "DHImageFourInputFilter.h"
#import "DHImageSoftLightBlendFilter.h"

NSString * const kDHImageSkinWhitenCompositingFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 varying highp vec2 textureCoordinate3;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 uniform highp vec2 renderCenter;
 uniform highp float renderRadius;
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 toneCurvedImage = texture2D(inputImageTexture2, textureCoordinate);
     lowp vec4 strengthMask = texture2D(inputImageTexture3, textureCoordinate);
     gl_FragColor = vec4(mix(image.rgb,toneCurvedImage.rgb,strengthMask.a),1.0);
 }
 );

@interface DHImageSkinWhitenFilter()
@property (nonatomic, strong) DHImageExposureFilter *exposureFilter;
@property (nonatomic, strong) DHImageToneCurveFilter *toneCurveFilter;
@property (nonatomic, strong) DHImageThreeInputFilter *compositeFilter;
@property (nonatomic) CGSize currentInputSize;
@end

@implementation DHImageSkinWhitenFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _toneCurveFilter = [[DHImageToneCurveFilter alloc] initWithACV:@"whiten-curve"];
        [self addFilter:_toneCurveFilter];
        
        _compositeFilter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinWhitenCompositingFilterFragmentShaderString];
        [self.toneCurveFilter addTarget:_compositeFilter atTextureLocation:1];
        [self.strengthMask addTarget:self.compositeFilter atTextureLocation:2];
        [self addFilter:_compositeFilter];
        
        self.initialFilters = @[_toneCurveFilter, _compositeFilter];
        self.terminalFilter = self.compositeFilter;
        
    }
    return self;
}

- (void) setControlPoints:(NSArray *)controlPoints
{
    _controlPoints = [controlPoints copy];
    self.toneCurveFilter.rgbCompositeControlPoints = _controlPoints;
}
@end
