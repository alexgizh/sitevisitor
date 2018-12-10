//
//  CameraViewController.m
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 22.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "CameraViewController.h"
#import "TagViewController.h"
#import "BUKImagePickerController.h"
#import "SitePhoto.h"

@interface CameraViewController () <BUKImagePickerControllerDelegate>
{
    NSArray *photos;
}
@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    BUKImagePickerController *imagePickerController = [[BUKImagePickerController alloc] init];
    imagePickerController.mediaType = BUKImagePickerControllerMediaTypeImage;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = BUKImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsMultipleSelection = YES;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TagViewController *nextVC = (TagViewController *)[segue destinationViewController];
    [nextVC setSitePhotos:photos];
}

#pragma mark - BUKImagePickerControllerDelegate

- (void)buk_imagePickerController:(BUKImagePickerController *)imagePickerController didFinishPickingImages:(NSArray *)images
{
    NSMutableArray *array = [NSMutableArray new];
    for (UIImage *image in images) {
        SitePhoto *sitePhoto = [SitePhoto new];
        sitePhoto.tag = nil;
        sitePhoto.photo = image;
        [array addObject:sitePhoto];
    }
    photos = array;
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"showTag" sender:nil];
}

- (void)buk_imagePickerControllerDidCancel:(BUKImagePickerController *)imagePickerController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
