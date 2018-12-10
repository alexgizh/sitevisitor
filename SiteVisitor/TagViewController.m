//
//  TagViewController.m
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 16.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "TagViewController.h"
#import "TagsControl.h"
#import "Site.h"
#import "Building.h"
#import "TagCategory.h"
#import "Tag.h"
#import "SitePhoto.h"
#import "SitePhotoCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ImageZoomViewer.h"

@interface TagViewController () <UICollectionViewDataSource, UICollectionViewDelegate, TagsControlDelegate, ImageZoomViewerDelegate>
{
    IBOutlet __weak UICollectionView *photosView;
    TagsControl *tagsControl;
    NSArray *tagCategories;
    Site *site;
}
@end

@implementation TagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createModel];
    [self setupUI];
    [self.navigationItem setHidesBackButton:YES];
    [tagsControl setupWithSite:site tagCategories:tagCategories andSitePhotos:_sitePhotos];
    [tagsControl show];
}

- (void)createModel
{
    UIColor *darkBlue = [UIColor colorWithRed:58/255.0 green:48/255.0 blue:83/255.0 alpha:1.0];
    UIColor *lightBlue = [UIColor colorWithRed:90/255.0 green:158/255.0 blue:213/255.0 alpha:1.0];
    
    Tag *tag1 = [Tag new];
    tag1.name = @"Shower";
    tag1.color = darkBlue;
    
    Tag *tag2 = [Tag new];
    tag2.name = @"Castle";
    tag2.color = darkBlue;
    
    Tag *tag3 = [Tag new];
    tag3.name = @"Barcode";
    tag3.color = darkBlue;
    
    Tag *tag4 = [Tag new];
    tag4.name = @"Coffee";
    tag4.color = darkBlue;
    
    Tag *tag5 = [Tag new];
    tag5.name = @"Castle";
    tag5.color = darkBlue;
    
    Tag *tag6 = [Tag new];
    tag6.name = @"Garden";
    tag6.color = darkBlue;
    
    Tag *tag7 = [Tag new];
    tag7.name = @"House";
    tag7.color = lightBlue;
    
    Tag *tag8 = [Tag new];
    tag8.name = @"Car";
    tag8.color = lightBlue;
    
    Tag *tag9 = [Tag new];
    tag9.name = @"Building";
    tag9.color = lightBlue;
    
    Tag *tag10 = [Tag new];
    tag10.name = @"Grid";
    tag10.color = lightBlue;
    
    TagCategory *staticCategory = [TagCategory new];
    staticCategory.tags = @[tag7,tag8,tag9,tag10];
    
    TagCategory *innen = [TagCategory new];
    innen.name = @"Innen";
    innen.tags = @[tag1,tag2,tag3,tag4];
    
    TagCategory *technik = [TagCategory new];
    technik.name = @"Technik";
    technik.tags = innen.tags;
    
    TagCategory *aussen = [TagCategory new];
    aussen.name = @"Aussen";
    aussen.tags = innen.tags;
    
    tagCategories = @[staticCategory,innen,technik,aussen];
    
    Building *building1 = [Building new];
    building1.name = @"Hauptgebäude";
    building1.tagCategories = tagCategories;
    
    Building *building2 = [Building new];
    building2.name = @"Gebäude 2";
    building2.tagCategories = tagCategories;
    
    Building *building3 = [Building new];
    building3.tagCategories = tagCategories;
    
    NSArray *buildings = @[building1,building2,building3];
    
    site = [Site new];
    site.buildings = buildings;
}

- (void)setupUI
{
    photosView.dataSource = self;
    photosView.delegate = self;
    
    tagsControl = [TagsControl new];
    tagsControl.delegate = self;
    [self.view addSubview:tagsControl];
}

- (IBAction)doneTapped:(id)sender
{
    ViewController *rootVC = (ViewController *)[[(UINavigationController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] viewControllers] objectAtIndex:0];
    [[rootVC sitePhotos] addObjectsFromArray:_sitePhotos];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didSelectTag:(Tag *)tag
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    for (SitePhoto *photo in _sitePhotos) {
        photo.tag = tag;
    }
}

- (IBAction)cancelTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sitePhotos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SitePhotoCell *cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:@"SitePhotoCell" forIndexPath:indexPath];
    [cell setupWithSitePhoto:[_sitePhotos objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [tagsControl show];
    ImageZoomViewer *imageZoomViewer = [[ImageZoomViewer alloc]initWithBottomCollectionBorderColor:[UIColor blackColor]];
    imageZoomViewer.delegate = self;
    SitePhotoCell *cell = (SitePhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGPoint point = [self.view convertPoint:cell.photoView.frame.origin toView:appDelegate.window];
    CGRect animFrame = CGRectMake(point.x, point.y, cell.photoView.frame.size.width, cell.photoView.frame.size.height);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:animFrame];
    imgView.image = cell.photoView.image;
    
    [imageZoomViewer showWithPageIndex:indexPath.row andImagesCount:_sitePhotos.count withInitialImageView:imgView andAnimType:AnimationTypePop];
}

#pragma mark Image zoom viewer

- (void)initializeImageviewWithImages:(UIImageView *)imageview withIndexPath:(NSIndexPath *)indexPath withCollection:(int)collectionReference
{
    SitePhotoCell *cell = (SitePhotoCell *)[photosView cellForItemAtIndexPath:indexPath];
    imageview.image = cell.photoView.image;
}

@end
