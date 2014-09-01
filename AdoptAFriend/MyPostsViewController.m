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
#define cellIdentifier @"Cell"

// Cell size
#define FeedCellHeight 100.0

// Segues
// show modify user data screen
#define showModifyUserDataScreenSegue @"showModifyUserDataScreenSegue"

// Messages
#define noUserPostsMessage @"You haven't posted yet."
// Error messages
#define errorRetrievingUserPostsMessage @"Error retrieving user posts: %@"

@interface MyPostsViewController ()

@property NSArray *posts;

@end

@implementation MyPostsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if ([User currentUser] && self.posts.count == 0) {
		PFQuery *query = [PFQuery queryWithClassName:[Post parseClassName]];
		// get posts from current user
		[query whereKey:@"user" equalTo:[User currentUser]];
		// order them by date
		[query orderByDescending:@"createdAt"];
		// include the user
		[query includeKey:@"user"];
		// limit the number of posts to get
		query.limit = 50;

		[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];

		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			[Utils hideSpinner];

			if (!error) {
				if (objects.count > 0) {
					self.posts = objects;
					[self.tableView reloadData];
				}
			} else {
				NSLog(@"Unable to retrieve nearby posts %@ %@", error, error.localizedDescription);
				[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorRetrievingUserPostsMessage, error.localizedDescription]];
			}
		}];
	}
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return the cells' height
	return FeedCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	if (self.posts.count > 0) {
		return self.posts.count;
	}

	// return 1 to show the noUserPostsMessage
    return 1;
}


- (FeedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

	if (self.posts.count > 0) {
		Post *post = (Post *)self.posts[indexPath.row];
		[cell layoutCellViewWithPost:post];
	} else {
		// cell with the noUserPostsMessage has no need to be interactive
		[cell layoutCellViewWithDescriptionTextOnly:noUserPostsMessage];
	}

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
