//
//  TabBarController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "TabBarController.h"
#import "Utils.h"

// Segues

// Show login optins screen
#define showLoginOptionScreenSegue @"showLoginOptionScreenSegue"

// Notifications

// reload feed data
#define reloadFeedDataNotification @"reloadFeedDataNotification"
// user logged out
#define userLoggedOutNotification @"userLoggedOutNotification"

// Tab bar indexes
#define tabBarIndexFeed 0
#define tabBarIndexMap 1
#define tabBarIndexAddPost 2
#define tabBarIndexMyPosts 3

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

	// listen for reload events
	[defaultCenter addObserver:self
					  selector:@selector(onReloadFeedDataNotification:)
						  name:reloadFeedDataNotification
						object:nil];

	// listen for user logging out
	[defaultCenter addObserver:self
					  selector:@selector(onUserLoggedOut:)
						  name:userLoggedOutNotification
						object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// if not logged in, perform segue
	if (![User currentUser]) {
		[self showUserLoginOptionsScreen];
	}
}

#pragma mark - Notifications

- (void)onReloadFeedDataNotification:(NSNotification *)notification
{
	// show the tab bar
	self.selectedIndex = tabBarIndexFeed;

	NSLog(@"Reload feed! :)");
}

- (void)onUserLoggedOut:(NSNotification *)notification
{
	NSLog(@"User logged out");
	[self showUserLoginOptionsScreen];
}

#pragma mark - Helper methods

- (void)showUserLoginOptionsScreen
{
	[self performSegueWithIdentifier:showLoginOptionScreenSegue sender:nil];
}

@end
