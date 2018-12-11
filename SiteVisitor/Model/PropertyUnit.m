//
//  PropertyUnit.m
//  SiteVisitor
//
//  Created by Riste Stojchevski on 12/11/18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "PropertyUnit.h"

@implementation PropertyUnit

- (void)setPropertyUnitDetails:(NSDictionary*)propertyUnit {
    
    self.propertyUnitID = propertyUnit[@"id"] == (id)[NSNull null] ? @"" : propertyUnit[@"id"];
    self.owner = propertyUnit[@"owner"] == (id)[NSNull null] ? @"" : propertyUnit[@"owner"];
    self.propertyUnitName = propertyUnit[@"propertyUnitName"] == (id)[NSNull null] ? @"" : propertyUnit[@"propertyUnitName"];
    self.ownership = propertyUnit[@"ownership"] == (id)[NSNull null] ? @"" : propertyUnit[@"ownership"];
    self.propertyUnitType = propertyUnit[@"propertyUnitType"] == (id)[NSNull null] ? @"" : propertyUnit[@"propertyUnitType"];
    self.fullLocation = [NSString stringWithFormat:@"%@ %@ %@", [[propertyUnit[@"location"] objectForKey:@"address"] objectForKey:@"addressLine1"],
                                                                [[propertyUnit[@"location"] objectForKey:@"address"] objectForKey:@"place"],
                                                                [[propertyUnit[@"location"] objectForKey:@"address"] objectForKey:@"countryIsoCode"]];
}

@end
