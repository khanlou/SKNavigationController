//
//  SKViewController.m
//  SKNavigationController
//
//  Created by Soroush Khanlou on 11/13/12.
//  Copyright (c) 2012 Soroush Khanlou. All rights reserved.
//

#import "SKViewController.h"
#import "SKNavigationController.h"

@interface SKViewController ()

@property (nonatomic, strong) UILabel *label;
@end

@implementation SKViewController

@synthesize label, index;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	label = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20, 50)];
	label.font = [UIFont boldSystemFontOfSize:200.0f];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[self.view addGestureRecognizer:gr];

	[self.view addSubview:label];
	
	self.view.backgroundColor = [UIColor blueColor];

	
	self.index = index;
}

- (void) setIndex:(NSInteger)newIndex {
	index = newIndex;
	label.text = [NSString stringWithFormat:@"%d", index];
	
	
	self.title = [NSString stringWithFormat:@"Number %d", index];
}

- (void) tapped:(UITapGestureRecognizer*)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		[((SKNavigationController*)self.parentViewController) popViewControllerAnimated:YES];
	}
}

//- (void) viewWillAppear:(BOOL)animated {
//	[super viewWillAppear:animated];
//	NSLog(@"%@ will appear", self);
//}
//
//- (void) viewDidAppear:(BOOL)animated {
//	[super viewDidAppear:animated];
//	NSLog(@"%@ did appear", self);
//}
//
//- (void) viewWillDisappear:(BOOL)animated {
//	[super viewWillDisappear:animated];
//	NSLog(@"%@ will disappear", self);
//}
//
//- (void) viewDidDisappear:(BOOL)animated {
//	[super viewDidDisappear:animated];
//	NSLog(@"%@ did disappear", self);
//}
//
//- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//	NSLog(@"child will rotate");
//}
//
//- (void) willMoveToParentViewController:(UIViewController *)parent {
//	[super willMoveToParentViewController:parent];
//	NSLog(@"%@ will move to parent %@", self, parent);
//}
//
//- (void) didMoveToParentViewController:(UIViewController *)parent {
//	[super didMoveToParentViewController:parent];
//	NSLog(@"%@ did move to parent %@", self, parent);
//}


@end
