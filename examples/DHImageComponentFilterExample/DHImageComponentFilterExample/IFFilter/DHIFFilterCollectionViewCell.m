//
//  DHIFFilterCollectionViewCell.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/8/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHIFFilterCollectionViewCell.h"
@interface DHIFFilterCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation DHIFFilterCollectionViewCell
- (void) setText:(NSString *)text
{
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
}
@end
