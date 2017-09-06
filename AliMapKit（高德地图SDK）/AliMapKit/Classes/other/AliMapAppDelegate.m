//
//  AppDelegate.m
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
//

#import "AliMapAppDelegate.h"
#import "MMLocationManager.h"

@interface AliMapAppDelegate ()

@end

@implementation AliMapAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //注册AliMap
    [AMapServices sharedServices].apiKey = AliMap_Appkey;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    [[MMLocationManager sharedManager]requestAlwaysAuthorization];
#endif
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    [[MMLocationManager sharedManager]setAllowsBackgroundLocationUpdates:YES];
#endif
    [[MMLocationManager sharedManager]startMonitoringSignificantLocationChanges];

    
    return YES;
}


@end
