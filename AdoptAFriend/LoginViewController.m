//
//  LoginViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "LoginViewController.h"

// Segues
// unwind to loginOptionsVC
#define unwindFromLoginScreen @"unwindFromLoginScreen"

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

- (IBAction)onSubmitButtonTapped:(UIButton *)sender
{
	NSLog(@"log in");
	[self performSegueWithIdentifier:unwindFromLoginScreen sender:nil];
}

@end
