//
//  AppDelegate.m
//  AliMapKit
//
//  Created by YST on 17/04/15.
//  Copyright © 2016年 优信无限. All rights reserved.
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
