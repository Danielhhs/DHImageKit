//
//  DHImageMaskViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/30.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageMaskViewController.h"
#import <GPUImage/GPUImage.h>
#import "DHImageStrengthMask.h"

@interface DHImageMaskViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) DHImageStrengthMask *mask;
@end

@implementation DHImageMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mask = [[DHImageStrengthMask alloc] initWithWidth:750 height:750];
    [self.mask addTarget:self.renderTarget];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.renderTarget addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.renderTarget addGestureRecognizer:pan];
    
    // Do any additional setup after loading the view.
}

- (void) handleTap:(UITapGestureRecognizer *)tap
{
    CGPoint position = [tap locationInView:self.renderTarget];
    [self.mask updateWithTouchLocation:CGPointMake(position.x, position.y)
                            completion:^{
                                [self.mask finishUpdating];
                            }];
    
}
- (IBAction)test:(id)sender {
    [self.mask updateWithTouchLocation:CGPointMake(100, 100) completion:nil];
    [self.mask updateWithTouchLocation:CGPointMake(100, 115) completion:nil];
}

- (void) handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint position = [pan locationInView:self.renderTarget];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self.mask updateWithTouchLocation:position completion:nil];
    } else {
        [self.mask finishUpdating];
    }
}

@end
