//
//  DHImageFaceLandmarkMask.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/11/9.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageFaceLandmarkMask.h"
#import <GPUImage/GPUImage.h>
#import <Vision/Vision.h>

@interface DHImageFaceLandmarkMask() {
    dispatch_semaphore_t imageUpdateSemaphore;
    CGSize pixelSizeOfImage;
    
    CGPoint _leftPupilPosition;
    CGPoint _rightPupilPosition;
    
    NSArray *_leftFaceContourPoints;
    NSArray *_rightFaceContourPoints;
}
@end

@implementation DHImageFaceLandmarkMask


- (instancetype) initWithImage:(UIImage *)image
                  faceFeatures:(DHImageFaceFeature)features
{
    self = [super init];
    if (self) {
        CGSize pixelSizeToUseForTexture = image.size;
        pixelSizeOfImage = image.size;
        imageUpdateSemaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(imageUpdateSemaphore);
        runSynchronouslyOnVideoProcessingQueue(^{
            [GPUImageContext useImageProcessingContext];
            
            [self generateStrengthMapForImage:image
                                  forFeatures:features
                                   completion:^(char *data) {
                outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:pixelSizeToUseForTexture onlyTexture:YES];
                [outputFramebuffer disableReferenceCounting];
                glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
                
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)pixelSizeToUseForTexture.width, (int)pixelSizeToUseForTexture.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
                glBindTexture(GL_TEXTURE_2D, 0);
                
                free(data);
            }];
        });
    }
    return self;
}

- (void) generateStrengthMapForImage:(UIImage *)image
                         forFeatures:(DHImageFaceFeature)features
                          completion:(void (^)(char *data))completion
{
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage options:@{}];
    
    VNDetectFaceLandmarksRequest *request = [[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        NSMutableArray *paths = [NSMutableArray array];
        for (VNFaceObservation *observation in request.results) {
            [paths addObjectsFromArray:[self _featurePathsForObservation:observation features:features imageSize:image.size]];
        }
        char *data = [self _generateStrenthMapWithImage:image
                                                    scale:[UIScreen mainScreen].scale
                                                    paths:paths];
        if (completion) {
            completion(data);
        }
    }];
    [detectRequestHandler performRequests:@[request] error:NULL];
}

