//
//  PostMapAnnotation.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/29/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "PostMapAnnotation.h"
#import "Utils.h"

// Messages
// Error messages
#define errorDownloadingImageMessage @"Error downloading post image: %@"

@implementation PostMapAnnotation

- (void)setAnnotationData
{
	self.coordinate = CLLocationCoordinate2DMake(self.post.location.latitude, self.post.location.longitude);
	self.title = [NSString stringWithFormat:@"%@ %@", self.post.user.name, self.post.user.lastName];
	self.subtitle = self.post.descriptionText;

	[self.post.image1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		if (!error) {
			[self.delegate didFinishDownloadingImage:[UIImage imageWithData:data] forAnnotation:self];
		} else {
			NSLog(@"Unable to download post image on map %@ %@", error, error.localizedDescription);
			[Utils showAlertViewWithMessage: [NSString stringWithFormat:errorDownloadingImageMessage, error.localizedDescription]];
		}
	}];
}

@end
