//
//  AppDelegate.m
//  MyPosition
//
//  Created by apple4 on 16/7/20.
//  Copyright © 2016年 apple4. All rights reserved.
//

#import "AppDelegate.h"
#import "MyPositionViewController.h"
#import "IIWrapController.h"
#import "IIViewDeckController.h"
#import "BoatListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc]init];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.bounds = [[UIScreen mainScreen]bounds];
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[MyPositionViewController alloc]init]];
//    [self.window makeKeyAndVisible];
    
    //start 2016/07/22
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    MyPositionViewController* main = [[MyPositionViewController alloc] initWithNibName:@"MyPositionViewController" bundle:nil];
    
    BoatListViewController* right = [[BoatListViewController alloc] initWithNibName:@"BoatListViewController" bundle:nil];
    
    //RightViewController* right = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    
     _deckViewController = [[IIViewDeckController alloc] initWithCenterViewController:main rightViewController:right];
    
    _deckViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sidebar"] style:UIBarButtonItemStyleDone target:self action:@selector(toLeft)];
    
    
   // deckView.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    _deckViewController.delegateMode = IIViewDeckDelegateOnly;
    self.deckViewController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:_deckViewController];
    
    [self.window makeKeyAndVisible];
    //end
    
   return YES;
}
- (void)toLeft {
    //直接打开左侧页面
    [self.deckViewController toggleRightViewAnimated:YES];
    self.deckViewController.rightSize = self.window.frame.size.width - (200);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
