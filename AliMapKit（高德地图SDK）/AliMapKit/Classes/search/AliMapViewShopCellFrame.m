//
//  AliMapViewShopCellFrame.m
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
//  显示商店内容cell的布局

#import "AliMapViewShopCellFrame.h"

@implementation AliMapViewShopCellFrame

//接收商户模型,同时设置frame
-(void)setShopModel:(AliMapViewShopModel *)shopModel{
    
    _shopModel = shopModel;
    
    //商店名称LabelFrame
    _shopNameLabelFrame = CGRectMake(Cell_Border, Cell_Border, SCREEN_WIDTH-2*Cell_Border, 30);

    //商店类型LabelFrame
    _shopTypeLabelFrame = CGRectMake(Cell_Border, CGRectGetMaxY(_shopNameLabelFrame)+Cell_Border/2, (SCREEN_WIDTH-2*Cell_Border)/2+2*Cell_Border, 30);
    
    //商店评分LabelFrame
    _shopRatingLabelFrame = CGRectMake(CGRectGetMaxX(_shopTypeLabelFrame), CGRectGetMaxY(_shopNameLabelFrame)+Cell_Border/2, (SCREEN_WIDTH-2*Cell_Border)/2-2*Cell_Border, 30);
    
    //商店电话LabelFrame
    _shopTelLabelFrame = CGRectMake(Cell_Border, CGRectGetMaxY(_shopRatingLabelFrame)+Cell_Border/2, (SCREEN_WIDTH-2*Cell_Border)/2+2*Cell_Border, 30);
    
    //商店地址LabelFrame
    _shopAddressLabelFrame  = CGRectMake(CGRectGetMaxX(_shopTelLabelFrame), CGRectGetMaxY(_shopRatingLabelFrame)+Cell_Border/2, (SCREEN_WIDTH-2*Cell_Border)/2-2*Cell_Border, 30);
    
    //商店图片ViewFrame
    _shopImageViewFrame = CGRectMake(Cell_Border, CGRectGetMaxY(_shopAddressLabelFrame)+Cell_Border/2, SCREEN_WIDTH-2*Cell_Border, 80);
    
    //cell的高
    _cellHeight = CGRectGetMaxY(_shopImageViewFrame)+Cell_Border;
}

@end
