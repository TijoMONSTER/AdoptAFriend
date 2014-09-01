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

@interface FeedViewController ()

@property PFGeoPoint *userLocation;

@end

@implementation FeedViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];

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

	// if user is logged in, do the query
	if ([User currentUser] && self.objects.count == 0) {
		// get the user location as a PFGeoPoint
		[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
			if (!error) {
					self.userLocation = geoPoint;
					NSLog(@"user location updated %f, %f", self.userLocation.latitude, self.userLocation.longitude);
					[self loadObjects];
			} else {
				NSLog(@"Unable to retrieve user location %@ %@", error, error.localizedDescription);
				[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorRetrievingLocationMessage, error.localizedDescription]];
			}
		}];
	}
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

	// get posts from current user
	[query whereKey:@"user" equalTo:[User currentUser]];
	// that are near this location
	[query whereKey:@"location" nearGeoPoint:self.userLocation withinKilometers:kilometersRangeToSearch];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showPostDetailsScreenSegue]) {
		// send post data to postDetailsVC
		PostDetailsViewController *postDetailsVC = (PostDetailsViewController *)segue.destinationViewController;
		postDetailsVC.hidesBottomBarWhenPushed = YES;

		NSIndexPath *indexPathForSelectedRow = self.tableView.indexPathForSelectedRow;
		Post *post = self.objects[indexPathForSelectedRow.row];
		postDetailsVC.post = post;
	}
}


@end
