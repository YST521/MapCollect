//
//  AliMapViewCustomCalloutView.h
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
//  自定义气泡

#import <UIKit/UIKit.h>

@interface AliMapViewCustomCalloutView : UIView
@property (nonatomic, strong)UIImage *image;    //商户图
@property (nonatomic, copy) NSString *title;    //商户名
@property (nonatomic, copy) NSString *subtitle; //商户地址
@end
