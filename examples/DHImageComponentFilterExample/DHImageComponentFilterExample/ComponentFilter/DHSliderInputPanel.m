//
//  DHSliderInputPanel.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHSliderInputPanel.h"

@interface DHSliderInputPanel ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation DHSliderInputPanel

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 30, frame.size.width - 40, 30)];
        [self addSubview:_slider];
        [_slider addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _confirmButton.backgroundColor = [UIColor grayColor];
        [_confirmButton setTintColor:[UIColor blackColor]];
        [_confirmButton setTitle:@"Done" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(handleConfirm) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton sizeToFit];
        _confirmButton.center = CGPointMake(50, CGRectGetMaxY(_slider.frame) + 20);
        [self addSubview:_confirmButton];
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _cancelButton.backgroundColor = [UIColor grayColor];;
        [_cancelButton setTintColor:[UIColor blackColor]];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton sizeToFit];
        _cancelButton.center = CGPointMake(CGRectGetMaxX(frame) - 50, CGRectGetMaxY(_slider.frame) + 20);
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void) handleValueChanged:(UISlider *)slider
{
    [self.delegate inputPanel:self didChangeValue:slider.value];
}

- (void) handleConfirm
{
    [self.delegate inputPanelDidComplete];
}

- (void) handleCancel
{
    [self.delegate inputPanelDidCancel];
}

- (void) setMinValue:(CGFloat)minValue
{
    [self.slider setMinimumValue:minValue];
}

- (void) setMaxValue:(CGFloat)maxValue
{
    [self.slider setMaximumValue:maxValue];
}

- (void) setInitialValue:(CGFloat)initialValue
{
    [self.slider setValue:initialValue];
}
@end
