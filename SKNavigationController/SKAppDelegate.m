//
//  SKAppDelegate.m
//  SKNavigationController
//
//  Created by Soroush Khanlou on 11/13/12.
//  Copyright (c) 2012 Soroush Khanlou. All rights reserved.
//

#import "SKAppDelegate.h"
#import "SKListViewController.h"
#import "SKNavigationController.h"

@implementation SKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	
	SKListViewController *list = [[SKListViewController alloc] init];
	self.navigationController = [[SKNavigationController alloc] initWithRootViewController:list];
	self.window.rootViewController = self.navigationController;
	
	
	[self.window makeKeyAndVisible];
	return YES;
}

@end
