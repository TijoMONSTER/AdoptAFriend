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

// Notifications

// user logged out
#define userLoggedOutNotification @"userLoggedOutNotification"

// Empty string
#define emptyString @""

// Genres
#define genreMale @"Male"
#define genreFemale @"Female"

// Messages
#define successEditingUserMessage @"User updated successfully."

#define nameRequiredMessage @"Name is required."
#define lastNameRequiredMessage @"Last Name is required."
#define emailRequiredMessage @"Email is required."
#define passwordRequiredMessage @"Password is required."
#define confirmedPasswordRequiredMessage @"Confirmed password is required."
#define equalPasswordsMessage @"Password and confirmed password must be equals."
#define invalidEmailMessage @"Please insert a valid email address."

// Error messages
#define errorSigningUpMessage @"Error signing up: %@"
#define errorEditingUserData @"Error editing user data: %@"

@interface SignupViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genreSegmentedControl;

@property BOOL isEditing;

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	User *currentUser = [User currentUser];

	// if there's a user logged in, it's editing the profile
	self.isEditing = (currentUser != nil);

	// edit profile
	if (self.isEditing) {
		// enable logout button
		self.navigationItem.rightBarButtonItem.enabled = YES;
		self.navigationItem.title = @"Edit profile";

		self.nameTextField.text = currentUser.name;
		self.lastNameTextField.text = currentUser.lastName;
		self.emailTextField.text = currentUser.email;
		self.genreSegmentedControl.selectedSegmentIndex = [self indexForGenre:currentUser.genre];
	}
	// sign up
	else {
		// remove logout button
		self.navigationItem.rightBarButtonItem = nil;
		// set the first textfield active
		[self.nameTextField becomeFirstResponder];
	}
}

- (void)saveUserData
{
	User *user;
	// if it's signing up, the current user is nil, then create one
	if (self.isEditing) {
		user = [User currentUser];
	} else {
		user = (User *)[User user];
	}

	user.username = self.emailTextField.text;
	user.name = self.nameTextField.text;
	user.lastName = self.lastNameTextField.text;
	user.email = self.emailTextField.text;
	user.password = self.passwordTextField.text;
	user.genre = [self genreForIndex:self.genreSegmentedControl.selectedSegmentIndex];

	// show spinner
	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];

	// edit
	if (self.isEditing) {
		[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			[Utils hideSpinner];

			if (!error) {
				if (succeeded) {
					[Utils showAlertViewWithMessage:successEditingUserMessage delegate:self];
				} else {
					NSLog(@"Didn't succeed editing user data.");
				}
			} else {
				NSString *errorString = [error userInfo][@"error"];
				NSLog(@"error editing user data %@ %@", errorString, error.localizedDescription);
				[Utils showAlertViewWithMessage:[NSString stringWithFormat:errorEditingUserData, errorString]];
			}
		}];
	}
	// sign up
	else {
		[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			[Utils hideSpinner];

			if (!error) {
				// unwind to loginOptionsVC ?
				[self performSegueWithIdentifier:unwindFromSignupScreenSegue sender:nil];
			} else {
				// invalid email error
				if (error.code == 125) {
					[Utils showAlertViewWithMessage:invalidEmailMessage];
				} else {
					NSString *errorString = [error userInfo][@"error"];
					NSLog(@"error signing up %@ %@", errorString, error.localizedDescription);
					[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorSigningUpMessage, errorString]];
				}
			}
		}];
	}
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
		[Utils showAlertViewWithMessage:nameRequiredMessage];
	}
	else if (self.lastNameTextField.text.length == 0 ||
			 [self.lastNameTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:lastNameRequiredMessage];
	}
	else if (self.emailTextField.text.length == 0 ||
			 [self.emailTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:emailRequiredMessage];
	}
	else if (self.passwordTextField.text.length == 0 ||
			 [self.passwordTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:passwordRequiredMessage];
	}
	else if (self.confirmPasswordTextField.text.length == 0 ||
			 [self.confirmPasswordTextField.text isEqualToString:emptyString]) {
		[Utils showAlertViewWithMessage:confirmedPasswordRequiredMessage];
	}
	// if password and confirmed password are not equals
	else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){
		[Utils showAlertViewWithMessage:equalPasswordsMessage delegate:self];
	}
	else {
		[self saveUserData];
	}
}

- (IBAction)onLogoutButtonTapped:(UIBarButtonItem *)sender
{
	if ([User currentUser]) {
		[User logOut];
		[self.navigationController popToRootViewControllerAnimated:NO];
		[[NSNotificationCenter defaultCenter] postNotificationName:userLoggedOutNotification object:nil];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// reset password textfields if they're not equals
	// or if it succeeded editing user data
	if ([alertView.message isEqualToString:equalPasswordsMessage] ||
		[alertView.message isEqualToString:successEditingUserMessage]) {
		self.passwordTextField.text = nil;
		self.confirmPasswordTextField.text = nil;
	}
}

#pragma mark - Helper methods

- (NSString *)genreForIndex:(NSInteger)index
{
	return (index == 0) ? genreMale : genreFemale;
}

- (int)indexForGenre:(NSString *)genre
{
	return ([genre isEqualToString:genreMale]) ? 0 : 1;
}

@end
