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
#import "Post.h"
#import "Utils.h"

// Segues
// show fullscreen map
#define showMapScreenSegue @"showMapScreenSegue"

#define TakePhotoButtonIndex 0
#define ChoosePhotoButtonIndex 1
#define DefaultImageName @"dog-256"

#define errorSavingPostMessage @"Error saving your post, please try again"
#define successSavingPostMessage @"Your post was created successfully!"

@interface AddPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *firstImageButton;
@property (weak, nonatomic) IBOutlet UIButton *secondImageButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property MKPointAnnotation *dogLocation;

@property UIButton *tappedButton;
@property UIImage *defaultImage;

@end

@implementation AddPostViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateDogLocation:)
                                                     name:@"UpdateDogLocation"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultImage = [UIImage imageNamed:DefaultImageName];
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

- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender
{
    [self.descriptionTextView resignFirstResponder];
    NSString *errors = @"";
    UIImage *defaultImage = [UIImage imageNamed:DefaultImageName];

    if ([self.firstImageButton imageForState:UIControlStateNormal] == defaultImage &&
        [self.secondImageButton imageForState:UIControlStateNormal] == defaultImage &&
        [self.thirdImageButton imageForState:UIControlStateNormal] == defaultImage) {
        errors = @"You need to select at least 1 image.";
    }
    if (self.dogLocation == nil) {
        errors = [NSString stringWithFormat:@"%@ \n\nYou need to specify the place where the dog was found.", errors];
    }
    if ([self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        errors = [NSString stringWithFormat:@"%@ \n\nYou need to provide a description.", errors];
    }

    if (errors.length == 0) {
        [self savePost];
    } else {
        [Utils showAlertViewWithMessage:errors];
    }
}

- (void)savePost
{
    [Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];
    
    Post *newPost = [Post new];

    newPost.user = [User currentUser];
    if ([self.firstImageButton imageForState:UIControlStateNormal] != self.defaultImage) {
        newPost.image1 = [PFFile fileWithData:UIImagePNGRepresentation(self.firstImageButton.imageView.image)];
    }
    if ([self.secondImageButton imageForState:UIControlStateNormal] != self.defaultImage) {
        newPost.image2 = [PFFile fileWithData:UIImagePNGRepresentation(self.secondImageButton.imageView.image)];
    }
    if ([self.thirdImageButton imageForState:UIControlStateNormal] != self.defaultImage) {
        newPost.image3 = [PFFile fileWithData:UIImagePNGRepresentation(self.thirdImageButton.imageView.image)];
    }
    newPost.descriptionText = self.descriptionTextView.text;
    newPost.resolved = NO;
    newPost.location = [PFGeoPoint geoPointWithLatitude:self.dogLocation.coordinate.latitude longitude:self.dogLocation.coordinate.longitude];
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [Utils hideSpinner];
        if (!error) {
            [Utils showAlertViewWithMessage:successSavingPostMessage];
            self.firstImageButton.imageView.image = self.defaultImage;
            self.secondImageButton.imageView.image = self.defaultImage;
            self.thirdImageButton.imageView.image = self.defaultImage;
            self.descriptionTextView.text = @"";
            self.dogLocation = nil;
        } else {
            [Utils showAlertViewWithMessage:errorSavingPostMessage];
        }
    }];
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

#pragma mark - Notifications
-(void)updateDogLocation:(NSNotification *)notification {
    self.dogLocation = notification.object;

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:notification.object];
}

@end
