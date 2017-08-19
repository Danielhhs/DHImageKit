//
//  DHComponentFilterPickerCollectionViewController.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DHImageKit/DHImageKit.h>

@class DHComponentFilterPickerCollectionViewController;
@protocol DHComponentFilterPickerCollectionViewControllerDelegate <NSObject>

- (void) compoenentFilterPicker:(DHComponentFilterPickerCollectionViewController *)picker
           didPickComponentType:(DHImageEditComponent)component;

@end

@interface DHComponentFilterPickerCollectionViewController : UICollectionViewController
@property (nonatomic, weak) id<DHComponentFilterPickerCollectionViewControllerDelegate>delegate;
@end
