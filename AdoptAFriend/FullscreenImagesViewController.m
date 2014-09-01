//
//  FullscreenImagesViewController.m
//  AdoptAFriend
//
//  Created by Iván Mervich on 8/26/14.
//  Copyright (c) 2014 Iván Mervich - Efrén Reyes. All rights reserved.
//

#import "FullscreenImagesViewController.h"
#import "FullscreenImagesCollectionViewCell.h"

// Cell Identifier
#define CellIdentifier @"Cell"

@interface FullscreenImagesViewController ()

@end

@implementation FullscreenImagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// scroll to the selected image
	NSIndexPath *selectedImageIndexPath = [NSIndexPath indexPathForRow:self.selectedImageIndex inSection:0];
	[self.collectionView scrollToItemAtIndexPath:selectedImageIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.images.count;
}

- (FullscreenImagesCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FullscreenImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	UIImage *image = self.images[indexPath.row];
	[cell layoutCellViewWithImage:image];

	return cell;
}

@end