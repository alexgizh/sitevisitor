//
//  TagsControl.h
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Site.h"
#import "SitePhoto.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TagsControlDelegate
- (void)didSelectTag:(Tag *)tag;
@end

@interface TagsControl : UIView

@property (nonatomic, weak) id<TagsControlDelegate> delegate;

- (void)setupWithSite:(Site *)site tagCategories:(NSArray *)tagCategories andSitePhotos:(NSArray *)sitePhotos;
- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
