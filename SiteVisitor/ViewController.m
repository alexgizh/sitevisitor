//
//  ViewController.m
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "ViewController.h"
#import "SitePhoto.h"
#import "SitePhotoCell.h"
#import "TagViewController.h"
#import "AppDelegate.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet __weak UICollectionView *photosView;
    IBOutlet __weak UIImageView *backgroundImage;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sitePhotos = [NSMutableArray new];
    photosView.dataSource = self;
    photosView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [photosView reloadData];
}

- (IBAction)addPhotos:(id)sender
{
    [self performSegueWithIdentifier:@"showCamera" sender:nil];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_sitePhotos.count == 0) {
        return 1;
    }
    return _sitePhotos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sitePhotos.count == 0) {
        UICollectionViewCell *cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:@"NoPhotosCell" forIndexPath:indexPath];
        return cell;
    }
    SitePhotoCell *cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:@"SitePhotoCell" forIndexPath:indexPath];
    [cell setupWithSitePhoto:[_sitePhotos objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sitePhotos.count == 0) {
        [self addPhotos:nil];
        return;
    }
    [backgroundImage setImage:[(SitePhoto *)[_sitePhotos objectAtIndex:indexPath.row] photo]];
}

@end
