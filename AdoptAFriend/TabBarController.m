//
//  TabBarController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "TabBarController.h"

// Segues

// Show login optins screen
#define showLoginOptionScreenSegue @"showLoginOptionScreenSegue"

// Notifications
// reload feed data
#define reloadFeedData @"reloadFeedData"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// listen for reload events
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onReloadFeedDataNotification:)
												 name:reloadFeedData
											   object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// if not logged in, perform segue
	if (![User currentUser]) {
		[self performSegueWithIdentifier:showLoginOptionScreenSegue sender:self];
	}
//	else {
		// test code
//		[User logOut];
//		NSLog(@"user logged out for testing :)");
//		[self performSegueWithIdentifier:showLoginOptionScreenSegue sender:self];
//	}
}

#pragma mark - Notifications

- (void)onReloadFeedDataNotification:(NSNotification *)notification
{
	NSLog(@"Reload feed! :)");
}

@end
