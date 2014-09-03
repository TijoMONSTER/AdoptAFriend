//
//  FeedViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "PostDetailsViewController.h"
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>

// Range in kilometers to search for posts
#define kilometersRangeToSearch 10.0

// Cell identifier
#define FeedCellIdentifier @"Cell"

// Cell size
#define FeedCellHeight 100.0

// Segues
// show post details screen
#define showPostDetailsScreenSegue @"showPostDetailsScreenSegue"

// Messages
// Error messages
#define errorRetrievingLocationMessage @"Error retrieving location: %@"
#define errorAccessingLocationMessage @"Can't access your current location. \n\nTo view nearby posts or create a post at your current location, turn on access to your location in the Settings app under Location Services."

@interface FeedViewController () <CLLocationManagerDelegate>

@property PFGeoPoint *userLocation;
@property CLLocationManager *locationManager;
@property BOOL isUpdatingLocation;

@end

@implementation FeedViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];

	// user location
	self.locationManager = [CLLocationManager new];
	self.locationManager.delegate = self;
	// should set desired accuracy ?

	// The className to query on
	self.parseClassName = [Post parseClassName];

	self.pullToRefreshEnabled = YES;
	self.paginationEnabled = YES;
	self.objectsPerPage = 50;

	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if ([self checkLocationServicesTurnedOn] && [self checkApplicationHasLocationServicesPermission]) {
		[self startUpdatingLocation];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self stopUpdatingLocation];
}

#pragma mark - Parse

- (PFQuery *)queryForTable
{
	if (!self.userLocation) {
		return nil;
	}

	PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

	// If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
	if (self.objects.count == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}

	// that are near this location
	[query whereKey:@"location" nearGeoPoint:self.userLocation withinKilometers:kilometersRangeToSearch];
	// that are not resolved
	[query whereKey:@"resolved" equalTo:[NSNumber numberWithBool:NO]];
	// order them by date
	[query orderByDescending:@"createdAt"];
	// include user in the query
	[query includeKey:@"user"];

	return query;
}

#pragma mark - UITableView data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return the cells' height
	return FeedCellHeight;
}

#pragma mark - PFQueryTableViewController

- (FeedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
	FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier];

	Post *post = (Post *)object;
	[cell layoutCellViewWithPost:post];

	return cell;
}

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	switch (status) {
		case kCLAuthorizationStatusAuthorized:
			NSLog(@"location services authorized");
			[self startUpdatingLocation];
			break;
		case kCLAuthorizationStatusDenied:
			NSLog(@"location services denied");
			[Utils showAlertViewWithMessage:errorAccessingLocationMessage];
			[self stopUpdatingLocation];
			break;
		case kCLAuthorizationStatusNotDetermined:
			NSLog(@"location services status not determined");
			[self stopUpdatingLocation];
			break;
		case kCLAuthorizationStatusRestricted:
			NSLog(@"location services restricted");
			[self stopUpdatingLocation];
			break;
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if (error.code == kCLErrorDenied) {
		NSLog(@"locationManager didFailWithError : denied");
	} else if (error.code == kCLErrorLocationUnknown) {
		[Utils showAlertViewWithMessage:@"Can't update location right now, please try again later."];
	} else {
		NSLog(@"Unable to retrieve user location %@ %@", error, error.localizedDescription);
		[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorRetrievingLocationMessage, error.localizedDescription]];
	}

	[self stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	[self stopUpdatingLocation];
	self.userLocation = [PFGeoPoint geoPointWithLocation:locations.lastObject];
	NSLog(@"user location updated %f, %f", self.userLocation.latitude, self.userLocation.longitude);
	[self loadObjects];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showPostDetailsScreenSegue]) {
		// send post data to postDetailsVC
		PostDetailsViewController *postDetailsVC = (PostDetailsViewController *)segue.destinationViewController;

		NSIndexPath *indexPathForSelectedRow = self.tableView.indexPathForSelectedRow;
		Post *post = self.objects[indexPathForSelectedRow.row];
		postDetailsVC.post = post;
	}
}

#pragma mark - Helper methods

- (BOOL) checkLocationServicesTurnedOn {
    if (![CLLocationManager locationServicesEnabled]) {
		[Utils showAlertViewWithMessage:@"Error: Location services must be enabled."];
		return NO;
    }

	return YES;
}

-(BOOL) checkApplicationHasLocationServicesPermission {
	switch ([CLLocationManager authorizationStatus]) {
		case kCLAuthorizationStatusAuthorized:
			NSLog(@"location services authorized");
			return YES;
			break;
		case kCLAuthorizationStatusDenied:
			NSLog(@"location services denied");
			[Utils showAlertViewWithMessage:errorAccessingLocationMessage];
			break;
		case kCLAuthorizationStatusNotDetermined:
			NSLog(@"location services status not determined");
			break;
		case kCLAuthorizationStatusRestricted:
			NSLog(@"location services restricted");
			break;
	}
	return NO;
}

- (void)startUpdatingLocation
{
	if (!self.isUpdatingLocation) {
		[self.locationManager startUpdatingLocation];
		self.isUpdatingLocation = YES;
	}
}

- (void)stopUpdatingLocation
{
	if (self.isUpdatingLocation) {
		[self.locationManager stopUpdatingLocation];
		self.isUpdatingLocation = NO;
	}
}

@end
