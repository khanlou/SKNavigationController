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
	
	self.view.backgroundColor = [UIColor blueColor];
	
	
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

	self.viewControllers = @[internalRootViewController];
}

- (void) setViewControllers:(NSArray *)newViewControllers {
	//reset navigation items
	navigationBar.items = [NSArray array];
	
	for (UIViewController *viewController in newViewControllers) {		
		[self pushViewController:viewController animated:NO];
	}
}

- (NSArray*) viewControllers {
	return self.childViewControllers;
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	UIViewController *pushingFrom = nil;
	if (self.childViewControllers.count > 0) {
		pushingFrom = [self.childViewControllers lastObject];
	}
	UIViewController *pushingTo = viewController;
		
	pushingTo.view.frame = CGRectMake(self.view.bounds.size.width,
							    self.navigationBar.bounds.size.height,
							    self.view.bounds.size.width,
							    self.view.bounds.size.height - self.navigationBar.bounds.size.height);
	
	
	[pushingFrom willMoveToParentViewController:nil];
	
	[pushingTo willMoveToParentViewController:self];
	
	[self addChildViewController:pushingTo];
	

	if (!animated || !pushingFrom) {
		[self.view addSubview:pushingTo.view];

		pushingTo.view.frame = CGRectMake(self.view.bounds.origin.x,
								    self.navigationBar.bounds.size.height,
								    self.view.bounds.size.width,
								    self.view.bounds.size.height - self.navigationBar.bounds.size.height);
		
		[pushingFrom removeFromParentViewController];
		[pushingTo didMoveToParentViewController:self];

	} else {
		[self transitionFromViewController:pushingFrom
					   toViewController:pushingTo
							 duration:0.35f
							  options:0
						    animations:^{
							    pushingTo.view.center = pushingFrom.view.center;
							    pushingFrom.view.center = CGPointMake(pushingFrom.view.center.x - self.view.bounds.size.width, pushingFrom.view.center.y);
						    }
						    completion:^(BOOL finished) {
							    [pushingTo didMoveToParentViewController:self];
						    }];
	}
	
	UINavigationItem *item = [self newNavigationItemForViewController:pushingTo previousNavigationItem:navigationBar.topItem];
	[navigationBar pushNavigationItem:item animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {	
	UIViewController *poppingFrom = [self.childViewControllers lastObject];
	UIViewController *poppingTo = self.childViewControllers[(self.childViewControllers.count - 2)];
	
	poppingTo.view.frame = CGRectMake(0 - self.view.bounds.size.width,
							    navigationBar.bounds.size.height,
							    self.view.bounds.size.width,
							    self.view.bounds.size.height - self.navigationBar.bounds.size.height);
	
	[poppingFrom willMoveToParentViewController:nil];
	[poppingTo willMoveToParentViewController:self];
	[self addChildViewController:poppingTo];
	
	
	if (!animated) {
		[self.view addSubview:poppingTo.view];
		
		poppingTo.view.frame = CGRectMake(0,
								    self.navigationBar.bounds.size.height,
								    self.view.bounds.size.width,
								    self.view.bounds.size.height - self.navigationBar.bounds.size.height);
		
		[poppingFrom.view removeFromSuperview];
		[poppingFrom removeFromParentViewController];
		[poppingTo didMoveToParentViewController:self];
		
	} else {
		[self transitionFromViewController:poppingFrom
					   toViewController:poppingTo
							 duration:0.35
							  options:0
						    animations:^{
							    poppingTo.view.center = poppingFrom.view.center;
							    poppingFrom.view.center = CGPointMake(poppingFrom.view.center.x + self.view.bounds.size.width, poppingFrom.view.center.y);
						    }
						    completion:^(BOOL finished) {
							    [poppingFrom removeFromParentViewController];
							    [poppingTo didMoveToParentViewController:self];
						    }];
	}
	
	if (!userInitiatedPop) {
		//set this to the proper navigation item array
		[navigationBar popNavigationItemAnimated:animated];
	}
	
	userInitiatedPop = NO;
	
	
	return poppingTo;

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
