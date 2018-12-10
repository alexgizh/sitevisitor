//
//  SitePhotoTag.h
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tag : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
