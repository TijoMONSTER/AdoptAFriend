//
//  MyPostsViewController.m
//  AdoptAFriend
//
//  Created by Efrén Reyes Torres on 9/9/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "MyPostsViewController.h"
#import "Utils.h"

//Tab bar item indexes
#define tabBarItemGiveInAdoption 0
#define tabBarItemDeletePost 1

@interface MyPostsViewController () <UITabBarDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITabBar *postOptionsTabBar;
@property (weak, nonatomic) IBOutlet UIScrollView *giveInAdoptionScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *deletePostScrollView;
@property (weak, nonatomic) IBOutlet UITextView *deletionCommentsTextView;
@property (weak, nonatomic) IBOutlet UITextView *adoptionCommentsTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *interestedUsersPicker;
@property NSArray *interestedUsers;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation MyPostsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interestedUsers = [NSArray array];
    self.deletePostScrollView.hidden = YES;
    self.submitButton.hidden = YES;
    self.giveInAdoptionScrollView.scrollEnabled = YES;
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.giveInAdoptionScrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    [self.giveInAdoptionScrollView setContentSize:(CGSizeMake(320, 390))];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.postOptionsTabBar.selectedItem = self.postOptionsTabBar.items[tabBarItemGiveInAdoption];
    PFRelation *relation = [self.post relationForKey:@"intrested"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            self.interestedUsers = objects;
            self.submitButton.hidden = NO;
            [self.interestedUsersPicker reloadAllComponents];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)onSubmitButtonPressed:(id)sender
{
    NSLog(@"Submit pressed");
    [self.adoptionCommentsTextView resignFirstResponder];
    if ([self.adoptionCommentsTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0) {
        [Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];
        self.post.resolved = YES;
        self.post.adopter = [self.interestedUsers objectAtIndex:[self.interestedUsersPicker selectedRowInComponent:0]];
        self.post.resolutionText = self.adoptionCommentsTextView.text;
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [Utils hideSpinner];
            [Utils showAlertViewWithMessage:@"Thank you so much for being part of this noble cause!!!"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [Utils showAlertViewWithMessage:@"Please give us a comment"];
    }
}

- (IBAction)onDeleteButtonPressed:(id)sender
{
    NSLog(@"Delete pressed");
    [self.deletionCommentsTextView resignFirstResponder];
    if ([self.deletionCommentsTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0) {
        [Utils showSpinnerOnView:self.view withCenter:self.view.center ignoreInteractionEvents:YES];
        self.post.resolved = YES;
        self.post.resolutionText = self.deletionCommentsTextView.text;
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [Utils hideSpinner];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [Utils showAlertViewWithMessage:@"Please give us a comment"];
    }
}

//#pragma mark - UIPickerViewDataSource
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    NSLog(@"Selected row %d", row);
//}

#pragma mark - UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.interestedUsers.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    User *user = [self.interestedUsers objectAtIndex:row];
    NSString *name = [NSString stringWithFormat:@"%@ %@", user.name, user.lastName];
    return name;
}

#pragma mark - Navigation
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item isEqual:self.postOptionsTabBar.items[tabBarItemDeletePost]]) {
        self.giveInAdoptionScrollView.hidden = YES;
        self.deletePostScrollView.hidden = NO;
    } else {
        self.deletePostScrollView.hidden = YES;
        self.giveInAdoptionScrollView.hidden = NO;
    }
}

@end
