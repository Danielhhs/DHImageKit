//
//  DHImageScarHealCompositeFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/12.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import <DHImageKit/DHImageKit.h>

@interface DHImageScarHealCompositeFilter : DHImageTwoInputFilter
@property (nonatomic) CGFloat radius;
- (void) updateWithLocation:(CGPoint)location;
@end
