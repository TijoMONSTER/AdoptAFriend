//
//  FeedTableViewCell.h
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : PFTableViewCell

- (void)layoutCellViewWithPost:(Post *)post;
- (void)layoutCellViewWithDescriptionTextOnly:(NSString *)descriptionText;

@end
