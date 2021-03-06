//
//  Building.h
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Building : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *tagCategories;

@end

NS_ASSUME_NONNULL_END
