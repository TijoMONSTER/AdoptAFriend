//
//  MyPostsTableViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "MyPostsViewController.h"
#import "FeedTableViewCell.h"
#import "SignupViewController.h"
#import "Utils.h"

// Cell identifier
#define FeedCellIdentifier @"Cell"

// Cell size
#define FeedCellHeight 100.0

// Segues
// show modify user data screen
#define showModifyUserDataScreenSegue @"showModifyUserDataScreenSegue"

// Messages
// Error messages
#define errorDeletingPostMessage @"Error deleting post: %@"

@interface MyPostsViewController ()

@end

@implementation MyPostsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];

	self.parseClassName = [Post parseClassName];

	self.pullToRefreshEnabled = YES;
	self.paginationEnabled = YES;
	self.objectsPerPage = 5;

	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self loadObjects];
}

#pragma mark - Parse

- (PFQuery *)queryForTable
{
	PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

	// If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
	if (self.objects.count == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}

	// get posts from current user
	[query whereKey:@"user" equalTo:[User currentUser]];
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

		Post *post = (Post *) self.objects[indexPath.row];

		[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];
		// Delete the row from the data source
		[post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			[Utils hideSpinner];
			if (!error) {
				if (succeeded) {
					NSLog(@"Deleted user post");
					[self.queryForTable clearCachedResult];
					[self loadObjects];
				}
			} else {
				NSLog(@"Unable to delete user post %@ %@", error, error.localizedDescription);
				[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorDeletingPostMessage, error.localizedDescription]];
			}
		}];
    }
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
	if ([segue.identifier isEqualToString:showModifyUserDataScreenSegue]) {
		SignupViewController *modifyUserDataVC = (SignupViewController *)segue.destinationViewController;
		modifyUserDataVC.hidesBottomBarWhenPushed = YES;
	}
}


@end
