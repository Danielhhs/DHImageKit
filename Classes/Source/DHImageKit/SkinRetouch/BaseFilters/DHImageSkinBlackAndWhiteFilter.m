//
//  DHImageSkinBlackAndWhiteFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/13.
//

#import "DHImageSkinBlackAndWhiteFilter.h"
#import "DHImageGrayFilter.h"
NSString * const kDHImageSkinBlackAndWhiteCompositingFilterFragmentShaderString =
SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 varying highp vec2 textureCoordinate3;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 uniform highp float strength;
 
 void main() {
     lowp vec4 image = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 grayed = texture2D(inputImageTexture2, textureCoordinate2);
     lowp vec4 strengthMap = texture2D(inputImageTexture3, textureCoordinate3);
     gl_FragColor = vec4(mix(image.rgb, grayed.rgb, strengthMap.a * strength), image.a);
 }
 );
@interface DHImageSkinBlackAndWhiteFilter()
@property (nonatomic, strong) DHImageGrayFilter *blackAndWhiteFilter;
@property (nonatomic, strong) DHImageThreeInputFilter *compositeFilter;
@end

@implementation DHImageSkinBlackAndWhiteFilter

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _blackAndWhiteFilter = [[DHImageGrayFilter alloc] init];
        [self addFilter:_blackAndWhiteFilter];
        
        _compositeFilter = [[DHImageThreeInputFilter alloc] initWithFragmentShaderFromString:kDHImageSkinBlackAndWhiteCompositingFilterFragmentShaderString];
        [self addFilter:_compositeFilter];
        [_blackAndWhiteFilter addTarget:_compositeFilter atTextureLocation:1];
        [self.strengthMask addTarget:_compositeFilter atTextureLocation:2];
        
        self.initialFilters = @[_blackAndWhiteFilter, _compositeFilter];
        self.terminalFilter = _compositeFilter;
    }
    return self;
}

@end
