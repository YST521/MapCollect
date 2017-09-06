//
//  CustomAnnotationView.h
//  AliMapKit
//
//  Created by youxin on 2017/8/15.
//  Copyright © 2017年 广州市东德网络科技有限公司. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "ZSPointAnnotation.h"

@interface CustomAnnotationView : MAAnnotationView

@property(nonatomic,strong)UIImageView *portraitImageView;
  @property (nonatomic,strong) UILabel *label;
@end
