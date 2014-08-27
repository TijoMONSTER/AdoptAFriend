//
//  SignupViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "SignupViewController.h"

// Segues
// unwind to loginOptionsVC
#define unwindFromSignupScreenSegue @"unwindFromSignupScreenSegue"

// Empty string
#define emptyString @""

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genreSegmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// set the first textfield active
	[self.nameTextField becomeFirstResponder];
}

- (void)signup
{
	User *user = (User *)[User user];
	user.username = self.emailTextField.text;
	user.name = self.nameTextField.text;
	user.lastName = self.lastNameTextField.text;
	user.email = self.emailTextField.text;
	user.password = self.passwordTextField.text;
	user.genre = [self genreForIndex:self.genreSegmentedControl.selectedSegmentIndex];

	[self.activityIndicator startAnimating];

	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		[self.activityIndicator stopAnimating];

		if (!error) {
			// unwind to loginOptionsVC ?
			[self performSegueWithIdentifier:unwindFromSignupScreenSegue sender:nil];
		} else {
			// invalid email error
			if (error.code == 125) {
				[self showAlertViewWithMessage:@"Please insert a valid email address."];
			} else {
				NSString *errorString = [error userInfo][@"error"];
				NSLog(@"error signing up %@ %@", errorString, error.localizedDescription);
				[self showAlertViewWithMessage: [NSString stringWithFormat:@"Error signing up: %@", errorString]];
			}
		}
	}];
}

#pragma mark - IBActions

- (IBAction)onSubmitButtonTapped:(UIButton *)sender
{
	// hide the keyboard
	[self.nameTextField resignFirstResponder];
	[self.lastNameTextField resignFirstResponder];
	[self.emailTextField resignFirstResponder];
	[self.passwordTextField resignFirstResponder];
	[self.confirmPasswordTextField resignFirstResponder];

	// check if textfields are empty
	if (self.nameTextField.text.length == 0 ||
		[self.nameTextField.text isEqualToString:emptyString]) {
		[self showAlertViewWithMessage:@"Name is required."];
	}
	else if (self.lastNameTextField.text.length == 0 ||
			 [self.lastNameTextField.text isEqualToString:emptyString]) {
		[self showAlertViewWithMessage:@"Last Name is required."];
	}
	else if (self.emailTextField.text.length == 0 ||
			 [self.emailTextField.text isEqualToString:emptyString]) {
		[self showAlertViewWithMessage:@"Email is required."];
	}
	else if (self.passwordTextField.text.length == 0 ||
			 [self.passwordTextField.text isEqualToString:emptyString]) {
		[self showAlertViewWithMessage:@"Password is required."];
	}
	else if (self.confirmPasswordTextField.text.length == 0 ||
			 [self.confirmPasswordTextField.text isEqualToString:emptyString]) {
		[self showAlertViewWithMessage:@"Confirmed password is required."];
	}
	// if password and confirmed password are not equals
	else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){
		[self showAlertViewWithMessage:@"Password and confirmed password must be equals."];
	}
	else {
		[self signup];
	}
}

#pragma mark - Helper methods

- (NSString *)genreForIndex:(NSInteger)index
{
	return (index == 0) ? @"Male" : @"Female";
}

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