- (NSArray *) _featurePathsForObservation:(VNFaceObservation *)observation
                                 features:(DHImageFaceFeature)feature
                                imageSize:(CGSize)imageSize
{
    NSMutableArray *paths = [NSMutableArray array];
    VNFaceLandmarks2D *landmarks = observation.landmarks;
    if (feature & DHImageFaceFeatureLeftEye) {
        VNFaceLandmarkRegion2D *region = landmarks.leftEye;
        UIBezierPath *path = [self _pathForRegion:region
                                      boundintBox:observation.boundingBox
                                        imageSize:imageSize];
        [paths addObject:path];
    }
    if (feature & DHImageFaceFeatureRightEye) {
        VNFaceLandmarkRegion2D *region = landmarks.rightEye;
        UIBezierPath *path = [self _pathForRegion:region
                                      boundintBox:observation.boundingBox
                                        imageSize:imageSize];
        [paths addObject:path];
    }
    if (feature & DHImageFaceFeatureLip) {
        VNFaceLandmarkRegion2D *region = landmarks.outerLips;
        UIBezierPath *path = [self _pathForRegion:region
                                      boundintBox:observation.boundingBox
                                        imageSize:imageSize];
        UIBezierPath *innerLip = [self _pathForRegion:landmarks.innerLips
                                          boundintBox:observation.boundingBox
                                            imageSize:imageSize];
        [path appendPath:innerLip];
        [path setUsesEvenOddFillRule:YES];
        [paths addObject:path];
    }
    if (feature & DHImageFaceFeatureTeeth) {
        VNFaceLandmarkRegion2D *region = landmarks.innerLips;
        UIBezierPath *path = [self _pathForRegion:region
                                      boundintBox:observation.boundingBox
                                        imageSize:imageSize];
        [paths addObject:path];
    }
    VNFaceLandmarkRegion2D *leftPupil = landmarks.leftPupil;
    _leftPupilPosition = [self _normalizedPointInImageWithNormalizedPoint:leftPupil.normalizedPoints[0] boundingBox:observation.boundingBox imageSize:imageSize];
    
    VNFaceLandmarkRegion2D *rightPupil = landmarks.rightPupil;
    _rightPupilPosition = [self _normalizedPointInImageWithNormalizedPoint:rightPupil.normalizedPoints[0] boundingBox:observation.boundingBox imageSize:imageSize];
    
    VNFaceLandmarkRegion2D *faceContour = landmarks.faceContour;
    NSMutableArray *leftPoints = [NSMutableArray array];
    NSMutableArray *rightPoints = [NSMutableArray array];
    for (int i = 0; i < faceContour.pointCount; i++) {
        CGPoint point = [self _normalizedPointInImageWithNormalizedPoint:faceContour.normalizedPoints[i] boundingBox:observation.boundingBox imageSize:imageSize];
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
    NSLog(@"left points = %@", leftPoints);
    NSLog(@"right points = %@", rightPoints);
    _leftFaceContourPoints = leftPoints;
    _rightFaceContourPoints = rightPoints;
    
    return paths;
}

- (UIBezierPath *) _pathForRegion:(VNFaceLandmarkRegion2D *)region
                      boundintBox:(CGRect)boundingBox
                        imageSize:(CGSize)imageSize
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < region.pointCount; i++) {
        CGPoint point = [region normalizedPoints][i];
        CGPoint p = [self _pointInImageWithNormalizedPoint:point boundingBox:boundingBox imageSize:imageSize];
        if (i == 0) {
            [path moveToPoint:p];
        } else {
            [path addLineToPoint:p];
            if (i == region.pointCount - 1) {
                [path closePath];
            }
        }
    }
    return path;
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

- (char *) _generateStrenthMapWithImage:(UIImage *)image
                                     scale:(CGFloat)scale
                                     paths:(NSArray *)paths
{
    CGSize size = image.size;
    char *data = malloc(4 * size.width * size.height * sizeof(char));
    CGContextRef context = CGBitmapContextCreate(data, size.width, size.height, 8, 4 * size.width, CGImageGetColorSpace(image.CGImage), kCGImageAlphaPremultipliedLast);
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    for (int j = 0; j < size.height; j++) {
        for (int i = 0; i < size.width; i++) {
            CGPoint point = CGPointMake(j, i);
            for (UIBezierPath *path in paths) {
                if ([path containsPoint:point]) {
                    data[(i * (int)size.width + j) * 4] = (char)255;
                    data[(i * (int)size.width + j) * 4 + 1] = (char)255;
                    data[(i * (int)size.width + j) * 4 + 2] = (char)255;
                    data[(i * (int)size.width + j) * 4 + 3] = 1;
                }
            }
        }
    }
    
    return data;
    
}

- (void) generateMask
{
    [self generateMaskWithCompletion:nil];
}

- (BOOL)generateMaskWithCompletion:(void (^)(void))completion
{
    if (dispatch_semaphore_wait(imageUpdateSemaphore, DISPATCH_TIME_NOW) != 0)
    {
        return NO;
    }
    
    runAsynchronouslyOnVideoProcessingQueue(^{
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setCurrentlyReceivingMonochromeInput:NO];
            [currentTarget setInputSize:pixelSizeOfImage atIndex:textureIndexOfTarget];
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
            [currentTarget newFrameReadyAtTime:kCMTimeIndefinite atIndex:textureIndexOfTarget];
        }
        
        dispatch_semaphore_signal(imageUpdateSemaphore);
        
        if (completion != nil) {
            completion();
        }
    });
    
    return YES;
}

- (CGPoint) leftPupilPosition
{
    return _leftPupilPosition;
}

- (CGPoint) rightPupilPosition
{
    return _rightPupilPosition;
}

- (NSArray *) leftContourPoints
{
    return _leftFaceContourPoints;
}

- (NSArray *) rightContourPoints
{
    return _rightFaceContourPoints;
}
@end
