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

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	// if not logged in, perform segue
	if (![PFUser currentUser]) {
		NSLog(@"no user");
		[self performSegueWithIdentifier:showLoginOptionScreenSegue sender:self];
	}
}

@end
