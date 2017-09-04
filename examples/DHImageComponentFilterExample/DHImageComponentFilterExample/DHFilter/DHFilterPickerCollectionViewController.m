//
//  DHFilterPickerCollectionViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/8/28.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "DHFilterPickerCollectionViewController.h"
#import "DHImageFiltersHelper.h"
#import "DHIFFilterCollectionViewCell.h"

@interface DHFilterPickerCollectionViewController ()

@property (nonatomic, strong) NSArray *filters;
@end

@implementation DHFilterPickerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filters = [DHImageFiltersHelper availableFilters];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        DHIFFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    DHImageFilterInfo *info = [self.filters objectAtIndex:indexPath.row];
        [cell setText:info.filterName];
        
        return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DHImageFilter *filter = [DHImageFiltersHelper filterForFilterInfo:self.filters[indexPath.row]];
    [self.delegate DHFilterPickerDidPickFilter:filter];
}
@end
