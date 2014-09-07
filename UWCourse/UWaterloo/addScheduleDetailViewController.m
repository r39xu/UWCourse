//
//  addScheduleDetailViewController.m
//  UWaterloo
//
//  Created by Jack Zhang on 7/24/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//
#define kDatePickerIndex 2
#define kEndDatePickerIndex 4
#define EndDatePickerHeight 166
#define DatePickerHeight 166
#define alarmPickerIndex 1
#define alarmPickerHeight 166
#import "addScheduleDetailViewController.h"

@interface addScheduleDetailViewController ()
{

}

@end

@implementation addScheduleDetailViewController

@synthesize event;
@synthesize taskTimeLabel=_taskTimeLabel;
@synthesize datePicker=_datePicker;
@synthesize locationLabel=_locationLabel;
@synthesize Notes=_Notes;


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    //self.tableView.userInteractionEnabled = YES;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float currentVersion = 7.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion) {
        // iOS 7
        
        self.navBar.frame = CGRectMake(self.navBar.frame.origin.x, self.navBar.frame.origin.y+30, self.navBar.frame.size.width, 64);
    }
        [self signUpForKeyboardNotifications];
    //self.tableView.separatorColor = [UIColor clearColor];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wood2.jpg"]];
    [tempImageView setFrame:self.tableView.frame];

    self.tableView.backgroundView = tempImageView;
    
    if (self.event){
        self.locationLabel.text=[self.event valueForKey:@"taskLocation"];
        self.taskName.text=[self.event valueForKey:@"taskName"];
        self.Notes.text=[self.event valueForKey:@"notes"];
        NSDate* date=[self.event valueForKey:@"taskFullDate"];
        if (date==NULL){
            date=[NSDate date];
        }
        [self setupTimeLabel:date];

    } else {
        [self setupTimeLabel:[NSDate date]];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (IBAction)save:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    if (self.event) {
        // Update existing device
        [self.event setValue:self.taskName.text forKey:@"taskName"];
        [self.event setValue:self.locationLabel.text forKey:@"taskLocation"];
        [self.event setValue:self.selectedDate forKey:@"taskFullDate"];
        [self.event setValue:self.selectedEndDate forKey:@"taskFullEndDate"];
        [self.event setValue:self.Notes.text forKey:@"notes"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dayName = [dateFormatter stringFromDate:self.selectedDate];
        [self.event setValue:dayName forKey:@"taskDay"];
        
    } else {
        
        
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Task"   inManagedObjectContext:context];
        [newDevice setValue:self.taskName.text forKey:@"taskName"];
        [newDevice setValue:self.locationLabel.text forKey:@"taskLocation"];
        [newDevice setValue:self.selectedDate forKey:@"taskFullDate"];
        [newDevice setValue:self.selectedEndDate forKey:@"taskFullEndDate"];
        [self.event setValue:self.Notes.text forKey:@"notes"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dayName = [dateFormatter stringFromDate:self.selectedDate];
        [self.event setValue:dayName forKey:@"taskDay"];
        if (self.alarmPickerIsShowing){
            NSDate *pickerDate = [self.alarmPicker date];
            
            
            /*UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = pickerDate;
            localNotification.alertBody = self.taskName.text;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];*/

            // Schedule the notification
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = pickerDate;
            localNotification.alertBody = self.taskName.text;
            localNotification.alertAction = @"Show me the item";
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            // Request to reload table view data
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];


        }
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupTimeLabel:(NSDate*) defaultDate {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.datePicker.date=defaultDate;
    if ([self.event valueForKey:@"taskFullEndDate"]!=NULL){
        self.taskTimeLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    } else {
        self.taskTimeLabel.text=@"";
    }
    
    self.endDateLabel.text=[self.dateFormatter stringFromDate:[self.event valueForKey:@"taskFullEndDate"]];
    //self.taskTimeLabel.textColor = [self.tableView tintColor];
    if ([self.event valueForKey:@"taskFullEndDate"]!=NULL){
        self.endDatePicker.date=[self.event valueForKey:@"taskFullEndDate"];
        self.selectedEndDate=[self.event valueForKey:@"taskFullEndDate"];
    } else {
        self.endDatePicker.date=defaultDate;
    }
    self.selectedDate = defaultDate;

    self.endDatePicker.minimumDate=defaultDate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if ((indexPath.section==0)&&(indexPath.row == kDatePickerIndex)){
        if (self.datePickerIsShowing==0){
            height=0.0f;
        } else {
            height=DatePickerHeight;
        }
    }
    
    if ((indexPath.section==0)&&(indexPath.row == kEndDatePickerIndex)){
        if (self.endDatePickerIsShowing==0){
            height=0.0f;
        } else {
            height=EndDatePickerHeight;
        }
    }
    if ((indexPath.section==2)&&(indexPath.row == alarmPickerIndex)){
        if (self.alarmPickerIsShowing==0){
            height=0.0f;
        } else {
            height=alarmPickerHeight;
        }
    }
    if (indexPath.section==1){
            height=70;
    }

    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section==0)&&(indexPath.row == 1)){
        
        if (self.datePickerIsShowing){
            
            
            [self hideDatePickerCell];
            
        }else {
            
            [self hideEndDatePickerCell];
            [self showDatePickerCell];
        }
    }
    if ((indexPath.section==0)&&(indexPath.row == 3)){
        
        if (self.endDatePickerIsShowing){
            
            
            [self hideEndDatePickerCell];
            
        }else {
            
            [self hideDatePickerCell];
            [self showEndDatePickerCell];
        }
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)showDatePickerCell {
    self.taskTimeLabel.textColor = [UIColor redColor];
    //[self.activeTextField resignFirstResponder];
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.datePicker.alpha = 1.0f;
        
    }];
}

