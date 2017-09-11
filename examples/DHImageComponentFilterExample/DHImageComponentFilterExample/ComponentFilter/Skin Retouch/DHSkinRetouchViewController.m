//
//  DHSkinRetouchViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHSkinRetouchViewController.h"
#import <DHImageKit/DHImageKit.h>

@interface DHSkinRetouchViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) DHImageSkinSmoothFilter *filter;
@end

@implementation DHSkinRetouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"SampleImage.jpg"]];
    
    _filter = [[DHImageSkinSmoothFilter alloc] init];
    
    [_picture addTarget:_filter];
    [_filter addTarget:self.renderTarget];
    [self.picture processImage];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.renderTarget addGestureRecognizer:pan];
}

- (void) handlePan:(UIPanGestureRecognizer *) pan
{
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self showOriginalImage];
    } else {
        [self showProcessedImage];
    }
}

- (void) showOriginalImage
{
    [self.picture removeAllTargets];
    [self.picture addTarget:self.renderTarget];
    [self.picture processImage];
}

- (void) showProcessedImage
{
    [self.picture removeAllTargets];
    [self.picture addTarget:self.filter];
    [self.picture processImage];
}

@end
