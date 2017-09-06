//
//  AliMapViewShopCell.h
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  strongright © 2016年 优信无限. All rights reserved.
//  显示商店内容的cell

#import <UIKit/UIKit.h>
#import "AliMapViewShopImageView.h"

@class AliMapViewShopCellFrame;
@interface AliMapViewShopCell : UITableViewCell

/**
 *  frame模型
 */
@property (strong, nonatomic)AliMapViewShopCellFrame *shopCellFrame;
/**
 *  商店名称Label
 */
@property (strong, nonatomic)UILabel *shopNameLabel;
/**
 *  商店电话Label
 */
@property (strong, nonatomic)UILabel *shopTelLabel;
/**
 *  商店类型Label
 */
@property (strong, nonatomic)UILabel *shopTypeLabel;
/**
 *  商店地址Label
 */
@property (strong, nonatomic)UILabel *shopAddressLabel;
/**
 *  商店评分Label
 */
@property (strong, nonatomic)UILabel *shopRatingLabel;
/**
 *  商店图片View
 */
@property (strong, nonatomic)AliMapViewShopImageView  *shopImageView;


//类方法创建cell
+(instancetype)createCellWithTableView:(UITableView *)tableView;

@end
