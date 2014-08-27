//
//  LoginViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"

// Segues
// unwind to loginOptionsVC
#define unwindFromLoginScreen @"unwindFromLoginScreen"

// Empty string
#define emptyString @""

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	//set the active textfield
	[self.emailTextField becomeFirstResponder];
}

- (void)login
{
	// ignore user interaction and show spinner
	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];

	[User logInWithUsernameInBackground:self.emailTextField.text
							   password:self.passwordTextField.text
								  block:^(PFUser *user, NSError *error) {
									  // stop ignoring user interaction and hide spinner
									  [Utils hideSpinner];

									  if (user) {
										  [self performSegueWithIdentifier:unwindFromLoginScreen sender:nil];
									  }	else {
										  NSString *errorString = [error userInfo][@"error"];
										  NSLog(@"error logging in %@ %@", errorString, error.localizedDescription);
										  [self showAlertViewWithMessage: [NSString stringWithFormat:@"Error signing up: %@", errorString]];
									  }
	}];
}

#pragma mark - IBActions

- (IBAction)onSubmitButtonTapped:(UIButton *)sender
{
	// hide the keyboard
	[self.emailTextField resignFirstResponder];
	[self.passwordTextField resignFirstResponder];

	// check if textfields are empty
	if (self.emailTextField.text.length == 0 ||
		[self.emailTextField.text isEqualToString:emptyString]) {
		[self showAlertViewWithMessage:@"Email is required."];
	}
	else if (self.passwordTextField.text.length == 0 ||
		[self.passwordTextField.text isEqualToString:emptyString]) {
		[self showAlertViewWithMessage:@"Password is required."];
	} else {
		[self login];
	}
}

#pragma mark - Helper methods

- (void)showAlertViewWithMessage:(NSString *)message
{
	[self showAlertViewWithMessage:message title:nil buttonTitle:@"OK"];
}

- (void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitle:(NSString *)buttonTitle
{
	UIAlertView *alertView = [UIAlertView new];
	alertView.message = message;
	alertView.title = title;
	[alertView addButtonWithTitle:buttonTitle];
	[alertView show];
}

@end
