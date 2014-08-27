//
//  User.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "User.h"
// Import this header to let User know that PFObject privately provides most
// of the methods for PFSubclassing.
#import <Parse/PFObject+Subclass.h>

@implementation User

@dynamic name;
@dynamic lastName;
@dynamic genre;

+ (void)load
{
	[self registerSubclass];
}

@end
