//
//  Utils.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/27/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark - UIActivityIndicatorView

static UIActivityIndicatorView *spinner = nil;

+ (void)showSpinnerOnView:(UIView *)view withCenter:(CGPoint)center ignoreInteractionEvents:(BOOL)ignoreInteractionEvents
{
	if (!spinner) {
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.color = [UIColor darkGrayColor];
		spinner.hidesWhenStopped = YES;
		[spinner stopAnimating];
	}

	spinner.center = center;
	[view addSubview:spinner];

	[spinner startAnimating];

	// ignore interaction events
	if (ignoreInteractionEvents) {
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
}

+ (void)hideSpinner
{
	// end ignoring interaction events
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];

	[spinner removeFromSuperview];
	[spinner stopAnimating];
}

#pragma mark - AlertView

+ (void)showAlertViewWithMessage:(NSString *)message
{
	[self showAlertViewWithMessage:message title:nil buttonTitle:@"OK"];
}

+ (void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitle:(NSString *)buttonTitle
{
	UIAlertView *alertView = [UIAlertView new];
	alertView.message = message;
	alertView.title = title;
	[alertView addButtonWithTitle:buttonTitle];
	[alertView show];
}

@end
