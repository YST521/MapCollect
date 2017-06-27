//
//  AppDelegate.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapAppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AliMapAppDelegate ()

@end

@implementation AliMapAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //注册AliMap
    [AMapServices sharedServices].apiKey = AliMap_Appkey;
//    [AMapServices sharedServices].apiKey = @"1e9a8d260e0704eeba940ce3f29863f2";
    
    return YES;
}


@end
