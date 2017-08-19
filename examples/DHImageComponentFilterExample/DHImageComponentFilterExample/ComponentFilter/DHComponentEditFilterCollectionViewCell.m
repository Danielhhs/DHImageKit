//
//  DHComponentEditFilterCollectionViewCell.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHComponentEditFilterCollectionViewCell.h"

@interface DHComponentEditFilterCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation DHComponentEditFilterCollectionViewCell

- (void) setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void) setText:(NSString *)text
{
    self.textLabel.text = text;
}

@end
