//
//  PostDetailsViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "PostDetailsViewController.h"
#import <MapKit/MapKit.h>

// Segues
// Show fullscreen images
#define showFullscreenImagesSegue @"showFullscreenImagesSegue"

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *previewMapView;
@property (weak, nonatomic) IBOutlet MKMapView *fullscreenMapView;
@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

#pragma mark - IBActions

- (IBAction)onInterestedButtonTapped:(UIButton *)sender
{
	NSLog(@"I'm interested! send to or show me the OP's mail");
}

- (IBAction)onImageButtonTapped:(UIButton *)sender
{
	[self performSegueWithIdentifier:showFullscreenImagesSegue sender:sender.imageView];
}

- (IBAction)onPreviewMapTapped:(UITapGestureRecognizer *)sender
{
	NSLog(@"preview map tapped, set and unhide the fullscreenMapView and flip the current view to show it");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showFullscreenImagesSegue]) {
		//TODO: send images to destinationVC
	}
}

@end
