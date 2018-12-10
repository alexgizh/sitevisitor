//
//  SitePhoto.h
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tag.h"

NS_ASSUME_NONNULL_BEGIN

@interface SitePhoto : NSObject

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong, nullable) Tag *tag;

@end

NS_ASSUME_NONNULL_END
