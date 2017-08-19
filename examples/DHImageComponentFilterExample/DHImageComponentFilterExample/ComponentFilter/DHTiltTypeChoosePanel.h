//
//  DHTiltTypeChoosePanel.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHTiltTypeChoosePanelDelegate <NSObject>

- (void) tiltTypePickerDidPickLinear;
- (void) tiltTypePickerDidPickRadial;
- (void) inputPanelDidComplete;
- (void) inputPanelDidCancel;

@end

@interface DHTiltTypeChoosePanel : UIView
@property (nonatomic, weak) id<DHTiltTypeChoosePanelDelegate> delegate;
@end
