//
//  SitePhotoCell.m
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "SitePhotoCell.h"

@interface SitePhotoCell ()
{
    IBOutlet __weak UIView *selectionView;
    IBOutlet __weak UIImageView *tagImage;
    IBOutlet __weak UIView *tagContainer;
}
@end

@implementation SitePhotoCell

- (void)setSelected:(BOOL)selected
{
    selectionView.hidden = !selected;
}

- (void)setupWithSitePhoto:(SitePhoto *)sitePhoto
{
    _photoView.image = sitePhoto.photo;
    tagContainer.backgroundColor = sitePhoto.tag.color;
    tagImage.image = [UIImage imageNamed:sitePhoto.tag.name];
}

@end
