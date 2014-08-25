//
//  AddPostViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "AddPostViewController.h"
#import <MapKit/MapKit.h>

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
@end
