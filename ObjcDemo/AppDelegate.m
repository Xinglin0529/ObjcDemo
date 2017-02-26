//
//  AppDelegate.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/22.
//  Copyright © 2016年 com. All rights reserved.
//

#import "AppDelegate.h"
#import "UIViewController+Swizze.h"
#import "ViewController.h"
#import "CircleViewController.h"
#import "RootViewController.h"
#import "NavigationViewController.h"
#import "AutoreleaseObject.h"
#import "ComputedModel.h"

#import <WeexSDK/WeexSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIViewController swizze];
    [AutoreleaseObject new];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[RootViewController new]];
    [self.window makeKeyAndVisible];
    
//    [self sendRequest];
    
    ComputedModel *compute = [ComputedModel new];
    [compute computed4];
    return YES;
}

- (void)sendRequest {
    NSURL *url = [NSURL URLWithString:@"https://api.douban.com/v2/book/1220562"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *errorMsg;
//        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:&errorMsg];
        NSLog(@"%@---%@",obj, errorMsg);
    }];
    [task resume];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
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
