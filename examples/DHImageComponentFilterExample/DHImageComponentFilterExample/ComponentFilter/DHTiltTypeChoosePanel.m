//
//  DHTiltTypeChoosePanel.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHTiltTypeChoosePanel.h"

@interface DHTiltTypeChoosePanel ()
@property (nonatomic, strong) UIButton *linearButton;
@property (nonatomic, strong) UIButton *radialButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation DHTiltTypeChoosePanel

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _linearButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_linearButton setTitle:@"Linear" forState:UIControlStateNormal];
        _linearButton.backgroundColor = [UIColor grayColor];
        [_linearButton sizeToFit];
        _linearButton.center = CGPointMake(self.bounds.size.width / 3, self.bounds.size.height / 3);
        [_linearButton addTarget:self action:@selector(handleLinearSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_linearButton];
        
        _radialButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_radialButton setTitle:@"Linear" forState:UIControlStateNormal];
        _radialButton.backgroundColor = [UIColor grayColor];
        [_radialButton sizeToFit];
        _radialButton.center = CGPointMake(self.bounds.size.width / 3 * 2, self.bounds.size.height / 3);
        [_radialButton addTarget:self action:@selector(handleRadialSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_radialButton];
        
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor grayColor];
        [_confirmButton sizeToFit];
        _confirmButton.center = CGPointMake(self.bounds.size.width / 3, self.bounds.size.height / 3 * 2);
        [_confirmButton addTarget:self action:@selector(handleConfirm) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor grayColor];
        [_cancelButton sizeToFit];
        _cancelButton.center = CGPointMake(self.bounds.size.width / 3 * 2, self.bounds.size.height / 3 * 2);
        [_cancelButton addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void) handleLinearSelected
{
    [self.delegate tiltTypePickerDidPickLinear];
}

- (void) handleRadialSelected
{
    [self.delegate tiltTypePickerDidPickRadial];
}

- (void) handleConfirm
{
    [self.delegate inputPanelDidComplete];
}

- (void) handleCancel
{
    [self.delegate inputPanelDidCancel];
}

@end
