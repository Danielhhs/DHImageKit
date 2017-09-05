//
//  ViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import "DHComponentFilterPickerCollectionViewController.h"
#import <DHImageKit/DHImageKit.h>
#import "DHSliderInputPanel.h"
#import "DHColorPickerCollectionViewController.h"
#import "DHIFFilterPickerCollectionViewController.h"
#import "DHFilterPickerCollectionViewController.h"
#import "DHTiltTypeChoosePanel.h"
#import "TakePictureViewController.h"

@interface ViewController ()<DHComponentFilterPickerCollectionViewControllerDelegate, DHSliderInputPanelDelegate, DHColorPickerCollectionViewControllerDelegate, DHTiltTypeChoosePanelDelegate,DHIFFilterPickerCollectionViewControllerDelegate, DHFilterPickerCollectionViewControllerDelegate, TakePictureViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet GPUImageView *renderTarget;
@property (nonatomic, strong) DHComponentFilterPickerCollectionViewController *editorPicker;
@property (nonatomic, strong) DHIFFilterPickerCollectionViewController *filterPicker;
@property (nonatomic, strong) DHFilterPickerCollectionViewController *dhFilterPicker;

@property (nonatomic, weak) UIViewController *currentViewController;

@property (nonatomic, weak) UIView *editPanel;
@property (nonatomic, strong) DHColorPickerCollectionViewController *colorPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filterPicker = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHIFFilterPickerCollectionViewController"];
    self.filterPicker.delegate = self;
    
    self.editorPicker = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHComponentFilterPickerCollectionViewController"];
    self.editorPicker.delegate = self;
    
    self.dhFilterPicker = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"DHFilterPickerCollectionViewController"];
    self.dhFilterPicker.delegate = self;
    
    [self showFilters:nil];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.renderTarget addGestureRecognizer:pan];
    
    [self changeToKuru:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[DHImageEditor sharedEditor] showOriginalImage];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.editorPicker.view.frame = self.containerView.bounds;
    self.filterPicker.view.frame = self.containerView.bounds;
}

#pragma mark - DHComponentFilterPickerCollectionViewControllerDelegate
- (void) compoenentFilterPicker:(DHComponentFilterPickerCollectionViewController *)picker didPickComponentType:(DHImageEditComponent)component
{
    [[DHImageEditor sharedEditor] startProcessingComponent:component];
    [self showValueInputPanelForComponent:component];
}

- (void) showValueInputPanelForComponent:(DHImageEditComponent)component
{
    if (component == DHImageEditComponentColor) {
        self.colorPicker = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHColorPickerCollectionViewController"];
        self.colorPicker.delegate = self;
        self.colorPicker.view.alpha = 0.01;
        [self addChildViewController:self.colorPicker toParentViewController:self inContainerView:self.containerView];
        self.colorPicker.view.frame = self.containerView.bounds;
        [UIView animateWithDuration:0.2 animations:^{
            self.colorPicker.view.alpha = 1.f;
            self.editorPicker.view.alpha = 0.01;
        }];
    } else if (component == DHImageEditComponentTiltShift){
        DHTiltTypeChoosePanel *typeChoosingPanel = [[DHTiltTypeChoosePanel alloc] initWithFrame:self.containerView.bounds];
        self.editPanel = typeChoosingPanel;
        typeChoosingPanel.delegate = self;
        [self.containerView addSubview:typeChoosingPanel];
        [UIView animateWithDuration:0.2 animations:^{
            typeChoosingPanel.alpha = 1.f;
            self.editorPicker.view.alpha = 0.01;
        }];
    }else {
        DHImageEditorValues values = [DHImageHelper valuesforComponent:component];
        DHSliderInputPanel *inputPanel = [[DHSliderInputPanel alloc] initWithFrame:self.containerView.bounds];
        inputPanel.delegate = self;
        inputPanel.alpha = 0.01;
        [inputPanel setMinValue:values.minValue];
        [inputPanel setMaxValue:values.maxValue];
        NSDictionary *initialParameters = [[DHImageEditor sharedEditor] initialParameters];
        CGFloat inputValue = [[[initialParameters allValues] lastObject] doubleValue];
        [inputPanel setInitialValue:inputValue];
        NSLog(@"----------inputValue = %g", inputValue);
        self.editPanel = inputPanel;
        [self.containerView addSubview:inputPanel];
        [UIView animateWithDuration:0.2 animations:^{
            inputPanel.alpha = 1.f;
            self.editorPicker.view.alpha = 0.01;
        }];
    }
}

