//
//  ScheduleTableCellTableViewCell.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/18/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ScheduleTableCellTableViewCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UILabel *countDown;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *duration;
@property (strong, nonatomic) IBOutlet UILabel *notes;

@end
