//
//  SitePhotoCell.h
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SitePhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface SitePhotoCell : UICollectionViewCell

@property (nonatomic, strong) SitePhoto *sitePhoto;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;

- (void)setupWithSitePhoto:(SitePhoto *)sitePhoto;

@end

NS_ASSUME_NONNULL_END
