//
//  DHIFFilterPickerCollectionViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/8/1.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHIFFilterPickerCollectionViewController.h"
#import "DHIFFiltersHelper.h"
#import "DHIFFilterCollectionViewCell.h"
#import "InstaFilters.h"
@interface DHIFFilterPickerCollectionViewController ()
@property (nonatomic, strong) NSArray *filters;
@end

@implementation DHIFFilterPickerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filters = [DHIFFiltersHelper availableFilters];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DHIFFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setText:[self.filters objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IFImageFilter *filter = [DHIFFiltersHelper filterForType:indexPath.row];
    [self.delegate filterPickerDidPickFilter:filter];
}
@end
