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
	
	userInitiatedPop = YES;
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
	
	if (!oldViewController) {
		[self.view addSubview:newViewController.view];
		[newViewController didMoveToParentViewController:self];
		newViewController.view.center = self.view.center;
		return;
	}
	
	[self transitionFromViewController:oldViewController
					  toViewController:newViewController
							  duration:(!animated || !oldViewController) ? 0 : 0.35f
							   options:0
							animations:^{
								newViewController.view.center = self.view.center;
								oldViewController.view.center = CGPointMake(oldViewController.view.center.x - self.view.bounds.size.width, oldViewController.view.center.y);
							}
							completion:^(BOOL finished){
								[newViewController didMoveToParentViewController:self];
							}];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	NSLog(@"pop vc");
	UIViewController *upperViewController = [self.childViewControllers lastObject];
	UIViewController *lowerViewController = self.childViewControllers[(self.childViewControllers.count - 2)];
	
	userInitiatedPop = NO;
	
	[navigationBar popNavigationItemAnimated:animated];
	
	userInitiatedPop = YES;
	
	lowerViewController.view.frame = CGRectMake(0 - self.view.bounds.size.width,
							    navigationBar.bounds.size.height,
							    self.view.bounds.size.width,
							    self.view.bounds.size.height - self.navigationBar.bounds.size.height);
	
	[upperViewController willMoveToParentViewController:nil];
	NSLog(@"%d %d", self.navigationBar.items.count, self.viewControllers.count);

	[self transitionFromViewController:upperViewController
					  toViewController:lowerViewController
							  duration:animated ? 0.35f : 0
							   options:0
							animations:^{
								lowerViewController.view.center = self.view.center;
								upperViewController.view.center = CGPointMake(upperViewController.view.center.x + self.view.bounds.size.width, upperViewController.view.center.y);
							}
							completion:^(BOOL finished){
								[upperViewController removeFromParentViewController];
							}];
	NSLog(@"%d %d", self.navigationBar.items.count, self.viewControllers.count);

	return upperViewController;
}

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
	if (userInitiatedPop) {
		[self popViewControllerAnimated:YES];
		return NO;
	}
	return YES;
}

//- (void) navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
//	userInitiatedPop = YES;
//}

- (UINavigationItem*) newNavigationItemForViewController:(UIViewController*)viewController previousNavigationItem:(UINavigationItem*)lastNavigationItem {
	UINavigationItem *item = [[UINavigationItem alloc] init];
	item.title = viewController.title;
	if (lastNavigationItem) {
		item.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:lastNavigationItem.title style:UIBarButtonItemStyleBordered target:nil action:nil];
	}
	return item;
}



@end
