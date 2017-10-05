//
//  DHImageMaskViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/30.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageMaskViewController.h"
#import <GPUImage/GPUImage.h>
#import "DHImageAlphaMask.h"

@interface DHImageMaskViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) DHImageAlphaMask *mask;
@end

@implementation DHImageMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mask = [[DHImageAlphaMask alloc] initWithWidth:750 height:750];
    [self.mask addTarget:self.renderTarget];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.renderTarget addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.renderTarget addGestureRecognizer:pan];
    
    [self.mask processWithCompletion:nil];
    // Do any additional setup after loading the view.
}

- (void) handleTap:(UITapGestureRecognizer *)tap
{
    CGPoint position = [tap locationInView:self.renderTarget];
    [self.mask updateWithTouchPosition:CGPointMake(position.x, position.y)
                            completion:^{
                                [self.mask finishUpdating];
                            }];
    
}
- (IBAction)test:(id)sender {
    [self.mask updateWithTouchPosition:CGPointMake(100, 100) completion:nil];
    [self.mask updateWithTouchPosition:CGPointMake(100, 115) completion:nil];
}

- (void) handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint position = [pan locationInView:self.renderTarget];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self.mask updateWithTouchPosition:position completion:nil];
    } else {
        [self.mask finishUpdating];
    }
}

@end
