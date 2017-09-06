//
//  AliMapViewPOISearchController.m
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
//  各种POI检索

#import "AliMapViewPOISearchController.h"
#import "AliMapViewPOISearchByKeywordController.h"
#import "AliMapViewPOISearchByAroundController.h"
#import "AliMapViewPOISearchByPolygonController.h"
#import "AliMapViewPOISearchByIDController.h"
#import "AliMapViewPOISearchByRouteController.h"
#import "AliMapViewSearchByInputTipsController.h"

@interface AliMapViewPOISearchController ()
@property (strong,nonatomic)NSMutableArray *allPOIs;
@end

@implementation AliMapViewPOISearchController

-(NSMutableArray *)allPOIs{
    if (!_allPOIs) {
        _allPOIs = [NSMutableArray arrayWithObjects:
                       @"关键字检索POI",@"周边检索POI",@"多边检索POI",
                       @"ID检索POI",@"道路沿途检索POI",@"输入给出提示语",nil];
    }
    return _allPOIs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allPOIs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allPOIs[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //关键字检索POI
    if (indexPath.row==0) {
        AliMapViewPOISearchByKeywordController *POIByKeywordVC = [[AliMapViewPOISearchByKeywordController alloc] init];
        POIByKeywordVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByKeywordVC animated:YES];
    }
    
    //周边检索POI
    if (indexPath.row==1) {
        AliMapViewPOISearchByAroundController *POIByAroundVC = [[AliMapViewPOISearchByAroundController alloc] init];
        POIByAroundVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByAroundVC animated:YES];
    }
    
    //多边形检索POI
    if (indexPath.row==2) {
        AliMapViewPOISearchByPolygonController *POIByPolygonVC = [[AliMapViewPOISearchByPolygonController alloc] init];
        POIByPolygonVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByPolygonVC animated:YES];
    }
    
    //通过ID检索POI  AliMapViewPOISearchByRouteController
    if (indexPath.row==3) {
        AliMapViewPOISearchByIDController *POIByIDVC = [[AliMapViewPOISearchByIDController alloc] init];
        POIByIDVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByIDVC animated:YES];
    }
    
    //通过道路沿途检索POI #import "AliMapViewSearchByInputTipsController.h"
    if (indexPath.row==4) {
        AliMapViewPOISearchByRouteController *POIByRouteVC = [[AliMapViewPOISearchByRouteController alloc] init];
        POIByRouteVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByRouteVC animated:YES];
    }
    
    //给出输入提示
    if (indexPath.row==5) {
        AliMapViewSearchByInputTipsController *POIByInputVC = [[AliMapViewSearchByInputTipsController alloc] init];
        POIByInputVC.title = self.allPOIs[indexPath.row];
        [self.navigationController pushViewController:POIByInputVC animated:YES];
    }
}


@end
