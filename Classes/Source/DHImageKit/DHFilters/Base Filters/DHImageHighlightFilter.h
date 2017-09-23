//
//  DHImageHighlightFilter.h
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/9/23.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageBaseFilter.h"

@interface DHImageHighlightFilter : DHImageBaseFilter {
    GLint highlightUniform;
}
@property (nonatomic) CGFloat highlights;
@end
