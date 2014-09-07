//
//  addScheduleDetailViewController.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/24/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addScheduleDetailViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *taskName;

@property (strong, nonatomic) IBOutlet UILabel *taskTimeLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerChanged:(UIDatePicker *)sender;

@property (strong, nonatomic) IBOutlet UITextField *locationLabel;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) NSDate* selectedDate;
@property(nonatomic) BOOL datePickerIsShowing;
@property(strong,nonatomic) UITextField* activeTextField;

@property (nonatomic) bool endDatePickerIsShowing;
- (IBAction)endDatePickerChanged:(UIDatePicker *)sender;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (strong,nonatomic) NSDate* selectedEndDate;

//@property (strong, nonatomic) IBOutlet UIDatePicker *alarmPicker;
- (IBAction)alarmChanged:(UIDatePicker *)sender;

- (IBAction)needAlarm:(UISwitch *)sender;
@property (nonatomic) bool alarmPickerIsShowing;
@property (strong, nonatomic) IBOutlet UIDatePicker *alarmPicker;
@property (strong, nonatomic) IBOutlet UITextView *Notes;

@property (strong) NSManagedObject *event;
@end
