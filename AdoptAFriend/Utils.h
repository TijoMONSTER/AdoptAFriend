//
//  Utils.h
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/27/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

// Spinner
+ (void)showSpinnerOnView:(UIView *)view withCenter:(CGPoint)center ignoreInteractionEvents:(BOOL)ignoreInteractionEvents;
+ (void)hideSpinner;

// AlertView
+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message;
+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;
+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitles:(NSArray *)buttonTitles;
+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitles:(NSArray *)buttonTitles delegate:(id<UIAlertViewDelegate>)delegate;

// UIImage
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
