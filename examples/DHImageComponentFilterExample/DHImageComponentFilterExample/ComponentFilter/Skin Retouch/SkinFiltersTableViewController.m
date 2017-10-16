//
//  SkinFiltersTableViewController.m
//  DHImageComponentFilterExample
//
//  Created by 黄鸿森 on 2017/10/10.
//  Copyright © 2017年 Huang Hongsen. All rights reserved.
//

#import "SkinFiltersTableViewController.h"
#import <DHImageKit/DHImageKit.h>
#import "DHImageSkinWhitenFilter.h"
#import "DHImageSkinScarRepairFilter.h"
#import "DHImageSkinHealingFilter.h"
#import "DHImageSkinNoiseFilter.h"
#import "DHImageSkinBlackAndWhiteFilter.h"

@interface SkinFiltersTableViewController ()
@property (nonatomic, strong) NSArray *filters;
@end

@implementation SkinFiltersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.filters = @[@"磨平", @"美白", @"磨滑", @"祛疤", @"纹理", @"黑白"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filters count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.filters[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DHImageSkinFilter *filter = nil;
    if (indexPath.row == 0) {
        filter = [[DHImageSkinSmoothFilter alloc] initWithSize:CGSizeMake(750, 750)];
    } else if (indexPath.row == 1) {
        filter = [[DHImageSkinWhitenFilter alloc] initWithSize:CGSizeMake(750, 750)];
    } else if (indexPath.row == 2) {
        filter = [[DHImageSkinScarRepairFilter alloc] initWithSize:CGSizeMake(750, 750)];
    } else if (indexPath.row == 3) {
        filter = [[DHImageSkinHealingFilter alloc] initWithSize:CGSizeMake(750, 750)];
    } else if (indexPath.row == 4) {
        filter = [[DHImageSkinNoiseFilter alloc] initWithSize:CGSizeMake(750, 750)];
    } else if (indexPath.row == 5) {
        filter = [[DHImageSkinBlackAndWhiteFilter alloc] initWithSize:CGSizeMake(750, 750)];
    }
    [self.filterDelegate filterPicker:self didPickFilter:filter];
}
@end
