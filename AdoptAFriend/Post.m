//
//  Post.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/27/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "Post.h"
#import <Parse/PFObject+Subclass.h>

@implementation Post

@dynamic image1;
@dynamic image2;
@dynamic image3;
@dynamic location;
@dynamic description;
@dynamic user;
@dynamic adopter;
@dynamic resolved;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName
{
	return @"Post";
}

@end
