//
//  Post.h
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/27/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

@interface Post : PFObject <PFSubclassing>

@property (retain) PFFile *image1;
@property (retain) PFFile *image2;
@property (retain) PFFile *image3;
@property (retain) PFGeoPoint *location;
@property (retain) NSString *description;
@property (retain) User *user;
@property (retain) User *adopter;
@property BOOL resolved;

+ (NSString *)parseClassName;

@end