- (void) hideValieInputPanel
{
    [UIView animateWithDuration:0.2 animations:^{
        self.editPanel.alpha = 0.01;
        self.currentViewController.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        [self.editPanel removeFromSuperview];
    }];
}

#pragma mark - Event handling
- (void) handlePan:(UIPanGestureRecognizer *)pan
{
    CGFloat center = [pan locationInView:self.renderTarget].y / self.renderTarget.frame.size.height;
    if (pan.state == UIGestureRecognizerStateBegan) {
        [[DHImageEditor sharedEditor] startLinearTiltShiftInputWithValue:center];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [[DHImageEditor sharedEditor] updateWithInput:center];
    } else {
        [[DHImageEditor sharedEditor] finishLinearTiltShiftInputWithValue:center];
    }
}

#pragma mark - DHSliderInputPanelDelegate
- (void) inputPanelDidCancel
{
    if (self.colorPicker) {
        [[DHImageEditor sharedEditor] restoreIntermediateState];
        [UIView animateWithDuration:0.2 animations:^{
            self.colorPicker.view.alpha = 1.f;
            self.editPanel.alpha = 0.01;
        }];
    } else {
        [[DHImageEditor sharedEditor] cancelProcessingCurrentComponent];
        [self hideValieInputPanel];
    }
}

- (void) inputPanelDidComplete
{
    if (self.colorPicker) {
        [[DHImageEditor sharedEditor] saveInterMediateState];
        [UIView animateWithDuration:0.2 animations:^{
            self.colorPicker.view.alpha = 1.f;
            self.editPanel.alpha = 0.01;
        }];
    }  else {
        [self hideValieInputPanel];
    }
}

- (void) inputPanel:(DHSliderInputPanel *)panel didChangeValue:(CGFloat)value
{
    if ([self.currentViewController isEqual:self.dhFilterPicker]) {
        [[DHImageEditor sharedEditor] updateDHFilterWithStrength:value];
    } else {
        [[DHImageEditor sharedEditor] updateWithInput:value];
    }
}

- (void) tiltTypePickerDidPickRadial
{
    [[DHImageEditor sharedEditor] startProcessingComponent:DHImageEditComponentTiltShift subComponent:DHTiltShiftSubTypeRadial];
}

- (void) tiltTypePickerDidPickLinear
{
    [[DHImageEditor sharedEditor] startProcessingComponent:DHImageEditComponentTiltShift subComponent:DHTiltShiftSubTypeLinear];
}

#pragma mark - DHColorPickerCollectionViewController
- (void) colorPickerDidFinish
{
    [[DHImageEditor sharedEditor] finishProcessingCurrentComponent];
    [self hideColorPicker];
}

- (void) colorPickerDidCancel
{
    [[DHImageEditor sharedEditor] cancelProcessingCurrentComponent];
    [self hideColorPicker];
}

- (void) colorPickerDidPickColor:(UIColor *)color
{
    [[DHImageEditor sharedEditor] updateWithColor:color];
    DHImageEditorValues values = [DHImageHelper valuesforComponent:DHImageEditComponentColor];
    DHSliderInputPanel *inputPanel = [[DHSliderInputPanel alloc] initWithFrame:self.containerView.bounds];
    inputPanel.delegate = self;
    inputPanel.alpha = 0.01;
    [inputPanel setMinValue:values.minValue];
    [inputPanel setMaxValue:values.maxValue];
    NSDictionary *initialParameters = [[DHImageEditor sharedEditor] initialParameters];
    CGFloat inputValue = [[[initialParameters allValues] lastObject] doubleValue];
    [inputPanel setInitialValue:inputValue];
    NSLog(@"----------inputValue = %g", inputValue);
    self.editPanel = inputPanel;
    [self.containerView addSubview:inputPanel];
    [UIView animateWithDuration:0.2 animations:^{
        inputPanel.alpha = 1.f;
        self.colorPicker.view.alpha = 0.01;
    }];
}

- (IBAction)showFilters:(id)sender {
    if ([self.currentViewController isEqual:self.filterPicker]) {
        return;
    }
    if (sender == nil) {
        [self addChildViewController:self.filterPicker toParentViewController:self inContainerView:self.containerView];
        self.currentViewController = self.filterPicker;
    } else {
        self.filterPicker.view.alpha = 0.01;
        [self addChildViewController:self.filterPicker toParentViewController:self inContainerView:self.containerView];
        [UIView animateWithDuration:0.2 animations:^{
            self.filterPicker.view.alpha = 1.f;
            self.currentViewController.view.alpha = 0.01f;
        } completion:^(BOOL finished) {
            [self removeChildViewController:self.currentViewController fromParentViewController:self];
            self.currentViewController = self.filterPicker;
        }];
        
    }
}

