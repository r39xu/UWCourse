//
//  ScheduleTableViewController.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ScheduleTableViewController : UITableViewController <SWTableViewCellDelegate>
{int selectedIndex;}
@property (strong) NSMutableArray *courses;
@property (nonatomic) NSIndexPath* selectedRow;
@end
