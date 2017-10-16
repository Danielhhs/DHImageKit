//
//  TakePictureViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/9/5.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "TakePictureViewController.h"
#import <DHImageKit/DHImageKit.h>

@interface TakePictureViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *target;
@property (nonatomic, strong) GPUImageStillCamera *camera;
@property (nonatomic, strong) GPUImageCropFilter *filter;
@end

@implementation TakePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetMedium cameraPosition:AVCaptureDevicePositionBack];
    _camera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    _camera.horizontallyMirrorFrontFacingCamera = YES;
    
    self.filter = [[GPUImageCropFilter alloc] init];
    CMVideoDimensions dimenssion = [self.camera.inputCamera activeFormat].highResolutionStillImageDimensions;
    CGFloat ratio = dimenssion.height / ((CGFloat)dimenssion.width);
    self.filter.cropRegion = CGRectMake(0, (1 - ratio) / 2, 1, ratio);
    
    [self.filter addTarget:self.target];
    [self.camera addTarget:self.filter];

    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancel)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    
    UIBarButtonItem *take = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStylePlain target:self action:@selector(handleTake)];
    self.navigationItem.rightBarButtonItem = take;
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.camera startCameraCapture];
}

- (void) handleCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) handleTake
{
    [self.camera capturePhotoAsImageProcessedUpToFilter:self.filter withOrientation:UIImageOrientationUp withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        [self.camera stopCameraCapture];
        [self.delegate didTakePicture:processedImage];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
