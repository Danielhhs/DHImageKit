//
//  DHComponentFilterPickerCollectionViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/7/29.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHComponentFilterPickerCollectionViewController.h"
#import "DHComponentEditFilterCollectionViewCell.h"

@interface DHComponentFilterPickerCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *editOptions;

@end

@implementation DHComponentFilterPickerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateEditorOptions];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.editOptions count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DHComponentEditFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.image = [[self.editOptions[indexPath.row] allValues] lastObject];
    cell.text = [[self.editOptions[indexPath.row] allKeys] lastObject];
    cell.selected = NO;
        
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate compoenentFilterPicker:self didPickComponentType:indexPath.row];
}

- (void) generateEditorOptions
{
    self.editOptions = [NSMutableArray array];
    [self.editOptions addObject:@{@"调整" : [UIImage imageNamed:@"ic_adjustment"]}];
    [self.editOptions addObject:@{@"亮度" : [UIImage imageNamed:@"ic_brightness"]}];
    [self.editOptions addObject:@{@"对比度" : [UIImage imageNamed:@"ic_contrast"]}];
    [self.editOptions addObject:@{@"结构" : [UIImage imageNamed:@"ic_structure"]}];
    [self.editOptions addObject:@{@"暖色调" : [UIImage imageNamed:@"ic_warmth"]}];
    [self.editOptions addObject:@{@"饱和度" : [UIImage imageNamed:@"ic_satuaration"]}];
    [self.editOptions addObject:@{@"颜色" : [UIImage imageNamed:@"ic_color"]}];
    [self.editOptions addObject:@{@"淡化" : [UIImage imageNamed:@"ic_fade"]}];
    [self.editOptions addObject:@{@"高亮" : [UIImage imageNamed:@"ic_highlight"]}];
    [self.editOptions addObject:@{@"光影" : [UIImage imageNamed:@"ic_shadows"]}];
    [self.editOptions addObject:@{@"晕影" : [UIImage imageNamed:@"ic_vignette"]}];
    [self.editOptions addObject:@{@"移轴" : [UIImage imageNamed:@"ic_tilt_shift"]}];
    [self.editOptions addObject:@{@"锐化" : [UIImage imageNamed:@"ic_sharpen"]}];
}



@end
