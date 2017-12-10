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

@interface FaceRecognitionViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) DHImageFaceLandmarkMask *mask;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) DHImageChangeLipColorFilter *filter;
@end

@implementation FaceRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filter = [[DHImageChangeLipColorFilter alloc] init];
    self.filter.color = (GPUVector4){1, 0, 0, 1};
    [self.filter addTarget:self.renderTarget];
    
    self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"SampleImage.jpg"]];
    [self.picture addTarget:self.filter];
    [self.picture processImage];
    
    self.mask = [[DHImageFaceLandmarkMask alloc] initWithImage:[UIImage imageNamed:@"SampleImage.jpg"] faceFeatures:DHImageFaceFeatureLip];
    [self.mask addTarget:self.filter atTextureLocation:1];
    [self.mask generateMaskWithCompletion:^{
        
    }];
}

@end
