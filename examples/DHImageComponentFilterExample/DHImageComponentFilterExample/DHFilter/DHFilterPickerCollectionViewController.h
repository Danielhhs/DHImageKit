//
//  DHFilterPickerCollectionViewController.h
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DHImageKit/DHImageKit.h>

@protocol DHFilterPickerCollectionViewControllerDelegate <NSObject>

- (void) DHFilterPickerDidPickFilter:(DHImageFilter *) filter;

@end

@interface DHFilterPickerCollectionViewController : UICollectionViewController
@property (nonatomic, weak) id<DHFilterPickerCollectionViewControllerDelegate> delegate;
@end
