//
//  User.h
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser <PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *lastName;
@property (retain) NSString *genre;
// email and password already exist as properties on PFUser

@end

