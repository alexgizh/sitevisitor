//
//  SitePhotoTag.m
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "Tag.h"

@interface Tag ()

@end

@implementation Tag

- (BOOL)isEqual:(id)object
{
    Tag *otherTag = (Tag *)object;
    return [self.name isEqualToString:otherTag.name];
}

- (id)copy
{
    Tag *tag = [Tag new];
    tag.name = [self.name copy];
    tag.color = [self.color copy];
    return tag;
}

@end
