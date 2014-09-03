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
#define postDeletionConfirmationMessage @"Are you sure you want to delete this post?"
#define reasonForDeletionMessage @"Please tell us why are you deleting this post."
// Error messages
#define errorDeletingPostMessage @"Error deleting post: %@"

// AlertView tags
#define postDeletionAlertViewTag 1
#define reasonForDeletionAlertViewTag 2

@interface MyPostsViewController () <UIAlertViewDelegate>

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
//	if (self.objects.count == 0) {
//		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//	}

	// get posts from current user
	[query whereKey:@"user" equalTo:[User currentUser]];
	// get the unresolved posts
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

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// first alert view (deletion confirmation)
	if (alertView.tag == postDeletionAlertViewTag) {
		if (buttonIndex != alertView.cancelButtonIndex) {
			[self showReasonForDeletionAlertView];
		} else {
			// put cell in non-editing mode
			for (UITableViewCell *cell in self.tableView.visibleCells) {
				if (cell.isEditing) {
					[cell setEditing:NO animated:YES];
					[self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]]
										  withRowAnimation:UITableViewRowAnimationRight];
					NSLog(@"cancel deletion");
					break;
				}
			}
		}
	}
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
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//	if ([segue.identifier isEqualToString:showModifyUserDataScreenSegue]) {
//		SignupViewController *modifyUserDataVC = (SignupViewController *)segue.destinationViewController;
//		modifyUserDataVC.hidesBottomBarWhenPushed = YES;
//	}
//}

#pragma mark - Helper methods

- (void)deletePostWithReason:(NSString *)reason
{
	[Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];

	NSIndexPath *indexPath;
	for (UITableViewCell *cell in self.tableView.visibleCells) {
		if (cell.isEditing) {
			indexPath = [self.tableView indexPathForCell:cell];
			break;
		}
	}

	if (indexPath) {
		Post *postToDelete = self.objects[indexPath.row];
		//	logical deletion
		postToDelete.resolved = true;
		postToDelete.resolutionText = reason;
		[postToDelete saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			[Utils hideSpinner];
			if (!error) {
				if (succeeded) {
					NSLog(@"Logically deleted user post");
//					[self.queryForTable clearCachedResult];
					[self loadObjects];
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

@end
