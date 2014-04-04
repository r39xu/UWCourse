//
//  MarkTableViewCell.h
//  UWCourse
//
//  Created by Jack Xu on 3/24/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;
@property (strong, nonatomic) IBOutlet UIButton *markButton;

@end
