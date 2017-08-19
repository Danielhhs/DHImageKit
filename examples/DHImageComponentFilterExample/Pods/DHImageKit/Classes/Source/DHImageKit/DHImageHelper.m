//
//  DHImageCompoentValueHelper.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageHelper.h"
#import "DHLinearTiltShiftFilter.h"
#import "DHRadialTiltShiftFilter.h"
#import "DHImageStructureFilter.h"
#import "DHImageRotateFilter.h"
#import "DHImageColorFilter.h"

@implementation DHImageHelper
+ (DHImageEditorValues) valuesforComponent:(DHImageEditComponent)component
{
    DHImageEditorValues values;
    switch (component) {
        case DHImageEditComponentAjust: {
            values.minValue = -25;
            values.maxValue = 25;
            values.initialValue = 0;
        }
            break;
        case DHImageEditComponentBrightness: {
            values.minValue = -0.25;
            values.maxValue = 0.25;
            values.initialValue = 0;
        }
            break;
        case DHImageEditComponentContrast: {
            values.minValue = 0.7;
            values.maxValue = 1.3;
            values.initialValue = 1.f;
        }
            break;
        case DHImageEditComponentStructure: {
            values.minValue = 0.0;
            values.maxValue = 0.25;
            values.initialValue = 0.0;
        }
            break;
        case DHImageEditComponentWarmth: {
            values.minValue = 3500;
            values.maxValue = 6500;
            values.initialValue = 5000;
        }
            break;
        case DHImageEditComponentSatuaration: {
            values.minValue = 0.5f;
            values.maxValue = 1.5f;
            values.initialValue = 1.f;
        }
            break;
        case DHImageEditComponentHighlight: {
            values.minValue = 0;
            values.maxValue = 0.5;
            values.initialValue = 0.f;
        }
            break;
        case DHImageEditComponentShadows: {
            values.minValue = 0;
            values.maxValue = 0.5;
            values.initialValue = 0.5f;
        }
            break;
        case DHImageEditComponentVignette: {
            values.minValue = 0.75;
            values.maxValue = 1.f;
            values.initialValue = 1.f;
        }
            break;
        case DHImageEditComponentSharpen: {
            values.minValue = 0;
            values.maxValue = 0.5;
            values.initialValue = 0;
        }
            break;
        case DHImageEditComponentFade: {
            values.minValue = -0.2f;
            values.maxValue = 0.f;
            values.initialValue = 0.f;
        }
            break;
        case DHImageEditComponentColor: {
            values.minValue = 0.f;
            values.maxValue = 1.f;
            values.initialValue = 0.f;
        }
            break;
        case DHImageEditComponentTiltShift: {
            values.minValue = 0.2f;
            values.maxValue = 0.8f;
            values.initialValue = 0.5f;
        }
            break;
        default: {
            values.minValue = 0.f;
            values.maxValue = 1.f;
            values.initialValue = 1.f;
        }
            break;
    }
    return values;
}

+ (GPUImageOutput<GPUImageInput> *) filterOfComponent:(DHImageEditComponent)component
                                              subType:(DHImageEidtComponentSubType)subType
                                        inFilterGroup:(GPUImageFilterGroup *)filterGroup
{
    Class clz = [DHImageHelper filterClassForComponent:component subType:subType];
    for (int i = 0; i < [filterGroup filterCount]; i++) {
        GPUImageOutput<GPUImageInput> *filter = [filterGroup filterAtIndex:i];
        if ([filter isKindOfClass:clz]) {
            return filter;
        }
    }
    return nil;
}

