//
//  TagCategory.m
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "TagCategory.h"
#import "Tag.h"

@interface TagCategory ()

@end

@implementation TagCategory

- (id)copy
{
    TagCategory *tagCategory = [TagCategory new];
    tagCategory.name = [self.name copy];
    NSMutableArray *tags = [NSMutableArray new];
    for (Tag *tag in self.tags) {
        Tag *copyTag = [tag copy];
        [tags addObject:copyTag];
    }
    tagCategory.tags = tags;
    
    return tagCategory;
}

@end
