//
//  ScheduleTableCellTableViewCell.m
//  UWaterloo
//
//  Created by Jack Zhang on 7/18/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "ScheduleTableCellTableViewCell.h"

@implementation ScheduleTableCellTableViewCell
@synthesize courseName=_courseName;
@synthesize countDown=_countDown;
@synthesize Date=_Date;
@synthesize location=_location;
@synthesize unitLabel=_unitLabel;
@synthesize duration=_duration;
@synthesize time=_time;
@synthesize notes=_notes;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView clipsToBounds];
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

- (IBAction)edit:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    [self.window setRootViewController:initViewController];
}
@end