- (IBAction)showEdit:(id)sender {
    if ([self.currentViewController isEqual:self.editorPicker]) {
        return;
    }
    self.editorPicker.view.alpha = 0.01;
    [self addChildViewController:self.editorPicker toParentViewController:self inContainerView:self.containerView];
    [UIView animateWithDuration:0.2 animations:^{
        self.editorPicker.view.alpha = 1.f;
        self.currentViewController.view.alpha = 0.01f;
    } completion:^(BOOL finished) {
        [self removeChildViewController:self.currentViewController fromParentViewController:self];
        self.currentViewController = self.editorPicker;
    }];
}

- (IBAction)showDHFilters:(id)sender {
    if ([self.currentViewController isEqual:self.dhFilterPicker]) {
        return;
    }
    self.dhFilterPicker.view.alpha = 0.01;
    [self addChildViewController:self.dhFilterPicker toParentViewController:self inContainerView:self.containerView];
    [UIView animateWithDuration:0.2 animations:^{
        self.dhFilterPicker.view.alpha = 1.f;
        self.currentViewController.view.alpha = 0.01f;
    } completion:^(BOOL finished) {
        [self removeChildViewController:self.currentViewController fromParentViewController:self];
        self.currentViewController = self.dhFilterPicker;
    }];
}
#pragma mark - DHIFFilterPickerCollectionViewControllerDelegate
- (void) filterPickerDidPickFilter:(IFImageFilter *)filter
{
    [[DHImageEditor sharedEditor] startProcessingWithFilter:filter];
}

- (void) DHFilterPickerDidPickFilter:(DHImageFilter *)filter
{
    [[DHImageEditor sharedEditor] startProcessingWithDHFilter:filter];
    DHSliderInputPanel *inputPanel = [[DHSliderInputPanel alloc] initWithFrame:self.containerView.bounds];
    inputPanel.backgroundColor = [UIColor whiteColor];
    inputPanel.delegate = self;
    inputPanel.alpha = 0.01;
    [inputPanel setMinValue:0];
    [inputPanel setMaxValue:1];
    [inputPanel setInitialValue:1];
    self.editPanel = inputPanel;
    [self.containerView addSubview:inputPanel];
    [UIView animateWithDuration:0.2 animations:^{
        inputPanel.alpha = 1.f;
        self.dhFilterPicker.view.alpha = 0.01;
    }];
}
#pragma mark - Helper
- (void) addChildViewController:(UIViewController *)viewController
         toParentViewController:(UIViewController *)parentViewController
                inContainerView:(UIView *)containerView
{
    [parentViewController addChildViewController:viewController];
    [containerView addSubview:viewController.view];
    viewController.view.frame = containerView.bounds;
    [viewController didMoveToParentViewController:parentViewController];
}

- (void) removeChildViewController:(UIViewController *)viewController
          fromParentViewController:(UIViewController *)parentViewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void) hideColorPicker
{
    [UIView animateWithDuration:0.2 animations:^{
        self.colorPicker.view.alpha = 0.01;
        self.editorPicker.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        [self removeChildViewController:self.colorPicker fromParentViewController:self];
        self.colorPicker = nil;
    }];
}

- (IBAction)changeToKriss:(id)sender {
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"portrait" ofType:@"jpg"];
    
    [[DHImageEditor sharedEditor] initiateEditorWithImageURL:[NSURL fileURLWithPath:filePath] renderTarget:self.renderTarget completion:nil];
}

- (IBAction)changeToKuru:(id)sender {
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample_kuru" ofType:@"jpg"];
    
    [[DHImageEditor sharedEditor] initiateEditorWithImageURL:[NSURL fileURLWithPath:filePath] renderTarget:self.renderTarget completion:nil];
}
- (IBAction)changeToScene:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"scene" ofType:@"jpg"];
    
    [[DHImageEditor sharedEditor] initiateEditorWithImageURL:[NSURL fileURLWithPath:filePath] renderTarget:self.renderTarget completion:nil];
}

- (IBAction)takeAPicture:(id)sender {
    TakePictureViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TakePictureViewController"];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) didTakePicture:(UIImage *)picture
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
    path = [path stringByAppendingPathComponent:fileName];
    
    [UIImagePNGRepresentation(picture) writeToFile:path atomically:YES];
    [[DHImageEditor sharedEditor] initiateEditorWithImageURL:[NSURL fileURLWithPath:path] renderTarget:self.renderTarget completion:nil];
    
}

@end