+ (NSArray *) parametersForComponent:(DHImageEditComponent)component
                             subType:(DHImageEidtComponentSubType)subType
{
    switch (component) {
        case DHImageEditComponentBrightness:
            return @[@"brightness"];
        case DHImageEditComponentContrast:
            return @[@"contrast"];
        case DHImageEditComponentStructure:
            return @[@"level"];
        case DHImageEditComponentWarmth:
            return @[@"temperature"];
        case DHImageEditComponentSatuaration:
            return @[@"saturation"];
        case DHImageEditComponentHighlight:
            return @[@"highlights"];
        case DHImageEditComponentVignette:
            return @[@"vignetteEnd"];
        case DHImageEditComponentSharpen:
            return @[@"sharpness"];
        case DHImageEditComponentFade:
            return @[@"distance"];
        case DHImageEditComponentShadows:
            return @[@"shadows"];
        case DHImageEditComponentTiltShift:{
            if (subType == DHTiltShiftSubTypeRadial) {
                return @[@"center", @"radius"];
            } else {
                return @[@"center"];
            }
        }
            break;
        case DHImageEditComponentColor:
            return @[@"color", @"strength"];
        case DHImageEditComponentAjust:
            return @[@"rotation"];
        case DHImageEditComponentNone:
            return nil;
    }
}

+ (NSString *) parameterForUpdateForComponent:(DHImageEditComponent)component subType:(DHImageEidtComponentSubType)subType
{
    NSArray *parameters = [DHImageHelper parametersForComponent:component subType:subType];
    if (component == DHImageEditComponentColor) {
        return @"strength";
    } else {
        return [parameters lastObject];
    }
}

+ (Class) filterClassForComponent:(DHImageEditComponent)component
                           subType:(DHImageEidtComponentSubType)subType
{
    switch (component) {
        case DHImageEditComponentBrightness:
            return [GPUImageBrightnessFilter class];
            break;
        case DHImageEditComponentContrast:
            return [GPUImageContrastFilter class];
            break;
        case DHImageEditComponentStructure:
            return [DHImageStructureFilter class];
            break;
        case DHImageEditComponentWarmth:
            return [GPUImageWhiteBalanceFilter class];
            break;
        case DHImageEditComponentSatuaration:
            return [GPUImageSaturationFilter class];
            break;
        case DHImageEditComponentHighlight:
            return [GPUImageHighlightShadowFilter class];
            break;
        case DHImageEditComponentVignette:
            return [GPUImageVignetteFilter class];
            break;
        case DHImageEditComponentSharpen:
            return [GPUImageSharpenFilter class];
            break;
        case DHImageEditComponentFade:
            return [GPUImageHazeFilter class];
            break;
        case DHImageEditComponentShadows:
            return [GPUImageHighlightShadowFilter class];
            break;
        case DHImageEditComponentTiltShift:{
            if (subType == DHTiltShiftSubTypeRadial) {
                return [DHRadialTiltShiftFilter class];
            } else if (subType == DHTiltShiftSubTypeLinear) {
                return  [DHLinearTiltShiftFilter class];
            } else {
                return [DHTiltShiftFilter class];
            }
        }
            break;
        case DHImageEditComponentColor:
            return [DHImageColorFilter class];
        case DHImageEditComponentAjust:
            return [DHImageRotateFilter class];
        case DHImageEditComponentNone:
            return nil;
    }
    return nil;
}

+ (CGFloat) CGAffineTransformGetScaleX:(CGAffineTransform)transform
{
    return  sqrt(transform.a * transform.a + transform.c * transform.c);
}

+ (CGFloat) CGAffineTransformGetScaleY:(CGAffineTransform)transform
{
    return sqrt(transform.b * transform.b + transform.d * transform.d);
}

+ (CGFloat) CGAffineTransformGetTranslateX:(CGAffineTransform)transform
{
    return transform.tx;
}

+ (CGFloat) CGAffineTransformGetTranslateY:(CGAffineTransform)transform
{
    return transform.ty;
}

+ (CGFloat) CGAffineTransformGetRotation:(CGAffineTransform)transform
{
    return atan2(transform.b, transform.a);
}

+ (CGFloat) DegreesToRadians:(CGFloat) degrees {
    return degrees * M_PI / 180;
}

+ (CGFloat) RadiansToDegrees:(CGFloat) radians {
    return radians * 180 / M_PI;
}

@end
