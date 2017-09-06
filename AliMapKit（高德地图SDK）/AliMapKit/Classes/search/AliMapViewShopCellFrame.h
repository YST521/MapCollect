//
//  AliMapViewShopCellFrame.h
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
//  显示商店内容cell的布局

#import <Foundation/Foundation.h>

@class AliMapViewShopModel;

@interface AliMapViewShopCellFrame : NSObject

/**
 *  商店模型
 */
@property (strong,nonatomic)AliMapViewShopModel *shopModel;
/**
 *  商店名称LabelFrame
 */
@property (assign, nonatomic)CGRect shopNameLabelFrame;
/**
 *  商店电话LabelFrame
 */
@property (assign, nonatomic)CGRect shopTelLabelFrame;
/**
 *  商店类型LabelFrame
 */
@property (assign, nonatomic)CGRect shopTypeLabelFrame;
/**
 *  商店地址LabelFrame
 */
@property (assign, nonatomic)CGRect shopAddressLabelFrame;
/**
 *  商店评分LabelFrame
 */
@property (assign, nonatomic)CGRect shopRatingLabelFrame;
/**
 *  商店图片ViewFrame
 */
@property (assign, nonatomic)CGRect  shopImageViewFrame;
/**
 *  cell的高
 */
@property (assign, nonatomic)CGFloat cellHeight;

@end
