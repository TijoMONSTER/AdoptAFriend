//
//  PostDetailsViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "PostDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "FullscreenImagesViewController.h"
#import "PostMapAnnotation.h"
#import "Utils.h"

// Segues
// Show fullscreen images
#define showFullscreenImagesSegue @"showFullscreenImagesSegue"

// Messages
// Error messages
#define errorDownloadingImageMessage @"Error downloading post image: %@"

// Pin
#define pinImageSize 25

// Animations
// Flip animation duration
#define flipAnimationDuration 0.7

@interface PostDetailsViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *previewMapView;
@property (weak, nonatomic) IBOutlet MKMapView *fullscreenMapView;

@property (weak, nonatomic) IBOutlet PFImageView *firstImageView;
@property (weak, nonatomic) IBOutlet PFImageView *secondImageView;
@property (weak, nonatomic) IBOutlet PFImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UIButton *interestedButton;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];
	// Images
	UIImage *placeHolderImage = [UIImage imageNamed:FeedCellPlaceHolderImage];

	// set the placeholder image
	self.firstImageView.image = placeHolderImage;
	self.secondImageView.image = placeHolderImage;
	self.thirdImageView.image = placeHolderImage;

	// set the image that will be downloaded in background
	self.firstImageView.file = self.post.image1;
	self.secondImageView.file = self.post.image2;
	self.thirdImageView.file = self.post.image3;

	// load the first image
	[self.firstImageView loadInBackground:^(UIImage *image, NSError *error) {
		[Utils hideSpinner];

		if (error) {
			NSLog(@"Unable to download post image %@ %@", error, error.localizedDescription);
			[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorDownloadingImageMessage, error.localizedDescription]];
		}

		// Add location annotation until the first image is loaded
		PostMapAnnotation *pointAnnotation = [PostMapAnnotation new];
		pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.post.location.latitude, self.post.location.longitude);
		pointAnnotation.title = [NSString stringWithFormat:@"%@ %@", self.post.user.name, self.post.user.lastName];
		pointAnnotation.subtitle = self.post.descriptionText;
		// show it on the preview map
		[self.previewMapView addAnnotation:pointAnnotation];
		// show it on the fullscreen map
		[self.fullscreenMapView addAnnotation:pointAnnotation];

		// zoom preview map
		MKCoordinateRegion mapRegion;
		mapRegion.center = pointAnnotation.coordinate;
		mapRegion.span.latitudeDelta = 0.008;
		mapRegion.span.longitudeDelta = 0.008;
		[self.previewMapView setRegion:mapRegion animated:YES];
	}];
	//load second image
	[self.secondImageView loadInBackground];
	// load third image
	[self.thirdImageView loadInBackground];

	// description
	self.descriptionTextView.text = self.post.descriptionText;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//}

#pragma mark - Actions

- (void)onMapViewDoneButtonTapped:(UIBarButtonItem *)sender
{
	self.navigationItem.hidesBackButton = NO;
	self.navigationItem.title = @"Post";

	// add done button
	self.navigationItem.rightBarButtonItem = nil;

	[UIView transitionWithView:self.fullscreenMapView
					  duration:flipAnimationDuration
					   options:UIViewAnimationOptionTransitionFlipFromRight
					animations:^{
						self.fullscreenMapView.hidden = YES;
					}
					completion:nil];
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKAnnotationView *pin;

	if ([annotation isKindOfClass:[PostMapAnnotation class]]) {
		pin = [MKAnnotationView new];
		// make a copy of the first image and resize it to pinImageSize
		pin.image = [Utils imageWithImage:self.firstImageView.image scaledToSize:CGSizeMake(pinImageSize, pinImageSize)];

		// show callout only on fullscreen mapView
		if ([mapView isEqual:self.fullscreenMapView]) {
			pin.canShowCallout = YES;
		}
	}
	return pin;
}

#pragma mark - IBActions

- (IBAction)onInterestedButtonTapped:(UIButton *)sender
{
	NSLog(@"I'm interested! send to or show me the OP's mail");
}

- (IBAction)onImageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
	PFImageView *tappedImageView = (PFImageView *)tapGestureRecognizer.view;

	[self performSegueWithIdentifier:showFullscreenImagesSegue sender:tappedImageView];
}

- (IBAction)onPreviewMapTapped:(UITapGestureRecognizer *)sender
{
	// remove back button and title
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = nil;

	// flip transition
	[UIView transitionWithView:self.fullscreenMapView
					  duration:flipAnimationDuration
					   options:UIViewAnimationOptionTransitionFlipFromLeft
					animations:^{
						self.fullscreenMapView.hidden = NO;
					}
					completion:^(BOOL finished) {
						// add done button
						self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																								  style:UIBarButtonItemStyleDone
																								 target:self
																								 action:@selector(onMapViewDoneButtonTapped:)];

						// zoom map
						MKCoordinateRegion mapRegion;
						mapRegion.center = CLLocationCoordinate2DMake(self.post.location.latitude, self.post.location.longitude);
						mapRegion.span.latitudeDelta = 0.008;
						mapRegion.span.longitudeDelta = 0.008;
						[self.fullscreenMapView setRegion:mapRegion animated:YES];
					}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showFullscreenImagesSegue]) {

		NSMutableArray *images = [NSMutableArray new];
		UIImage *defaultImage = [UIImage imageNamed:FeedCellPlaceHolderImage];

		// if images are not the placeholder image, add them to the array
		if (self.firstImageView.image != defaultImage) {
			[images addObject:self.firstImageView.image];
		}
		if (self.secondImageView.image != defaultImage) {
			[images addObject:self.secondImageView.image];
		}
		if (self.thirdImageView.image != defaultImage) {
			[images addObject:self.thirdImageView.image];
		}

		// by default the collection view will go to index 0 (the first image)
		int tappedImageIndex = 0;
		if ([sender isEqual:self.secondImageView]) {
			tappedImageIndex = 1;
		} else if ([sender isEqual:self.thirdImageView]) {
			tappedImageIndex = 2;
		}

		// send images to destinationVC
		FullscreenImagesViewController *fullscreenImagesVC = (FullscreenImagesViewController *)segue.destinationViewController;
		fullscreenImagesVC.images = images;
		// set the image that will be displayed first
		fullscreenImagesVC.selectedImageIndex = tappedImageIndex;

	}
}

@end
