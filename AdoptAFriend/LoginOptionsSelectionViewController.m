//
//  LoginOptionsSelectionViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "LoginOptionsSelectionViewController.h"

// Segues
// show sign up screen
#define showSignupScreenSegue @"showSignupScreenSegue"
// show log in screen
#define showLoginScreenSegue @"showLoginScreenSegue"

#define reloadFeedData @"reloadFeedData"

@interface LoginOptionsSelectionViewController ()

@end

@implementation LoginOptionsSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showSignupScreenSegue]) {

	}
	else if ([segue.identifier isEqualToString:showLoginScreenSegue]) {

	}
}

#pragma mark - IBActions

- (IBAction)unwindFromSignupScreen:(UIStoryboardSegue *)segue
{
//	NSLog(@"unwind from signup screen");
	NSLog(@"user signed up %@", [User currentUser]);
	[[NSNotificationCenter defaultCenter] postNotificationName:reloadFeedData object:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)unwindFromLoginScreen:(UIStoryboardSegue *)segue
{
	NSLog(@"unwind from login screen");
	// TODO: pop this view controller to show tab bar controller
}

@end
