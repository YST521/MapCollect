//
//  AliMapViewPOISearchByKeywordController.m
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
//  关键字POI检索

#import "AliMapViewPOISearchByKeywordController.h"
#import "AliMapViewShopModel.h"
#import "AliMapViewShopCellFrame.h"
#import "AliMapViewShopCell.h"


/**
 *  讲解一下cell、model、cellFrame的关系
 *
 *  每一个cellFrame拥有一个model模型，cellFrame中根据model内容给所有cell中的子控件布局，也即设置frame
 *  每一个cell再拥有一个cellFrame模型，cell中直接给所有的子控件设置frame，这些frame都是cellFrame中设置好的属性，
 *  同时，cell中也会设置子控件的内容，内容都是cellFrame中model的属性
 *
 */

@interface AliMapViewPOISearchByKeywordController()<AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong)UITableView *tableView;              //表格
@property (nonatomic, strong)NSMutableArray *shopModelCellFrames; //所有的模型
@end

@implementation AliMapViewPOISearchByKeywordController

//懒加载
-(NSMutableArray *)shopModelCellFrames{
    if (!_shopModelCellFrames) {
        _shopModelCellFrames = [NSMutableArray array];
    }
    return _shopModelCellFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:1.0];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    
    //创建POI关键字检索请求
    AMapPOIKeywordsSearchRequest *keyWordSearchRequest = [[AMapPOIKeywordsSearchRequest alloc] init];
    keyWordSearchRequest.keywords = @"酒店";
    keyWordSearchRequest.city = @"北京";
    keyWordSearchRequest.cityLimit = YES;
    keyWordSearchRequest.requireExtension = YES;
    keyWordSearchRequest.requireSubPOIs   = YES;
    
    //发起请求,开始POI关键字检索
    [_POISearchManager AMapPOIKeywordsSearch:keyWordSearchRequest];
    [XYQProgressHUD showMessage:@"正在检索"];
}

#pragma mark - AMapSearchDelegate
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

//收集检索到的目标(默认每一次给出一页数据,可以自己通过上拉刷新设置page的增加)
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    [XYQProgressHUD hideHUD];
    if(response.pois.count == 0)  return;
    [XYQProgressHUD showSuccess:@"检索成功"];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AliMapViewShopCellFrame *cellFrame = [[AliMapViewShopCellFrame alloc] init];
        AliMapViewShopModel *shopModel = [[AliMapViewShopModel alloc] initWithAMapPOI:poi];
        cellFrame.shopModel = shopModel;
        [self.shopModelCellFrames addObject:cellFrame];
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopModelCellFrames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AliMapViewShopCell *cell = [AliMapViewShopCell createCellWithTableView:tableView];
    if (self.shopModelCellFrames.count>0) {
         cell.shopCellFrame = self.shopModelCellFrames[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.shopModelCellFrames.count>0) {
        AliMapViewShopCellFrame *shopCellFrame = self.shopModelCellFrames[indexPath.row];
         return shopCellFrame.cellHeight;
    }
    return 100;
}

@end