- (void)hideDatePickerCell {
    self.taskTimeLabel.textColor = [UIColor blackColor];
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.datePicker.hidden = YES;
                     }];
}

- (void)showEndDatePickerCell {
    //[self.activeTextField resignFirstResponder];
    self.endDateLabel.textColor=[UIColor redColor];
    self.endDatePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.endDatePicker.hidden = NO;
    self.endDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.endDatePicker.alpha = 1.0f;
        
    }];
}

- (void)hideEndDatePickerCell {
    self.endDateLabel.textColor=[UIColor blackColor];
    self.endDatePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.endDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.endDatePicker.hidden = YES;
                     }];
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}
- (void)keyboardWillShow {
    
    //if (self.datePickerIsShowing){
        [self hideEndDatePickerCell];
        [self hideDatePickerCell];
    //}
}
- (IBAction)datePickerChanged:(UIDatePicker *)sender {
    self.taskTimeLabel.text=[self.dateFormatter stringFromDate:sender.date];
    self.selectedDate=sender.date;
    self.endDatePicker.minimumDate=self.selectedDate;
    if ((self.selectedEndDate==NULL)||([self.selectedDate compare:self.selectedEndDate] == NSOrderedDescending)) {
        
        self.endDatePicker.date=self.selectedDate;
        self.endDateLabel.text=[self.dateFormatter stringFromDate:self.selectedDate];
        self.selectedEndDate=self.selectedDate;
        
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.activeTextField isFirstResponder] && [touch view] != self.activeTextField) {
        [self.activeTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void) hideKeyboard {
    [self.taskName resignFirstResponder];
    [self.locationLabel resignFirstResponder];
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
   [[self view] endEditing:YES];
}
- (IBAction)endDatePickerChanged:(UIDatePicker *)sender {
    self.endDateLabel.text=[self.dateFormatter stringFromDate:sender.date];
    self.selectedEndDate=sender.date;
}
- (IBAction)needAlarm:(UISwitch *)sender {
    if (self.alarmPickerIsShowing==NO){
        self.alarmPickerIsShowing=YES;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    } else {
        self.alarmPickerIsShowing=NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
}
- (IBAction)alarmChanged:(UIDatePicker *)sender {

}
@end
