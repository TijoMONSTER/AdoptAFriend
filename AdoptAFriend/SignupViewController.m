//
//  SignupViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "SignupViewController.h"
#import "Utils.h"

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

	// show spinner
	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];

	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		[Utils hideSpinner];

		if (!error) {
			// unwind to loginOptionsVC ?
			[self performSegueWithIdentifier:unwindFromSignupScreenSegue sender:nil];
		} else {
			// invalid email error
			if (error.code == 125) {
				[Utils showAlertViewWithMessage:@"Please insert a valid email address."];
			} else {
				NSString *errorString = [error userInfo][@"error"];
				NSLog(@"error signing up %@ %@", errorString, error.localizedDescription);
				[Utils showAlertViewWithMessage: [NSString stringWithFormat:@"Error signing up: %@", errorString]];
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
		[Utils showAlertViewWithMessage:@"Name is required."];
	}
	else if (self.lastNameTextField.text.length == 0 ||
			 [self.lastNameTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:@"Last Name is required."];
	}
	else if (self.emailTextField.text.length == 0 ||
			 [self.emailTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:@"Email is required."];
	}
	else if (self.passwordTextField.text.length == 0 ||
			 [self.passwordTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:@"Password is required."];
	}
	else if (self.confirmPasswordTextField.text.length == 0 ||
			 [self.confirmPasswordTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:@"Confirmed password is required."];
	}
	// if password and confirmed password are not equals
	else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){
		[Utils showAlertViewWithMessage:@"Password and confirmed password must be equals."];
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

@end
