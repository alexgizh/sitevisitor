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
#import "MBProgressHUD.h"
#import "Defaults.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet __weak UICollectionView *photosView;
    IBOutlet __weak UIImageView *backgroundImage;
    int notUploadedCounter;
    MBProgressHUD *hud;
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
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Uploading ";
    hud.hidden = YES;
}

- (IBAction)addPhotos:(id)sender
{
    [self performSegueWithIdentifier:@"showCamera" sender:nil];
}

- (IBAction)uploadPhotos:(id)sender
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Please enter Property unit ID"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   UITextField *textField = alert.textFields[0];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       self->hud.hidden = NO;
                                                       [self calculateStartIndex];
                                                       [self uploadPhotosWith:textField.text];
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

- (void)uploadPhotosWith:(NSString *)propertyUnitID
{
    static int counter = 0;
    static int photosUploaded = 0;
    if (_sitePhotos.count > counter) {
        SitePhoto *sitePhoto = [_sitePhotos objectAtIndex:counter];
        counter += 1;
        if (!sitePhoto.isUploaded) {
            int photoNameNumber = [[[Defaults standard] uploadCounter] intValue] + 1;
            [[APIClient sharedClient] uploadImage:sitePhoto.photo path:[NSString stringWithFormat:@"dimensions/feature/f2/ws/property-units/%@/documents", propertyUnitID] params:@{[NSString stringWithFormat:@"IMG_%04d.jpg", photoNameNumber] : @"file"} success:^(id responseObject) {
                [[Defaults standard] setUploadCounter:[NSNumber numberWithInt:photoNameNumber]];
                photosUploaded += 1;
                sitePhoto.isUploaded = YES;
                [self uploadPhotosWith:propertyUnitID];
                self->hud.label.text = [NSString stringWithFormat:@"Uploading %d of %d", photosUploaded, self->notUploadedCounter];
            } failure:^(NSError *error) {
                NSLog(@"Image Not uploaded %@", error.localizedDescription);
            }];
        } else {
            [self uploadPhotosWith:propertyUnitID];
        }
    } else {
        counter = 0;
        photosUploaded = 0;
        [self reloadCollectionView];
    }
}

- (int)calculateStartIndex
{
    NSPredicate *isUploadedPredicate = [NSPredicate predicateWithFormat:@"isUploaded == 0"];
    notUploadedCounter = (int)[[_sitePhotos filteredArrayUsingPredicate:isUploadedPredicate] count];

    return notUploadedCounter;
}

- (void)reloadCollectionView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->photosView reloadData];
        self->hud.hidden = YES;
    });
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
