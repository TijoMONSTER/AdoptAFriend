//
//  MyProfileViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "MyProfileViewController.h"
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
#define postDeletionConfirmationMessage @"Are you sure you want to delete this post?"
#define reasonForDeletionMessage @"Please tell us why are you deleting this post."
// Error messages
#define errorDeletingPostMessage @"Error deleting post: %@"

// AlertView tags
#define postDeletionAlertViewTag 1
#define reasonForDeletionAlertViewTag 2

////////////////////
//Tab bar item indexes
#define tabBarItemMyPostsIndex 0
#define tabBarItemMyInterestedPostsIndex 1

// Messages
// Error messages
#define errorRetrievingUserPosts @"Error retrieving user posts %@"

@interface MyProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *postsTabBar;

@property (weak, nonatomic) IBOutlet UITableView *myPostsTableView;
@property NSArray *myPosts;
@property PFQuery *myPostsQuery;

@property (weak, nonatomic) IBOutlet UITableView *myInterestedPostsTableView;
@property NSArray *myInterestedPosts;
@property PFQuery *myInterestedPostsQuery;

@end

@implementation MyProfileViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];

//	self.parseClassName = [Post parseClassName];

//	self.pullToRefreshEnabled = YES;
//	self.paginationEnabled = YES;
//	self.objectsPerPage = 5;
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	// myPosts query
	self.myPostsQuery = [PFQuery queryWithClassName:[Post parseClassName]];
	// get posts from current user
	[self.myPostsQuery whereKey:@"user" equalTo:[User currentUser]];
	// get the unresolved posts
	[self.myPostsQuery whereKey:@"resolved" equalTo:[NSNumber numberWithBool:NO]];
	// order them by date
	[self.myPostsQuery orderByDescending:@"createdAt"];
	// include user in the query
	[self.myPostsQuery includeKey:@"user"];



}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// select my posts table view
	self.postsTabBar.selectedItem = self.postsTabBar.items[0];
	[self queryMyPosts];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

}

- (void)queryMyPosts
{
	[self cancelQueries];
	[Utils hideSpinner];

	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:NO];
	[self.myPostsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		[Utils hideSpinner];
		if (!error) {
			self.myPosts = objects;
			if (self.myPosts.count > 0) {
				[self.myPostsTableView reloadData];
			}
//			else {
//				[Utils showAlertViewWithMessage:errorNoPostsNearbyMessage];
//			}

		} else {
			NSLog(@"Unable to retrieve user posts %@ %@", error, error.localizedDescription);
			[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorRetrievingUserPosts, error.localizedDescription]];
		}
	}];
}

- (void)cancelQueries
{
	// cancel previous queries
	if (self.myPostsQuery != nil) {
		[self.myPostsQuery cancel];
	}
	if (self.myInterestedPostsQuery != nil) {
		[self.myInterestedPostsQuery cancel];
	}
}

#pragma mark - UITabBar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	// tapped on my posts
	if ([item isEqual:tabBar.items[tabBarItemMyPostsIndex]]) {
		//TODO: show my posts tableview
		self.myPostsTableView.hidden = NO;
		self.myInterestedPostsTableView.hidden = YES;

		// query my posts only if there are no posts on self.myPosts
		if (self.myPosts.count == 0) {
			[self queryMyPosts];
		}
	}
	// tapped on my interested posts
	else if ([item isEqual:tabBar.items[tabBarItemMyInterestedPostsIndex]]) {
		// TODO: show my interested posts tableview
		self.myPostsTableView.hidden = YES;
		self.myInterestedPostsTableView.hidden = NO;
	}
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([tableView isEqual:self.myPostsTableView]) {
		return self.myPosts.count;
	} else if ([tableView isEqual:self.myInterestedPostsTableView]) {
		return self.myInterestedPosts.count;
	}

	return 0;
}

- (FeedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FeedTableViewCell *cell = (FeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier];

	if ([tableView isEqual:self.myPostsTableView]) {
		[cell layoutCellViewWithPost:self.myPosts[indexPath.row]];
	} else if ([tableView isEqual:self.myInterestedPostsTableView]) {
		[cell layoutCellViewWithPost:self.myInterestedPosts[indexPath.row]];
	}

	return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		UIAlertView *alertView = [Utils showAlertViewWithMessage:postDeletionConfirmationMessage
														   title:nil
													buttonTitles:@[@"Cancel", @"OK"]
														delegate:self];
		alertView.tag = postDeletionAlertViewTag;
		alertView.cancelButtonIndex = 0;
    }
}


#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return FeedCellHeight;
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// first alert view (deletion confirmation)
	if (alertView.tag == postDeletionAlertViewTag) {
		if (buttonIndex != alertView.cancelButtonIndex) {
			[self showReasonForDeletionAlertView];
		} else {
			// put cell in non-editing mode
			for (UITableViewCell *cell in self.myPostsTableView.visibleCells) {
				if (cell.isEditing) {
					[cell setEditing:NO animated:YES];
					NSIndexPath *cellIndexPath = [self.myPostsTableView indexPathForCell:cell];
					[self.myPostsTableView reloadRowsAtIndexPaths:@[cellIndexPath]
										  withRowAnimation:UITableViewRowAnimationRight];
					NSLog(@"cancel deletion");
					break;
				}
			}
		}
	}
	// second alert view (reason for deletion)
	else if (alertView.tag == reasonForDeletionAlertViewTag) {
		UITextField *reasonTextField = [alertView textFieldAtIndex:0];
		// if no reason, show the alertView again
		if (reasonTextField.text.length == 0 || [reasonTextField.text isEqualToString:@""]) {
			[self showReasonForDeletionAlertView];
		} else {
			[self deletePostWithReason:reasonTextField.text];
		}
	}
}

#pragma mark - Helper methods

- (void)deletePostWithReason:(NSString *)reason
{
	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];

	// get the index path of the currently editing cell
	NSIndexPath *indexPath;
	for (UITableViewCell *cell in self.myPostsTableView.visibleCells) {
		if (cell.isEditing) {
			indexPath = [self.myPostsTableView indexPathForCell:cell];
			break;
		}
	}

	if (indexPath) {
		Post *postToDelete = self.myPosts[indexPath.row];
		//	logical deletion
		postToDelete.resolved = true;
		postToDelete.resolutionText = reason;
		[postToDelete saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			[Utils hideSpinner];
			if (!error) {
				if (succeeded) {
					NSLog(@"Logically deleted user post");
					[self queryMyPosts];
				}
			} else {
				NSLog(@"Unable to delete user post %@ %@", error, error.localizedDescription);
				[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorDeletingPostMessage, error.localizedDescription]];
			}
		}];
	}
}

- (void)showReasonForDeletionAlertView
{
	UIAlertView *reasonForDeletionAlertView = [UIAlertView new];
	reasonForDeletionAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	reasonForDeletionAlertView.delegate = self;
	reasonForDeletionAlertView.tag = reasonForDeletionAlertViewTag;
	reasonForDeletionAlertView.message = reasonForDeletionMessage;
	[reasonForDeletionAlertView addButtonWithTitle:@"OK"];
	[reasonForDeletionAlertView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showModifyUserDataScreenSegue]) {
		SignupViewController *modifyUserDataVC = (SignupViewController *)segue.destinationViewController;
		modifyUserDataVC.hidesBottomBarWhenPushed = YES;
	}
}
*/

@end
