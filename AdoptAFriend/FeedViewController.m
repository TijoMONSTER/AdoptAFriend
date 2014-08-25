//
//  FeedViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"

// Cell identifier
#define FeedCellIdentifier @"Cell"

// Cell size
#define FeedCellHeight 100.0

// Segues
// show post details screen
#define showPostDetailsScreenSegue @"showPostDetailsScreenSegue"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return the cells' height
	return FeedCellHeight;
}

- (FeedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	// TODO: create method to set the cells main image view, username label and short description label

    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showPostDetailsScreenSegue]) {
		// send post data to postDetailsVC
	}
}


@end
