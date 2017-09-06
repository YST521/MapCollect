//
//  MMLocationManager.h
//  DemoBackgroundLocationUpdate
//
//  Created by 毕小强 on 17/1/11.
//  Copyright © 2017年 毕小强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MMLocationManager : CLLocationManager<CLLocationManagerDelegate>
+(instancetype)sharedManager;

@property (nonatomic,assign) CGFloat minSpeed;          //最小速度
@property (nonatomic,assign) CGFloat minFilter;         //最小范围
@property (nonatomic,assign) CGFloat minInteval;        //更新间隔
@end
