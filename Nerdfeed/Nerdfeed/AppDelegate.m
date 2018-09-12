//
//  AppDelegate.m
//  Nerdfeed
//
//  Created by macOs on 2018/9/12.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRCourseViewController.h"
#import "BNRWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BNRCourseViewController *cvc = [[BNRCourseViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];
    BNRWebViewController *wvc = [[BNRWebViewController alloc] init];
    cvc.webViewController = wvc;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //必须将视图包含在导航控制器中
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:wvc];
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        svc.delegate = wvc;
        svc.viewControllers = @[masterNav,detailNav];
        self.window.rootViewController = svc;
    } else {
        self.window.rootViewController = masterNav;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
