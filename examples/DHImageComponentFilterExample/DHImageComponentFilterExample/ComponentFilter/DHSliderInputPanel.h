//
//  DHSliderInputPanel.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHSliderInputPanel;
@protocol DHSliderInputPanelDelegate <NSObject>

- (void) inputPanelDidCancel;
- (void) inputPanelDidComplete;
- (void) inputPanel:(DHSliderInputPanel *)panel
     didChangeValue:(CGFloat)value;

@end

@interface DHSliderInputPanel : UIView

@property (nonatomic, weak) id<DHSliderInputPanelDelegate> delegate;

- (void) setMinValue:(CGFloat) minValue;
- (void) setMaxValue:(CGFloat) maxValue;
- (void) setInitialValue:(CGFloat) initialValue;
@end
