//
//  AppDelegate.m
//  Making
//
//  Created by rico on 2016/3/29.
//  Copyright © 2016年 Making. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ChangeTypeManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ChangeTypeManager shareInstance];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc] init]];
    [nav setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = nav;
    return YES;
}

@end
