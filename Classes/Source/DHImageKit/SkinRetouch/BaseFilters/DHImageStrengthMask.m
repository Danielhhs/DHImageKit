//
//  DHImageStrengthMask.m
//  DHImageKit
//
//  Created by 黄鸿森 on 2017/10/7.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHImageStrengthMask.h"
#import <GLKit/GLKit.h>

// Texture
typedef struct {
    GLuint tid;
    GLsizei width, height;
} textureInfo_t;


@interface DHImageStrengthMask() {
    CGPoint lastTouchLocation;
    BOOL firstTouch;
    GLProgram *program;
    CGFloat width, height;
    GLuint vboId;
    dispatch_semaphore_t imageProcessSemaphore;
    GLint positionAttribute;
    GLint pointSizeUniform, vertexColorUniform, samplerUniform, mvpUniform;
    GLuint frameBuffer;
    GLKMatrix4 mvpMatrix;
    textureInfo_t textureInfo;
}
@property (nonatomic) CGFloat contentScaleFactor;
@end

#define kBrushPixelStep 3
NSString * const kDHImageStrengthMaskVertexShaderString =
SHADER_STRING
(
 attribute vec4 inVertex;
 
 uniform mat4 mvpMatrix;
 uniform float pointSize;
 uniform lowp vec4 vertexColor;
 
 varying lowp vec4 color;
 
 void main()
{
    gl_Position = mvpMatrix * inVertex;
    gl_PointSize = pointSize;
    color = vertexColor;
}
 );

NSString * const kDHImageStrengthMaskFragmentShaderString =
SHADER_STRING
(
 uniform sampler2D texture;
 varying lowp vec4 color;
 
 void main()
{
    lowp vec4 textureColor = texture2D(texture, gl_PointCoord);
//    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    gl_FragColor = textureColor * 0.6;
}
);
@implementation DHImageStrengthMask

- (instancetype) initWithWidth:(CGFloat)awidth height:(CGFloat)aheight
{
    self = [super init];
    if (self) {
        width = awidth;
        height = aheight;
        firstTouch = YES;
        _contentScaleFactor = [UIScreen mainScreen].scale;
        inputTextureSize = CGSizeMake(width, height);
        imageProcessSemaphore = dispatch_semaphore_create(0);
        
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, width, 0, height, -1, 1);
        GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
        mvpMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
        
        dispatch_semaphore_signal(imageProcessSemaphore);
        
        runSynchronouslyOnVideoProcessingQueue(^{
            outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];

            program = [[GLProgram alloc] initWithVertexShaderString:kDHImageStrengthMaskVertexShaderString fragmentShaderString:kDHImageStrengthMaskFragmentShaderString];
            
            glGenBuffers(1, &vboId);
            textureInfo = [self textureFromName:@"Particle.png"];
            if (!program.initialized)
            {
                [program addAttribute:@"inVertex"];
                if (![program link])
                {
                    NSString *progLog = [program programLog];
                    NSLog(@"Program link log: %@", progLog);
                    NSString *fragLog = [program fragmentShaderLog];
                    NSLog(@"Fragment shader compile log: %@", fragLog);
                    NSString *vertLog = [program vertexShaderLog];
                    NSLog(@"Vertex shader compile log: %@", vertLog);
                    program = nil;
                    NSAssert(NO, @"Filter shader link failed");
                }
            }
            
            positionAttribute = [program attributeIndex:@"inVertex"];
            pointSizeUniform = [program uniformIndex:@"pointSize"];
            vertexColorUniform = [program uniformIndex:@"vertexColor"];
            samplerUniform = [program uniformIndex:@"texture"];
            mvpUniform = [program uniformIndex:@"mvpMatrix"];
            
            [GPUImageContext setActiveShaderProgram:program];
            glEnableVertexAttribArray(positionAttribute);
        });
    }
    return self;
}

- (void) updateWithTouchLocation:(CGPoint)location completion:(void (^)(void))completion
{
    if (firstTouch) {
        firstTouch = NO;
        lastTouchLocation = location;
        return;
    } else {
        
    }
    if (dispatch_semaphore_wait(imageProcessSemaphore, DISPATCH_TIME_NOW) != 0)
    {
        return ;
    }
    
    runAsynchronouslyOnVideoProcessingQueue(^{
        [self renderLineFromLocation:lastTouchLocation toLocation:location];
        [self informTargetsForFrameReadyWithCompletion:completion];
        lastTouchLocation = location;
    });
}

- (void) finishUpdating
{
    firstTouch = YES;
}

