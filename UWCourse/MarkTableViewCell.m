//
//  MarkTableViewCell.m
//  UWCourse
//
//  Created by Jack Xu on 3/24/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "MarkTableViewCell.h"

@implementation MarkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
