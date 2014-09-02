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
		UIApplication *sharedApplication = [UIApplication sharedApplication];
		if (![sharedApplication isIgnoringInteractionEvents]) {
			[sharedApplication beginIgnoringInteractionEvents];
		}
	}
}

+ (void)hideSpinner
{
	// end ignoring interaction events
	UIApplication *sharedApplication = [UIApplication sharedApplication];
	if ([sharedApplication isIgnoringInteractionEvents]) {
		[sharedApplication endIgnoringInteractionEvents];
	}

	[spinner removeFromSuperview];
	[spinner stopAnimating];
	spinner = nil;
}

#pragma mark - AlertView

+ (void)showAlertViewWithMessage:(NSString *)message
{
	[self showAlertViewWithMessage:message title:nil buttonTitles:@[@"OK"] delegate:nil];
}

+ (void)showAlertViewWithMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate
{
	[self showAlertViewWithMessage:message title:nil buttonTitles:@[@"OK"] delegate:delegate];
}

+ (void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitles:(NSArray *)buttonTitles
{
	[self showAlertViewWithMessage:message title:title buttonTitles:buttonTitles delegate:nil];
}

+ (void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitles:(NSArray *)buttonTitles delegate:(id<UIAlertViewDelegate>)delegate
{
	UIAlertView *alertView = [UIAlertView new];
	alertView.message = message;
	alertView.title = title;
	alertView.delegate = delegate;
	for (NSString *buttonTitle in buttonTitles) {
		[alertView addButtonWithTitle:buttonTitle];
	}
	[alertView show];
}

#pragma mark - UIImage

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
