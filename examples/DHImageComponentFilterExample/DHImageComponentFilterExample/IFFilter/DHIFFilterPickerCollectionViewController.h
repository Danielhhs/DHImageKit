//
//  DHIFFilterPickerCollectionViewController.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/8/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaFilters.h"

@protocol DHIFFilterPickerCollectionViewControllerDelegate <NSObject>

- (void) filterPickerDidPickFilter:(IFImageFilter *)filter;

@end

@interface DHIFFilterPickerCollectionViewController : UICollectionViewController
@property (nonatomic, weak) id<DHIFFilterPickerCollectionViewControllerDelegate> delegate;
@end
