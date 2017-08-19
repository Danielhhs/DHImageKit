//
//  DHColorPickerCollectionViewController.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHColorPickerCollectionViewControllerDelegate <NSObject>

- (void) colorPickerDidPickColor:(UIColor *)color;

- (void) colorPickerDidFinish;

- (void) colorPickerDidCancel;

@end

@interface DHColorPickerCollectionViewController : UIViewController
@property (nonatomic, weak) id<DHColorPickerCollectionViewControllerDelegate>delegate;
@end
