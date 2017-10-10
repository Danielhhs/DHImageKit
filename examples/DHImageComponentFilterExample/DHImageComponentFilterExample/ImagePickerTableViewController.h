//
//  ImagePickerTableViewController.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImagePickerTableViewController;
@protocol ImagePickerTableViewControllerDelegate
- (void) imagePicker:(ImagePickerTableViewController *)imagePicker
        didPickImage:(UIImage *)image;
@end

@interface ImagePickerTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, weak) id<ImagePickerTableViewControllerDelegate> delegate;
@end
