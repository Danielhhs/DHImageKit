//
//  DHColorPickerCollectionViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/31.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHColorPickerCollectionViewController.h"

@interface DHColorPickerCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *colors;
@end

@implementation DHColorPickerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateColors];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void) generateColors
{
    _colors = [NSMutableArray array];
    [_colors addObject:[self colorWithHexString:@"97398F"]];
    [_colors addObject:[self colorWithHexString:@"FE4D4D"]];
    [_colors addObject:[self colorWithHexString:@"F48023"]];
    [_colors addObject:[self colorWithHexString:@"FFCD00"]];
    [_colors addObject:[self colorWithHexString:@"81D281"]];
    [_colors addObject:[self colorWithHexString:@"72C5D7"]];
}

- (UIColor *) colorWithHexString: (NSString *)stringToConvert
{
    NSString *string = stringToConvert;
    if ([string hasPrefix:@"#"])
        string = [string substringFromIndex:1];
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum;
    if (![scanner scanHexInt: &hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

- (UIColor *) colorWithRGBHex: (uint32_t)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.colors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = self.colors[indexPath.row];
    
    return cell;
}

- (IBAction)cancel:(id)sender {
    [self.delegate colorPickerDidCancel];
}

- (IBAction)confirm:(id)sender {
    [self.delegate colorPickerDidFinish];
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate colorPickerDidPickColor:self.colors[indexPath.row]];
}
@end
