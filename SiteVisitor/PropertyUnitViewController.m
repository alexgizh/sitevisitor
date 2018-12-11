#import "PropertyUnitViewController.h"
#import "SitePhoto.h"
#import "APIClient.h"
#import "MBProgressHUD.h"
#import "Defaults.h"
#import "SitePhotoCell.h"
#import "PropertyUnit.h"

@interface PropertyUnitViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    int notUploadedCounter;
    MBProgressHUD *hud;
    IBOutlet __weak UICollectionView *photosView;
    IBOutlet __weak UILabel *propertyUnitDetailsLabel;
    IBOutlet __weak UIBarButtonItem *rightBarButtonItem;
    PropertyUnit *propertyUnit;
}

@end

@implementation PropertyUnitViewController
@synthesize propertyUnitID;

- (void)viewDidLoad {
    [super viewDidLoad];
    photosView.dataSource = self;
    photosView.delegate = self;

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Uploading ";
    hud.hidden = YES;
    [self getPropertyUnitInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [photosView reloadData];
    [self setUpRightBarButtonItem];
}

- (IBAction)uploadTapped:(id)sender
{
    self->hud.hidden = NO;
    [self calculateNotUploaded];
    [self uploadPhoto];
}

- (IBAction)cancelTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getPropertyUnitInfo
{
    [[APIClient sharedClient] getWithPath:[NSString stringWithFormat:@"dimensions/feature/f2/ws/property-units/%@", propertyUnitID] params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = nil;
        id jsonDict = [NSJSONSerialization JSONObjectWithData: responseObject options: NSJSONReadingMutableContainers error: &error];
        if (!error){
            PropertyUnit *propertyUnit = [PropertyUnit new];
            [propertyUnit setPropertyUnitDetails:jsonDict];
            self->propertyUnitDetailsLabel.text = [NSString stringWithFormat:@"ID = %@\nOwner = %@\nProperty Name = %@\nOwnership = %@\nProperty Type = %@\nAddress = %@",
                                                   propertyUnit.propertyUnitID,
                                                   propertyUnit.owner,
                                                   propertyUnit.propertyUnitName,
                                                   propertyUnit.ownership,
                                                   propertyUnit.propertyUnitType,
                                                   propertyUnit.fullLocation];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Check your property unit ID" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];

    }];
}

- (void)setUpRightBarButtonItem
{
    [self calculateNotUploaded];
    rightBarButtonItem.enabled = notUploadedCounter > 0;
}
#pragma mark - Upload Photos

- (void)uploadPhoto
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
                [self uploadPhoto];
                self->hud.label.text = [NSString stringWithFormat:@"Uploading %d of %d", photosUploaded, self->notUploadedCounter];
            } failure:^(NSError *error) {
                NSLog(@"Image Not uploaded %@", error.localizedDescription);
            }];
        } else {
            [self uploadPhoto];
        }
    } else {
        counter = 0;
        photosUploaded = 0;
        [self reloadCollectionView];
        [self setUpRightBarButtonItem];
    }
}

- (void)calculateNotUploaded
{
    NSPredicate *isUploadedPredicate = [NSPredicate predicateWithFormat:@"isUploaded == 0"];
    notUploadedCounter = (int)[[_sitePhotos filteredArrayUsingPredicate:isUploadedPredicate] count];
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
    return _sitePhotos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SitePhotoCell *cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:@"SitePhotoCell" forIndexPath:indexPath];
    [cell setupWithSitePhoto:[_sitePhotos objectAtIndex:indexPath.row]];
    return cell;
}

@end
