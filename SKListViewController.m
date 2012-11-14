//
//  SKListViewController.m
//  SKNavigationController
//
//  Created by Soroush Khanlou on 11/13/12.
//  Copyright (c) 2012 Soroush Khanlou. All rights reserved.
//

#import "SKListViewController.h"
#import "SKViewController.h"
#import "SKNavigationController.h"


@interface SKListViewController ()

@end

@implementation SKListViewController

- (void) viewDidLoad {	
	self.title = @"List of Things";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"Push View %d", indexPath.row + 1];
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 SKViewController *detailViewController = [[SKViewController alloc] initWithNibName:nil bundle:nil];
	
	if ([self.parentViewController isKindOfClass:[SKNavigationController class]]) {
		SKNavigationController *navigationController = (SKNavigationController*)self.parentViewController;
		detailViewController.index = indexPath.row + 1;
		[navigationController pushViewController:detailViewController animated:YES];
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"%@ will appear", self);
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"%@ did appear", self);
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	NSLog(@"%@ will disappear", self);
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	NSLog(@"%@ did disappear", self);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"child will rotate");
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
	[super willMoveToParentViewController:parent];
	NSLog(@"%@ will move to parent %@", self, parent);
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
	[super didMoveToParentViewController:parent];
	NSLog(@"%@ did move to parent %@", self, parent);
}


@end
