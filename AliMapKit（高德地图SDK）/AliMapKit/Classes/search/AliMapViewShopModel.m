//
//  AliMapViewShopModel.m
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
//  商店模型

#import "AliMapViewShopModel.h"

@implementation AliMapViewShopModel

-(instancetype)initWithAMapPOI:(AMapPOI *)shopPOI{
    
    AliMapViewShopModel *shopModel = [[AliMapViewShopModel alloc] init];
    shopModel.shopName = shopPOI.name;
    shopModel.shopType = shopPOI.type;
    shopModel.shopTel  = shopPOI.tel;
    shopModel.shopRating = [NSString stringWithFormat:@"%.1lf",shopPOI.extensionInfo.rating==0?arc4random_uniform(5.0):shopPOI.extensionInfo.rating];
    shopModel.shopAddress = shopPOI.address;
    shopModel.shopImages = shopPOI.images;
    return shopModel;
}

@end
