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

// AlertViews
+ (void)showAlertViewWithMessage:(NSString *)message;
+ (void)showAlertViewWithMessage:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;
+ (void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitle:(NSString *)buttonTitle;
+ (void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title buttonTitle:(NSString *)buttonTitle delegate:(id<UIAlertViewDelegate>)delegate;

// UIImages
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize

@end
