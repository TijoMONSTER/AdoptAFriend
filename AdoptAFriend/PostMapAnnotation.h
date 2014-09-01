//
//  PostMapAnnotation.h
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/29/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import <MapKit/MapKit.h>

@class PostMapAnnotation;
@protocol PostMapAnnotationDelegate

- (void)didFinishDownloadingImage:(UIImage *)image forAnnotation:(PostMapAnnotation *)annotation;

@end


@interface PostMapAnnotation : MKPointAnnotation

@property (weak, nonatomic) id<PostMapAnnotationDelegate> delegate;
@property Post *post;

- (void)setAnnotationData;

@end
