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
    
    // Outdoor
    
    Tag *construction = [Tag new];
    construction.name = @"Construction";
    construction.color = darkBlue;
    
    Tag *facade = [Tag new];
    facade.name = @"Facade";
    facade.color = darkBlue;

    Tag *roof = [Tag new];
    roof.name = @"Roof";
    roof.color = darkBlue;

    Tag *outside = [Tag new];
    outside.name = @"Outside space";
    outside.color = darkBlue;

    TagCategory *outdoorCategory = [TagCategory new];
    outdoorCategory.name = @"Outdoor";
    outdoorCategory.tags = @[construction, facade, roof, outside];
    
    // Indoor
    
    Tag *bathroom = [Tag new];
    bathroom.name = @"Bathroom";
    bathroom.color = darkBlue;
    
    Tag *kitchen = [Tag new];
    kitchen.name = @"Kitchen";
    kitchen.color = darkBlue;
    
    Tag *finishing = [Tag new];
    finishing.name = @"Finishing";
    finishing.color = darkBlue;
    
    Tag *misc = [Tag new];
    misc.name = @"Misc";
    misc.color = darkBlue;

    TagCategory *indoorCategory = [TagCategory new];
    indoorCategory.name = @"Indoor";
    indoorCategory.tags = @[bathroom, kitchen, finishing, misc];

    // Installations
    
    Tag *electricity = [Tag new];
    electricity.name = @"Electricity";
    electricity.color = darkBlue;
    
    Tag *heating = [Tag new];
    heating.name = @"Heating";
    heating.color = darkBlue;
    
    Tag *sanitary = [Tag new];
    sanitary.name = @"Sanitary line";
    sanitary.color = darkBlue;
    
    Tag *ventilation = [Tag new];
    ventilation.name = @"Ventilation";
    ventilation.color = darkBlue;

    TagCategory *installationsCategory = [TagCategory new];
    installationsCategory.name = @"Technik";
    installationsCategory.tags = @[electricity, heating, sanitary, ventilation];
    
    // Shared
    
    Tag *window = [Tag new];
    window.name = @"Window";
    window.color = lightBlue;
    
    Tag *stairs = [Tag new];
    stairs.name = @"Stairs";
    stairs.color = lightBlue;
    
    Tag *transport = [Tag new];
    transport.name = @"Transport";
    transport.color = lightBlue;
    
    Tag *parking = [Tag new];
    parking.name = @"Parking";
    parking.color = lightBlue;
    
    TagCategory *sharedCategory = [TagCategory new];
    sharedCategory.tags = @[window, stairs, transport, parking];
    
    tagCategories = @[sharedCategory, indoorCategory, installationsCategory, outdoorCategory];
    
    Building *building1 = [Building new];
    building1.name = @"Main building";
    building1.tagCategories = tagCategories;
    
    Building *building2 = [Building new];
    building2.name = @"Building Nr.2";
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
