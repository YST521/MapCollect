//
//  AppDelegate.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "AliMapAppDelegate.h"

@interface AliMapAppDelegate ()

@end

@implementation AliMapAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //注册AliMap
    [AMapServices sharedServices].apiKey = AliMap_Appkey;
    
    return YES;
}


@end
