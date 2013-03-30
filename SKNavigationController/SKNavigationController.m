//
//  SKNavigationController.m
//  SKNavigationController
//
//  Created by Soroush Khanlou on 11/13/12.
//  Copyright (c) 2012 Soroush Khanlou. All rights reserved.
//

#import "SKNavigationController.h"

@interface SKNavigationController ()

@property (nonatomic, strong) UIViewController *internalRootViewController;
@property (nonatomic, assign) BOOL userInitiatedPop;

@end

@implementation SKNavigationController

@synthesize viewControllers, navigationBar, userInitiatedPop, internalRootViewController;

- (id) initWithRootViewController:(UIViewController *)rootViewController {
	self = [super init];
	if (!self) {
		return self;
	}
		
	internalRootViewController = rootViewController;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];		
}

- (void) viewWillAppear:(BOOL)animated {
	
	self.navigationBar = [[UINavigationBar alloc] init];
	[self.view addSubview:navigationBar];
	navigationBar.delegate = self;
	[navigationBar sizeToFit];
	
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;


	self.viewControllers = @[internalRootViewController];
	internalRootViewController = nil;
}

- (void) setViewControllers:(NSArray *)newViewControllers {
	navigationBar.items = [NSArray array];
	
	for (UIViewController *viewController in self.childViewControllers) {
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
	
	for (UIViewController *viewController in newViewControllers) {		
		[self pushViewController:viewController animated:NO];
	}
}

- (NSArray*) viewControllers {
	return self.childViewControllers;
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	UIViewController *oldViewController = nil;
	if (self.childViewControllers.count > 0) {
		oldViewController = [self.childViewControllers lastObject];
	}
	UIViewController *newViewController = viewController;
	
	newViewController.view.frame = CGRectMake(self.view.bounds.size.width,
							    self.navigationBar.bounds.size.height,
							    self.view.bounds.size.width,
							    self.view.bounds.size.height - self.navigationBar.bounds.size.height);
	
	
	[self addChildViewController:newViewController];
	
	UINavigationItem *item = [self newNavigationItemForViewController:newViewController previousNavigationItem:navigationBar.topItem];
	[navigationBar pushNavigationItem:item animated:animated];
	
	void (^animations)(void) = ^{
		newViewController.view.center = self.view.center;
		oldViewController.view.center = CGPointMake(oldViewController.view.center.x - self.view.bounds.size.width, oldViewController.view.center.y);

	};
	
	void (^completion)(BOOL finished) = ^(BOOL finished){
		[newViewController didMoveToParentViewController:self];
	};

	[self.view addSubview:newViewController.view];
	if (!animated || !oldViewController) {
		[self.view addSubview:newViewController.view];
		[oldViewController.view removeFromSuperview];
		
		animations();
		completion(YES);
	} else {
		[self transitionFromViewController:oldViewController
					   toViewController:newViewController
							 duration:0.35f
							  options:0
						    animations:animations
						    completion:completion];
	}
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {	
	UIViewController *upperViewController = [self.childViewControllers lastObject];
	UIViewController *lowerViewController = self.childViewControllers[(self.childViewControllers.count - 2)];
	
	lowerViewController.view.frame = CGRectMake(0 - self.view.bounds.size.width,
							    navigationBar.bounds.size.height,
							    self.view.bounds.size.width,
							    self.view.bounds.size.height - self.navigationBar.bounds.size.height);
	
	[upperViewController willMoveToParentViewController:nil];	
	
	if (!userInitiatedPop) {
		[navigationBar popNavigationItemAnimated:animated];
	}
	userInitiatedPop = NO;
	
	void (^animations)(void) = ^{
		lowerViewController.view.center = self.view.center;
		upperViewController.view.center = CGPointMake(upperViewController.view.center.x + self.view.bounds.size.width, upperViewController.view.center.y);
	};
	
	void (^completion)(BOOL finished) = ^(BOOL finished){
		[upperViewController removeFromParentViewController];
	};


	if (!animated) {
		[self.view addSubview:lowerViewController.view];
		
		animations();
		[upperViewController.view removeFromSuperview];
		completion(YES);
		
	} else {
		[self transitionFromViewController:upperViewController
					   toViewController:lowerViewController
							 duration:0.35
							  options:0
						    animations:animations
						    completion:completion];
	}
	
	
	
	return lowerViewController;

}

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
	userInitiatedPop = YES;
	[self popViewControllerAnimated:YES];
	return YES;
}

- (UINavigationItem*) newNavigationItemForViewController:(UIViewController*)viewController previousNavigationItem:(UINavigationItem*)lastNavigationItem {
	UINavigationItem *item = [[UINavigationItem alloc] init];
	item.title = viewController.title;
	if (lastNavigationItem) {
		item.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:lastNavigationItem.title style:UIBarButtonItemStyleBordered target:nil action:nil];
	}
	return item;
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"parent will rotate");
}

// // these return YES by default
//- (BOOL) shouldAutomaticallyForwardAppearanceMethods {
//	return NO;
//}
//
//- (BOOL) shouldAutomaticallyForwardRotationMethods {
//	return NO;
//}


@end
