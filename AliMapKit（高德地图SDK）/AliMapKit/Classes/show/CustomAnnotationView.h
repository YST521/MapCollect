//
//  CustomAnnotationView.h
//  AliMapKit
//
//  Created by youxin on 2017/8/15.
//  Copyright © 2017年 优信无限. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "ZSPointAnnotation.h"

@interface CustomAnnotationView : MAAnnotationView

@property(nonatomic,strong)UIImageView *portraitImageView;
  @property (nonatomic,strong) UILabel *label;
@end
