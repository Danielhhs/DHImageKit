//
//  DHSkinRetouchViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHSkinRetouchViewController.h"
#import <DHImageKit/DHImageKit.h>
#import "ImagePickerTableViewController.h"
#import "SkinFiltersTableViewController.h"

@interface DHSkinRetouchViewController ()<ImagePickerTableViewControllerDelegate, SkinFiltersTableViewControllerDelegate>
@property (strong, nonatomic) UISlider *strengthSlider;
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) DHImageSkinFilter *filter;
@end

@implementation DHSkinRetouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.strengthSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 450, 300, 40)];
    self.strengthSlider.value = 1.f;
    [self.view addSubview:self.strengthSlider];
    // Do any additional setup after loading the view.
    [self.strengthSlider addTarget:self action:@selector(strengthChanged:) forControlEvents:UIControlEventValueChanged];
    _picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"scar.png"]];
    
    _filter = [[DHImageSkinSmoothFilter alloc] initWithSize:CGSizeMake(750, 750)];
    
    [_picture addTarget:_filter];
    [_filter addTarget:self.renderTarget];
    [self.picture processImage];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.renderTarget addGestureRecognizer:pan];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"选图" style:UIBarButtonItemStylePlain target:self action:@selector(showPic)];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"元素" style:UIBarButtonItemStylePlain target:self action:@selector(showFilters)];
    self.navigationItem.rightBarButtonItems = @[leftButton, rightButton];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.filter updateWithStrength:self.strengthSlider.value];
    [self.picture processImage];
}

- (void) handlePan:(UIPanGestureRecognizer *) pan
{
    CGPoint location = [pan locationInView:self.renderTarget];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self.filter updateWithTouchLocation:location completion:^{
            [self.picture processImage];
        }];
    } else {
        [self.filter finishUpdating];
    }
}

- (IBAction)showOriginalImage:(id)sender {
    [self.picture removeAllTargets];
    [self.picture addTarget:self.renderTarget];
    [self.picture processImage];
}

- (IBAction)showProcessedImage:(id)sender {
    [self.picture removeAllTargets];
    [self.picture addTarget:self.filter];
    [self.picture processImage];
}

- (void) strengthChanged:(UISlider *)slider
{
    [self.filter updateWithStrength:slider.value];
    [self.picture processImage];
}

- (void) showPic
{
    ImagePickerTableViewController *imagePicker = [[ImagePickerTableViewController alloc] init];
    imagePicker.delegate = self;
    imagePicker.imageNames = [self imageNames];
    [self.navigationController pushViewController:imagePicker animated:YES];
}

- (void) imagePicker:(ImagePickerTableViewController *)imagePicker didPickImage:(UIImage *)image
{
    self.picture = [[GPUImagePicture alloc] initWithImage:image];
    [self.picture addTarget:self.filter];
}

- (NSArray *) imageNames
{
    NSMutableArray *names = [NSMutableArray array];
    for (int i = 1; i <= 7; i++) {
        [names addObject:[NSString stringWithFormat:@"freckle%d.jpg", i]];
    }
    
    for (int i = 1; i <= 6; i++) {
        [names addObject:[NSString stringWithFormat:@"pimple%d.jpg", i]];
    }
    return names;
}

- (void) showFilters
{
    SkinFiltersTableViewController *filterPicker = [[SkinFiltersTableViewController alloc] init];
    filterPicker.filterDelegate = self;
    [self.navigationController pushViewController:filterPicker animated:YES];
}

- (void) filterPicker:(SkinFiltersTableViewController *)filterPicker didPickFilter:(DHImageSkinFilter *)filter
{
    [self.filter removeAllTargets];
    [self.picture removeAllTargets];
    self.filter = filter;
    [self.picture addTarget:self.filter];
    [self.filter addTarget:self.renderTarget];
    [self.filter updateWithStrength:1.f];
    [self.picture processImage];
}
@end
