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

@interface PostDetailsViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *previewMapView;
@property (weak, nonatomic) IBOutlet MKMapView *fullscreenMapView;

@property (weak, nonatomic) IBOutlet PFImageView *firstImageView;
@property (weak, nonatomic) IBOutlet PFImageView *secondImageView;
@property (weak, nonatomic) IBOutlet PFImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

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
		[self.previewMapView addAnnotation:pointAnnotation];

		// zoom map
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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKAnnotationView *pin;
	if ([annotation isKindOfClass:[PostMapAnnotation class]]) {
		pin = [MKAnnotationView new];
//		pin.canShowCallout = YES;
//		pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		// make a copy of the first image and resize it to pinImageSize
		pin.image = [Utils imageWithImage:self.firstImageView.image scaledToSize:CGSizeMake(pinImageSize, pinImageSize)];
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
//	[self performSegueWithIdentifier:showFullscreenImagesSegue sender:tapGestureRecognizer.view];
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
//		FullscreenImagesViewController *fullscreenImagesVC = (FullscreenImagesViewController *)segue.destinationViewController;
	}
}

@end
