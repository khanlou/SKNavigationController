# SKNavigationController

`SKNavigationController` is a very, very basic clone of `UINavigationController`, that uses `UIViewController` containment for appearance management (`viewDidAppear:`, etc) and rotation management (willRotateToInterfaceOrientation:, etc).

## Things it does correctly

* Adds its child subviews to itself in an internally consistent way using the iOS 5 view controller containment APIs, and all the things you get for free with that, such as:
	* Rotation method forwarding
	* Appearance method forwarding
	* Memory warning forwarding
	* `parentViewController` property being set properly
	* `isMovingFromParentViewController` and company
* Animates from states to state

## Things it does not do correctly

* `popToViewController:animated:` and `popToRootViewControllerAnimated:`
* Hiding and showing navigation bars
* Navigation more than two levels deep (possibly: it hasn't been tested, but it should work)
* Many other behaviors you might expect from a real navigation controller.

## Other notes

`SKNavigationController` is written with ARC.

It is SO not ready for production.