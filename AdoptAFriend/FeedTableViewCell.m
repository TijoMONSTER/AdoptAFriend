//
//  FeedTableViewCell.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "FeedTableViewCell.h"

@interface FeedTableViewCell ()

@property (weak, nonatomic) IBOutlet PFImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation FeedTableViewCell

- (void)layoutCellViewWithPost:(Post *)post
{
	NSString *userFullName = [NSString stringWithFormat:@"%@ %@", post.user.name, post.user.lastName];
	self.usernameLabel.text = userFullName;

	self.descriptionLabel.text = post.descriptionText;
	// set the placeholder image
	self.mainImageView.image = [UIImage imageNamed:FeedCellPlaceHolderImage];
	// set the image that will be downloaded in background
	self.mainImageView.file = post.image1;
	// download the image
	[self.mainImageView loadInBackground];
}

- (void)layoutCellViewWithDescriptionTextOnly:(NSString *)descriptionText
{
	self.usernameLabel.text = nil;
	self.mainImageView.image = nil;
	self.descriptionLabel.text = descriptionText;
	self.accessoryType = UITableViewCellAccessoryNone;
}

@end
