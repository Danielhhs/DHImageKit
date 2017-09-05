//
//  TakePictureViewController.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TakePictureViewControllerDelegate <NSObject>

- (void) didTakePicture:(UIImage *)picture;

@end

@interface TakePictureViewController : UIViewController
@property (nonatomic, weak) id<TakePictureViewControllerDelegate> delegate;
@end
