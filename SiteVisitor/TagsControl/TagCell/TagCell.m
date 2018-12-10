//
//  TagCell.m
//  SiteVisitor
//
//  Created by Aleksandar Gizarovski on 09.11.18.
//  Copyright © 2018 Netcetera. All rights reserved.
//

#import "TagCell.h"

@interface TagCell ()
{
    IBOutlet __weak UIView *containerView;
    IBOutlet __weak UIImageView *tagImageView;
    IBOutlet __weak UIImageView *checkmarkView;
    IBOutlet __weak UILabel *tagNameLabel;
}
@end

@implementation TagCell

- (void)setupWithTag:(Tag *)tag selected:(BOOL)selected;
{
    containerView.backgroundColor = tag.color;
    tagImageView.image = [UIImage imageNamed:tag.name];
    checkmarkView.hidden = !selected;
    tagNameLabel.text = tag.name;
}

@end
