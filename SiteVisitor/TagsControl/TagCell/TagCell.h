//
//  TagCell.h
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

NS_ASSUME_NONNULL_BEGIN

@interface TagCell : UICollectionViewCell

- (void)setupWithTag:(Tag *)tag selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
