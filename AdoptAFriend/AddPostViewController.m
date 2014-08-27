//
//  AddPostViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/25/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "AddPostViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddPostLocationViewController.h"

// Segues
// show fullscreen map
#define showMapScreenSegue @"showMapScreenSegue"

#define TakePhotoButtonIndex 0
#define ChoosePhotoButtonIndex 1

@interface AddPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property UIButton *tappedButton;

@end

@implementation AddPostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == TakePhotoButtonIndex) {
		NSLog(@"open camera");
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[self shouldStartCameraController];
		} else {
			UIAlertView *alertView = [UIAlertView new];
			alertView.delegate = self;
			alertView.message = @"No camera available";
			[alertView addButtonWithTitle:@"OK"];
			[alertView show];
		}
	} else if (buttonIndex == ChoosePhotoButtonIndex) {
		NSLog(@"open roll");
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
			[self shouldStartPhotoLibraryPickerController];
		} else {
			UIAlertView *alertView = [UIAlertView new];
			alertView.delegate = self;
			alertView.message = @"No photo roll";
			[alertView addButtonWithTitle:@"OK"];
			[alertView show];
		}
	} else {
		NSLog(@"cancel");
		self.tabBarController.selectedIndex = 0;
	}
}

#pragma mark - photo choosing options

- (BOOL)shouldStartCameraController {

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];

    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;

    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];

    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController {


    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];

    cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];

    return YES;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tappedButton setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
}

#pragma mark - IBActions

- (IBAction)onPostButtonTapped:(UIButton *)sender
{
    UIImage *defaultImage = [UIImage imageNamed:@"dog-256"];

    if ([self.firstImageButton imageForState:UIControlStateNormal] == defaultImage) {
        NSLog(@"The button has no image assigned");
    }
}

- (IBAction)onImageButtonTapped:(UIButton *)sender
{
    self.tappedButton = sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
//	[actionSheet showInView:self.tabBarController.view];
    [actionSheet showInView:self.view];

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

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
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

@end
