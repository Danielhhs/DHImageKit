//
//  DHImageConstants.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#ifndef DHImageConstants_h
#define DHImageConstants_h

typedef NS_ENUM(NSInteger, DHImageEditComponent) {
    DHImageEditComponentNone = -1,
    DHImageEditComponentAjust,
    DHImageEditComponentBrightness,
    DHImageEditComponentContrast,
    DHImageEditComponentStructure,
    DHImageEditComponentWarmth,
    DHImageEditComponentSatuaration,
    DHImageEditComponentColor,
    DHImageEditComponentFade,
    DHImageEditComponentHighlight,
    DHImageEditComponentShadows,
    DHImageEditComponentVignette,
    DHImageEditComponentTiltShift,
    DHImageEditComponentSharpen,
};

typedef NS_ENUM(NSInteger, DHImageEidtComponentSubType) {
    DHImageEidtComponentSubTypeNone,
    DHTiltShiftSubTypeLinear,
    DHTiltShiftSubTypeRadial,
};

typedef struct {
    double minValue;
    double maxValue;
    double initialValue;
}DHImageEditorValues;

#endif /* DHImageConstants_h */
