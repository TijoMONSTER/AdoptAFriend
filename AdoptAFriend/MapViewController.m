//
//  MapViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "MapViewController.h"
#import "PostDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "Utils.h"
#import "PostMapAnnotation.h"

// Range in kilometers to search for posts
#define kilometersRangeToSearch 10.0

// Segues
// show post details screen
#define showPostDetailsScreenSegue @"showPostDetailsScreenSegue"

// Pin
#define pinImageSize 25

// Messages
// Error messages
#define errorRetrievingLocationMessage @"Error retrieving location: %@"
#define errorRetrievingNearbyPostsMessage @"Error retrieving nearby posts: %@"
#define errorNoPostsNearbyMessage @"Sorry, no posts nearby. :("

@interface MapViewController () <MKMapViewDelegate, PostMapAnnotationDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property PFGeoPoint *userLocation;
@property NSArray *posts;
@property PFQuery *query;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// if user is logged in, query it's location
	if ([User currentUser] && self.posts.count == 0) {
		[self loadUserLocation];
	}
}

- (void)loadUserLocation
{
	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];
	// get the user location as a PFGeoPoint
	[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
		[Utils hideSpinner];
		if (!error) {
				self.userLocation = geoPoint;
				NSLog(@"user location updated %f, %f", self.userLocation.latitude, self.userLocation.longitude);
				[self zoomMap];
				[self findNearbyPosts];
		} else {
			NSLog(@"Unable to retrieve user location %@ %@", error, error.localizedDescription);
			[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorRetrievingLocationMessage, error.localizedDescription]];
		}
	}];
}

- (void)findNearbyPosts
{
	if (self.query != nil) {
		NSLog(@"cancelling query");
		[self.query cancel];
		[Utils hideSpinner];
	}

	self.query = [PFQuery queryWithClassName:[Post parseClassName]];
	// that are near this location
	[self.query whereKey:@"location" nearGeoPoint:self.userLocation withinKilometers:kilometersRangeToSearch];
	// that are not resolved
	[self.query whereKey:@"resolved" equalTo:[NSNumber numberWithBool:NO]];
	// order them by date
	[self.query orderByDescending:@"createdAt"];
	// include user in the query
	[self.query includeKey:@"user"];
	// limit the number of posts to get
	self.query.limit = 50;

	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];

	[self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		[Utils hideSpinner];
		if (!error) {
			self.posts = objects;
			if (self.posts.count > 0) {
				[self addPostAnnotations];
				[self.mapView becomeFirstResponder];
				[self.mapView reloadInputViews];
			} else {
				[Utils showAlertViewWithMessage:errorNoPostsNearbyMessage];
			}

		} else {
			NSLog(@"Unable to retrieve nearby posts %@ %@", error, error.localizedDescription);
			[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorRetrievingNearbyPostsMessage, error.localizedDescription]];
		}
	}];
}

- (void)addPostAnnotations
{
	for (Post *post in self.posts) {
		PostMapAnnotation *annotation = [PostMapAnnotation new];
		annotation.delegate = self;
		annotation.post = post;
		[annotation setAnnotationData];
		[self.mapView addAnnotation:annotation];
	}
}

- (void)zoomMap
{
	MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(self.userLocation.latitude,
																								 self.userLocation.longitude),
																	  // multiplied by 1000 because units must be meters
																	  kilometersRangeToSearch * 1000,
																	  kilometersRangeToSearch * 1000);
	[self.mapView setRegion:mapRegion animated:YES];
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKAnnotationView *pin;

	if ([annotation isKindOfClass:[PostMapAnnotation class]]) {
		pin = [MKAnnotationView new];
		pin.canShowCallout = YES;
		pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	}
	return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	PostMapAnnotation *annotation = (PostMapAnnotation *)view.annotation;
	[self performSegueWithIdentifier:showPostDetailsScreenSegue sender:annotation.post];
}

#pragma mark - PostMapAnnotation delegate

- (void)didFinishDownloadingImage:(UIImage *)image forAnnotation:(PostMapAnnotation *)annotation
{
	// set image for annotation view
	MKAnnotationView *pin = [self.mapView viewForAnnotation:annotation];
	pin.image = pin.image = [Utils imageWithImage:image scaledToSize:CGSizeMake(pinImageSize, pinImageSize)];
}

#pragma mark - IBActions

- (IBAction)onReloadButtonTapped:(UIBarButtonItem *)sender
{
	[self.mapView removeAnnotations:self.mapView.annotations];
	[self loadUserLocation];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showPostDetailsScreenSegue]) {
		PostDetailsViewController *postDetailsVC = (PostDetailsViewController *)segue.destinationViewController;
		// the sender is the post
		postDetailsVC.post = sender;
	}
}

@end
