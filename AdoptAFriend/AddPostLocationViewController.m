//
//  AddPostLocationViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "AddPostLocationViewController.h"
#import <MapKit/MapKit.h>

@interface AddPostLocationViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation AddPostLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationItem.hidesBackButton = YES;
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
#warning Incomplete method implementation.
	return nil;
}

#pragma mark - IBActions

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender
{
	// TODO: save the location
	[self.navigationController popViewControllerAnimated:YES];
}

@end
