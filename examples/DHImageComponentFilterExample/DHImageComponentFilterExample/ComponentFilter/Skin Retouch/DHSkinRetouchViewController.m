//
//  DHSkinRetouchViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHSkinRetouchViewController.h"
#import <DHImageKit/DHImageKit.h>
#import "DHImageSkinHealingFilter.h"
#import "ImagePickerTableViewController.h"
#import "SkinFiltersTableViewController.h"

@interface DHSkinRetouchViewController ()<ImagePickerTableViewControllerDelegate, SkinFiltersTableViewControllerDelegate>
@property (strong, nonatomic) UISlider *strengthSlider;
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) DHImageSkinFilter *filter;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) Class filterClass;
@end

@implementation DHSkinRetouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.hidden = YES;
    self.strengthSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 450, 300, 40)];
    self.strengthSlider.value = 1.f;
    [self.view addSubview:self.strengthSlider];
    // Do any additional setup after loading the view.
    [self.strengthSlider addTarget:self action:@selector(strengthChanged:) forControlEvents:UIControlEventValueChanged];
    self.originalImage = [UIImage imageNamed:@"kriss.jpg"];
    [self initGLWithImage:_originalImage filterClass:[DHImageSkinSmoothFilter class] updateImage:YES];
    
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
    location.x /= self.renderTarget.frame.size.width;
    location.y /= self.renderTarget.frame.size.height;
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self.filter updateWithTouchLocation:location completion:^{
            [self.picture processImage];
        }];
    } else {
        [self.filter finishUpdating];
        if ([self.filterClass isEqual:[DHImageSkinHealingFilter class]]) {
            [self.filter removeAllTargets];
            [self.picture processImageUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage) {
                [self initGLWithImage:processedImage filterClass:self.filterClass updateImage:NO];
            }];
        }
    }
}

- (IBAction)showOriginalImage:(id)sender {
    self.imageView.image = self.originalImage;
    self.imageView.hidden = NO;
}

- (IBAction)showProcessedImage:(id)sender {
    self.imageView.hidden = YES;
}

- (IBAction)finish:(id)sender {
    [self.filter removeAllTargets];
    [self.picture processImageUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage) {
        [self initGLWithImage:processedImage filterClass:self.filterClass updateImage:YES];
    }];
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
    self.originalImage = image;
    [self initGLWithImage:image filterClass:self.filterClass updateImage:YES];
}

- (NSArray *) imageNames
{
    NSMutableArray *names = [@[@"kriss.jpg", @"SampleImage.jpg"] mutableCopy];
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
    [self initGLWithImage:self.image filterClass:[filter class] updateImage:NO];
}

- (void) initGLWithImage:(UIImage *)image
             filterClass:(Class)filterClass
             updateImage:(BOOL)updateImage
{
    [_picture removeAllTargets];
    [_filter removeAllTargets];
    if (updateImage) {
        self.image = image;
    }
    self.filterClass = filterClass;
    _picture = [[GPUImagePicture alloc] initWithImage:image];
    
    CGSize size = [_picture outputImageSize];
    size.width -= 2;
    size.height -= 2;
    _filter = [[filterClass alloc] initWithSize:size];
    
    [_picture addTarget:_filter];
    [_filter addTarget:self.renderTarget];
    
    [self.filter updateWithStrength:1.0];
    [self.picture processImage];
    
}
@end
