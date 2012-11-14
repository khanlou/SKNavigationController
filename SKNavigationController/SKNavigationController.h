//
//  SKNavigationController.h
//  SKNavigationController
//
//  Created by Soroush Khanlou on 11/13/12.
//  Copyright (c) 2012 Soroush Khanlou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKNavigationController : UIViewController <UINavigationBarDelegate>

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIViewController *topViewController;
@property (nonatomic, retain) UIViewController *visibleViewController;


- (id)initWithRootViewController:(UIViewController *)rootViewController;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
