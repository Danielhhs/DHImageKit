//
//  DHImageCompoentValueHelper.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHImageConstants.h"
#import <GPUImage/GPUImage.h>

@interface DHImageHelper : NSObject

+ (DHImageEditorValues) valuesforComponent:(DHImageEditComponent)component;

+ (GPUImageOutput<GPUImageInput> *) filterOfComponent:(DHImageEditComponent)component
                                              subType:(DHImageEidtComponentSubType)subType
                                        inFilterGroup:(GPUImageFilterGroup *)filterGroup;

+ (Class) filterClassForComponent:(DHImageEditComponent)component
                          subType:(DHImageEidtComponentSubType)subType;

+ (NSArray *) parametersForComponent:(DHImageEditComponent)component
                             subType:(DHImageEidtComponentSubType)subType;

+ (NSString *) parameterForUpdateForComponent:(DHImageEditComponent)component
                                      subType:(DHImageEidtComponentSubType)subType;

+ (CGFloat) CGAffineTransformGetScaleX:(CGAffineTransform)transform;
+ (CGFloat) CGAffineTransformGetRotation:(CGAffineTransform)transform;
+ (CGFloat) CGAffineTransformGetScaleY:(CGAffineTransform)transform;
+ (CGFloat) CGAffineTransformGetTranslateX:(CGAffineTransform)transform;
+ (CGFloat) CGAffineTransformGetTranslateY:(CGAffineTransform)transform;
+ (CGFloat) DegreesToRadians:(CGFloat) degrees;
+ (CGFloat) RadiansToDegrees:(CGFloat) radians;

@end