- (void) informTargetsForFrameReadyWithCompletion:(void (^)(void))completion
{
    for (id<GPUImageInput> currentTarget in targets)
    {
        NSInteger indexOfObject = [targets indexOfObject:currentTarget];
        NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
        
        [currentTarget setCurrentlyReceivingMonochromeInput:NO];
        [currentTarget setInputSize:CGSizeMake(width, height) atIndex:textureIndexOfTarget];
        [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
        [currentTarget newFrameReadyAtTime:kCMTimeIndefinite atIndex:textureIndexOfTarget];
    }
    
    dispatch_semaphore_signal(imageProcessSemaphore);
    
    if (completion != nil) {
        completion();
    }
}

- (void) renderLineFromLocation:(CGPoint)start
                     toLocation:(CGPoint)end
{
    static GLfloat*        vertexBuffer = NULL;
    static NSUInteger    vertexMax = 64;
    NSUInteger            vertexCount = 0,
    count,
    i;
    [GPUImageContext setActiveShaderProgram:program];
    [outputFramebuffer activateFramebuffer];
    
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }
    
    // Convert locations from Points to Pixels
    CGFloat scale = self.contentScaleFactor;
    start.x *= scale;
    start.y *= scale;
    end.x *= scale;
    end.y *= scale;
    
    // Allocate vertex array buffer
    if(vertexBuffer == NULL)
        vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
    
    // Add points to the buffer so there are drawing points every X pixels
    count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
    for(i = 0; i < count; ++i) {
        if(vertexCount == vertexMax) {
            vertexMax = 2 * vertexMax;
            vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
        }
        
        vertexBuffer[2 * vertexCount + 0] = (start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count));
        vertexBuffer[2 * vertexCount + 1] = (start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count));
        vertexCount += 1;
    }
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glUniformMatrix4fv(mvpUniform, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(pointSizeUniform, 120);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureInfo.tid);
    glUniform1i(samplerUniform, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, vboId);
    glBufferData(GL_ARRAY_BUFFER, vertexCount*2*sizeof(GLfloat), vertexBuffer, GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(positionAttribute);
    glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    glUniform4f(vertexColorUniform, 1, 1, 1, 1);
    [GPUImageContext setActiveShaderProgram:program];
    // Draw
    glDrawArrays(GL_POINTS, 0, (int)vertexCount);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (CGSize)sizeOfFBO;
{
    CGSize outputSize = [self maximumOutputSize];
    if ( (CGSizeEqualToSize(outputSize, CGSizeZero)) || (inputTextureSize.width < outputSize.width) )
    {
        return inputTextureSize;
    }
    else
    {
        return outputSize;
    }
}

- (CGSize) maximumOutputSize{
    return CGSizeMake(width, height);
}

- (textureInfo_t) textureFromName:(NSString *)textureName
{
    CGImageRef        brushImage;
    CGContextRef    brushContext;
    GLubyte            *brushData;
    size_t            width, height;
    GLuint          texId;
    textureInfo_t   texture;
    
    // First create a UIImage object from the data in a image file, and then extract the Core Graphics image
    brushImage = [UIImage imageNamed:textureName].CGImage;
    
    // Get the width and height of the image
    width = CGImageGetWidth(brushImage);
    height = CGImageGetHeight(brushImage);
    
    // Make sure the image exists
    if(brushImage) {
        // Allocate  memory needed for the bitmap context
        brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
        // Use  the bitmatp creation function provided by the Core Graphics framework.
        brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
        // After you create the context, you can draw the  image to the context.
        CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
        // You don't need the context at this point, so you need to release it to avoid memory leaks.
        CGContextRelease(brushContext);
        // Use OpenGL ES to generate a name for the texture.
        glGenTextures(1, &texId);
        // Bind the texture name.
        glBindTexture(GL_TEXTURE_2D, texId);
        // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        // Specify a 2D texture image, providing the a pointer to the image data in memory
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
        // Release  the image data; it's no longer needed
        free(brushData);
        
        texture.tid = texId;
        texture.width = (int)width;
        texture.height = (int)height;
    } else {
        texture.tid = 0;
        texture.width = 0;
        texture.height = 0;
    }
    
    return texture;
}

- (GLuint) generateOutputTexture
{
    GLuint texture;
    glActiveTexture(GL_TEXTURE1);
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_S);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_TEXTURE_WRAP_T);
    return texture;
}

- (void) initGL
{
    glGenBuffers(1, &frameBuffer);
    glBindBuffer(GL_FRAMEBUFFER, frameBuffer);
    GLuint outputTexture = [self generateOutputTexture];
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, outputTexture, 0);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSAssert(status == GL_FRAMEBUFFER_COMPLETE, @"Incomplete filter FBO: %d", status);
    glBindTexture(GL_TEXTURE_2D, 0);
}
@end
