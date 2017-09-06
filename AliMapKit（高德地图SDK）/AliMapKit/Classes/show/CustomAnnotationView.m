//
//  CustomAnnotationView.m
//  AliMapKit
//
//  Created by youxin on 2017/8/15.
//  Copyright © 2017年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CustomAnnotationView.h"


@implementation CustomAnnotationView


//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//       
//        [self creatUI];
//    }
//    return  self;
//}
//-(void)creatUI{
//    
//    self.portraitImageView =[[UIImageView alloc]init];
//    self.portraitImageView.frame = CGRectMake(0, 0, 50, 50);
//    self.portraitImageView.backgroundColor =[UIColor redColor];
//    [self addSubview:self.portraitImageView];
//}
- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        在大头针旁边加一个label
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, -15, 50, 20)];
        self.label.textColor = [UIColor redColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.label];
        
    }
    return self;
    
}


@end
