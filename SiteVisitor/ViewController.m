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
#import "APIClient.h"

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
//    [self getUserToken];
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

- (IBAction)uploadPhotos:(id)sender
{
    SitePhoto *sitePhoto = [_sitePhotos objectAtIndex:0];
    
    [[APIClient sharedClient] uploadImage:sitePhoto.photo path:@"dimensions/feature/f2/ws/property-units/101-121" params:@{@"file" : @""} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUserToken {
    [[APIClient sharedClient] getWithPath:@"dimensions/feature/f2/ws/property-units/121" params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData: responseObject options: NSJSONReadingMutableContainers error: &error];
        if (json) {
            NSLog(@"response = %@", json);
        } else {
            // Show error getting Token
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

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
