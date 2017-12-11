//
//  RealTimeFaceRecognitionViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/12/11.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "RealTimeFaceRecognitionViewController.h"
#import <GPUImage/GPUImage.h>
#import "DHImageEyesMagnifyFilter.h"
#import "DHImageFaceThinningFilter.h"
#import "DHImageFaceLandmarkMask.h"
#import <Vision/Vision.h>
#import <Accelerate/Accelerate.h>

@interface RealTimeFaceRecognitionViewController ()<GPUImageVideoCameraDelegate>
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) GPUImageVideoCamera *camera;
@property (nonatomic, strong) DHImageFaceThinningFilter *faceThinningFilter;
@property (nonatomic, strong) DHImageEyesMagnifyFilter *eyesFilter;
@property (weak, nonatomic) IBOutlet UISlider *eyesSlider;
@property (weak, nonatomic) IBOutlet UISlider *faceSlider;

@end

@implementation RealTimeFaceRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.faceSlider.minimumValue = 0;
    self.faceSlider.maximumValue = 0.3;
    self.eyesSlider.minimumValue = 0;
    self.eyesSlider.maximumValue = 1.f;
    
    
    self.camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    self.camera.videoCaptureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    _camera.horizontallyMirrorFrontFacingCamera = YES;
    self.camera.delegate = self;
   
    self.eyesFilter = [[DHImageEyesMagnifyFilter alloc] init];
    self.eyesFilter.scaleRatio = 0;
    self.eyesFilter.radius = 0.2;
    self.eyesFilter.aspectRatio = self.renderTarget.frame.size.width / self.renderTarget.frame.size.height;

    self.faceThinningFilter = [[DHImageFaceThinningFilter alloc] init];
    self.faceThinningFilter.arraySize = 5;
    self.faceThinningFilter.aspectRatio = self.renderTarget.frame.size.width / self.renderTarget.frame.size.height;
    self.faceThinningFilter.radius = 0.05;
    self.faceThinningFilter.deltas = @[@(0.8), @(0.8), @(0.5), @(0.5), @(0.7)];
    [self.eyesFilter addTarget:self.faceThinningFilter];
    [self.faceThinningFilter addTarget:self.renderTarget];
    
    [self.camera addTarget:self.eyesFilter];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.camera startCameraCapture];
}

- (void) willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        [GPUImageContext useImageProcessingContext];
        runSynchronouslyOnVideoProcessingQueue(^{
            VNSequenceRequestHandler *requestHandler = [[VNSequenceRequestHandler alloc] init];
            VNDetectFaceLandmarksRequest *request = [[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
                for (VNFaceObservation *observation in request.results) {
                    VNFaceLandmarks2D *landmarks = observation.landmarks;
                    
                    CGPoint leftEye = [self leftPupilPositionForLandMark:landmarks
                                           observation:observation];
                    
                    self.eyesFilter.leftEyeCenterPosition = leftEye;
                    CGPoint rightEye = [self rightPupilPositionForLandMark:landmarks observation:observation];
                    self.eyesFilter.rightEyeCenterPosition = rightEye;
                    
                    VNFaceLandmarkRegion2D *faceContour = landmarks.faceContour;
                    NSMutableArray *leftPoints = [NSMutableArray array];
                    NSMutableArray *rightPoints = [NSMutableArray array];
                    for (int i = 0; i < faceContour.pointCount; i++) {
                        CGPoint point = [self _normalizedPointInImageWithNormalizedPoint:faceContour.normalizedPoints[i] boundingBox:observation.boundingBox imageSize:self.renderTarget.bounds.size];
                        if (i < faceContour.pointCount / 2) {
                            [leftPoints addObject:@(point.x)];
                            [leftPoints addObject:@(point.y)];
                        } else {
                            NSInteger rightStart = faceContour.pointCount / 2;
                            if (faceContour.pointCount % 2 == 1) {
                                rightStart = faceContour.pointCount / 2 + 1;
                            }
                            if (i >= rightStart) {
                                [rightPoints insertObject:@(point.y) atIndex:0];
                                [rightPoints insertObject:@(point.x) atIndex:0];
                            }
                        }
                    }
                    
                    self.faceThinningFilter.leftContourPoints = leftPoints;
                    self.faceThinningFilter.rightContourPoints = rightPoints;
                }
                
            }];
            [requestHandler performRequests:@[request] onCVPixelBuffer:pixelBuffer error:NULL];
        });
    
}

- (CGPoint) leftPupilPositionForLandMark:(VNFaceLandmarks2D *)landmarks
                             observation:(VNFaceObservation *)observation
{
    VNFaceLandmarkRegion2D *leftPupil = landmarks.leftPupil;
    CGPoint leftPupilPosition = [self _normalizedPointInImageWithNormalizedPoint:leftPupil.normalizedPoints[0] boundingBox:observation.boundingBox imageSize:self.renderTarget.frame.size];
    return leftPupilPosition;
}

- (CGPoint) rightPupilPositionForLandMark:(VNFaceLandmarks2D *)landmarks
                             observation:(VNFaceObservation *)observation
{
    VNFaceLandmarkRegion2D *leftPupil = landmarks.rightPupil;
    CGPoint leftPupilPosition = [self _normalizedPointInImageWithNormalizedPoint:leftPupil.normalizedPoints[0] boundingBox:observation.boundingBox imageSize:self.renderTarget.frame.size];
    return leftPupilPosition;
}

- (CGPoint) _pointInImageWithNormalizedPoint:(CGPoint)point
                                 boundingBox:(CGRect)boundingBox
                                   imageSize:(CGSize)imageSize
{
    CGFloat rectWidth = imageSize.width * boundingBox.size.width;
    CGFloat rectHeight = imageSize.height * boundingBox.size.height;
    CGPoint p = CGPointMake(point.x * rectWidth + boundingBox.origin.x * imageSize.width, imageSize.height - (boundingBox.origin.y * imageSize.height +  point.y * rectHeight));
    return p;
}

- (CGPoint) _normalizedPointInImageWithNormalizedPoint:(CGPoint)point
                                           boundingBox:(CGRect)boundingBox
                                             imageSize:(CGSize)imageSize
{
    CGPoint p = [self _pointInImageWithNormalizedPoint:point boundingBox:boundingBox imageSize:imageSize];
    return CGPointMake(p.x / imageSize.width, p.y / imageSize.height);
}

- (IBAction)eyesValueChanged:(id)sender {
    self.eyesFilter.scaleRatio = self.eyesSlider.value;
}

- (IBAction)faceValueChanged:(id)sender {
    self.faceThinningFilter.radius = self.faceSlider.value;
}

@end
