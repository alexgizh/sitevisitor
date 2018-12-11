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
#import "PropertyUnitViewController.h"

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
    if (_sitePhotos.count == 0) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Please take some picutres" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Please enter Property unit ID"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   UITextField *textField = alert.textFields[0];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [self performSegueWithIdentifier:@"showPropertyUnit" sender:textField];
                                                   });
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Property Unit ID";
        textField.text = @"101-121";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPropertyUnit"]) {
        UITextField *textField = (UITextField *)sender;
        PropertyUnitViewController *nextVC = (PropertyUnitViewController *)[segue destinationViewController];
        [nextVC setSitePhotos:_sitePhotos];
        [nextVC setPropertyUnitID:textField.text];
    }
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
