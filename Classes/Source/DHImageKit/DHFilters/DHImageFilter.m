//
//  DHImageFilter.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/8/30.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFilter.h"
#import "DHImageTwoInputFilter.h"

@interface DHImageFilter ()
@property (nonatomic, strong) NSArray<GPUImagePicture *> *sources;
@end

@implementation DHImageFilter

- (instancetype) initWithFragmentShaderFromString:(NSString *)fragmentShaderString
{
    return [self initWithFragmentShaderFromString:fragmentShaderString sources:nil];
}

- (instancetype) initWithFragmentShaderFromString:(NSString *)fragmentShaderString sources:(NSArray<GPUImagePicture *> *)sources
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _sources = sources;
    Class filterClass;
    switch ([sources count]) {
        case 1:
            filterClass = [DHImageTwoInputFilter class];
            break;
        case 2:
            filterClass = [GPUImageThreeInputFilter class];
            break;
        default:
            break;
    }
    GPUImageFilter *filter = [[filterClass alloc] initWithFragmentShaderFromString:fragmentShaderString];
    [self addFilter:filter];
    
    int sourceIndex = 1;
    for (GPUImagePicture *source in sources) {
        [source addTarget:filter atTextureLocation:sourceIndex];
        sourceIndex++;
        [source processImage];
    }
    
    self.initialFilters = @[filter];
    self.terminalFilter = filter;
    return self;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self updateWithStrength:1.f];
    }
    return self;
}

- (NSString *) name
{
    return nil;
}

@end
