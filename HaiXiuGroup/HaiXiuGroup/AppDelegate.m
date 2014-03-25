//
//  AppDelegate.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-14.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "TopicListViewController.h"
#import "Constants.h"
#import "UIImage+Color.h"
#import "NewTopicsViewController.h"
#import "Constants+Notification.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    TopicListViewController *topicList = [[TopicListViewController alloc] initWithNibName:@"TopicListViewController" bundle:nil];
    
//    NewTopicsViewController *newTopicVC = [[NewTopicsViewController alloc] initWithNibName:@"NewTopicsViewController" bundle:nil];
    
    UINavigationController *postController = [[UINavigationController alloc] init];
    
    [postController.navigationBar setBarStyle:UIBarStyleBlack];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [postController.navigationBar setBarTintColor:IOS7_NAVGATION_BAR_COLOR];
    } else {
        [postController.navigationBar setBackgroundImage:[UIImage imageWithColor:IOS6_NAVGATION_BAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    }
    [postController pushViewController:topicList animated:NO];
    self.window.rootViewController = postController;
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationWillTerminateNotifacation object:nil];
    
}

@end
