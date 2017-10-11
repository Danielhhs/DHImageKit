//
//  SkinFiltersTableViewController.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHImageSkinFilter.h"
@class SkinFiltersTableViewController;
@protocol SkinFiltersTableViewControllerDelegate<NSObject>
- (void) filterPicker:(SkinFiltersTableViewController *)filterPicker
        didPickFilter:(DHImageSkinFilter *)filter;
@end

@interface SkinFiltersTableViewController : UITableViewController
@property (nonatomic, weak) id<SkinFiltersTableViewControllerDelegate> filterDelegate;
@end
