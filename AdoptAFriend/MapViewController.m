//
//  MapViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "MapViewController.h"
#import "PostDetailsViewController.h"
#import <MapKit/MapKit.h>

// Segues
// show post details screen
#define showPostDetailsScreenSegue @"showPostDetailsScreenSegue"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// TODO: set annotations
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
#warning Incomplete method implementation.
	return nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showPostDetailsScreenSegue]) {
//		PostDetailsViewController *postDetailsVC = (PostDetailsViewController *)segue.destinationViewController;
	}
}


@end
