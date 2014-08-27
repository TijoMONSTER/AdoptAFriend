//
//  AddPostLocationViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "AddPostLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddPostLocationViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@end

@implementation AddPostLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationItem.hidesBackButton = YES;
    if (self.locationManager.location.coordinate.latitude != 0 && self.locationManager.location.coordinate.longitude != 0) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.locationManager.location.coordinate;
        mapRegion.span.latitudeDelta = 0.008;
        mapRegion.span.longitudeDelta = 0.008;

        [self.mapView setRegion:mapRegion animated: YES];
    }
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	return nil;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.008;
    mapRegion.span.longitudeDelta = 0.008;

    [mapView setRegion:mapRegion animated: YES];
}

#pragma mark - IBActions

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender
{
	// TODO: save the location
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender
{
	NSLog(@"on long press");
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

@end
