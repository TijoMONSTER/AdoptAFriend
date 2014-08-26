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

#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
	return 3;
}

- (FullscreenImagesCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FullscreenImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

	return cell;
}

@end