//
//  AddPostViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "AddPostViewController.h"
#import <MapKit/MapKit.h>
#import "AddPostLocationViewController.h"

// Segues
// show fullscreen map
#define showMapScreenSegue @"showMapScreenSegue"

@interface AddPostViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation AddPostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)onPostButtonTapped:(UIButton *)sender
{

}

- (IBAction)onImageButtonTapped:(UIButton *)sender
{

}

- (IBAction)onPreviewMapTapped:(UITapGestureRecognizer *)sender
{
	[self performSegueWithIdentifier:showMapScreenSegue sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:showMapScreenSegue]) {
		AddPostLocationViewController *addPostLocationVC = (AddPostLocationViewController *)segue.destinationViewController;
		addPostLocationVC.hidesBottomBarWhenPushed = YES;
	}
}

@end
