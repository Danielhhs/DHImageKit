//
//  FaceRecognitionViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/11/8.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "FaceRecognitionViewController.h"
#import "DHImageFaceLandmarkMask.h"
#import "DHImageChangeLipColorFilter.h"
#import <GPUImage/GPUImage.h>
#import "DHImageEyesMagnifyFilter.h"
#import "DHImageFaceThinningFilter.h"

@interface FaceRecognitionViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) DHImageFaceLandmarkMask *mask;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) DHImageChangeLipColorFilter *filter;
@property (weak, nonatomic) IBOutlet UISlider *eyesSlider;
@property (nonatomic, strong) DHImageFaceThinningFilter *faceThinningFilter;
@property (nonatomic, strong) DHImageEyesMagnifyFilter *eysFilter;
@end

@implementation FaceRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.filter = [[DHImageChangeLipColorFilter alloc] init];
//    self.filter.color = (GPUVector4){1, 0, 0, 1};
//    [self.filter addTarget:self.renderTarget];
//
//    self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"SampleImage.jpg"]];
//    [self.picture addTarget:self.filter];
//    [self.picture processImage];
//
//    self.mask = [[DHImageFaceLandmarkMask alloc] initWithImage:[UIImage imageNamed:@"SampleImage.jpg"] faceFeatures:DHImageFaceFeatureLip];
//    [self.mask addTarget:self.filter atTextureLocation:1];
//    [self.mask generateMaskWithCompletion:^{
//
//    }];
    
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 0.3;
    self.eyesSlider.minimumValue = 0;
    self.eyesSlider.maximumValue = 1.f;
    UIImage *image = [UIImage imageNamed:@"liqian.png"];
    self.mask = [[DHImageFaceLandmarkMask alloc] initWithImage:image faceFeatures:DHImageFaceFeatureLip];
    self.eysFilter = [[DHImageEyesMagnifyFilter alloc] init];
    self.eysFilter.scaleRatio = 0;
    self.eysFilter.radius = 0.2;
    self.eysFilter.aspectRatio = image.size.width / image.size.height;
    self.eysFilter.leftEyeCenterPosition = [self.mask leftPupilPosition];
    self.eysFilter.rightEyeCenterPosition = [self.mask rightPupilPosition];
    
    self.faceThinningFilter = [[DHImageFaceThinningFilter alloc] init];
    self.faceThinningFilter.leftContourPoints = [self.mask leftContourPoints];
    self.faceThinningFilter.rightContourPoints = [self.mask rightContourPoints];
    self.faceThinningFilter.arraySize = 5;
    self.faceThinningFilter.aspectRatio = image.size.width / image.size.height;
    self.faceThinningFilter.radius = 0.05;
    self.faceThinningFilter.deltas = @[@(0.8), @(0.8), @(0.5), @(0.5), @(0.7)];
    [self.eysFilter addTarget:self.faceThinningFilter];
    [self.faceThinningFilter addTarget:self.renderTarget];
    
        self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"liqian.png"]];
        [self.picture addTarget:self.eysFilter];
        [self.picture processImage];
    
}

- (IBAction)showOriginal:(id)sender {
    [self.picture removeAllTargets];
    [self.eysFilter removeAllTargets];
    [self.faceThinningFilter removeAllTargets];
    [self.picture addTarget:self.renderTarget];
    [self.picture processImage];
}
- (IBAction)showProcessed:(id)sender {
    [self.picture removeAllTargets];
    [self.picture addTarget:self.eysFilter];
    [self.eysFilter addTarget:self.faceThinningFilter];
    [self.faceThinningFilter addTarget:self.renderTarget];
    [self.picture processImage];
}

- (IBAction)valueChanged:(id)sender {
    self.faceThinningFilter.radius = self.slider.value;
    [self.picture processImage];
}

- (IBAction)eyesChanged:(id)sender {
    self.eysFilter.scaleRatio = self.eyesSlider.value;
    [self.picture processImage];
}

@end
