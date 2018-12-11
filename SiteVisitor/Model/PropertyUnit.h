//
//  PropertyUnit.h
//  SiteVisitor
//
//  Created by Riste Stojchevski on 12/11/18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertyUnit : NSObject

@property (nonatomic, strong) NSString *propertyUnitID;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *propertyUnitName;
@property (nonatomic, strong) NSString *ownership;
@property (nonatomic, strong) NSString *propertyUnitType;
@property (nonatomic, strong) NSString *fullLocation;

- (void)setPropertyUnitDetails:(NSDictionary*)propertyUnit;

@end

NS_ASSUME_NONNULL_END
