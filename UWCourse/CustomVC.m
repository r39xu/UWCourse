//
//  CustomVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/25/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "CustomVC.h"
#import "CustomCell.h"
#import "MarkTableViewCell.h"
#import "MoreDetailTVC.h"
#import "CWStatusBarNotification.h"
#import "scheduleFetcher.h"

@interface CustomVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@property (nonatomic) BOOL isLEC;
@property (nonatomic) BOOL isTUT;
@property (nonatomic) BOOL isTST;
@property (nonatomic,strong) CWStatusBarNotification *notification;

@end

@implementation CustomVC

- (IBAction)changeTable:(id)sender {
    if (self.segControl.selectedSegmentIndex == 0){
        [self hitLEC:sender];
    } else if (self.segControl.selectedSegmentIndex == 1){
        [self hitTUT:sender];
    } else {
        [self hitTST:sender];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lecArray = [[NSMutableArray alloc]initWithArray:self.lectureArray];
    NSMutableArray *fakeLecArray = [lecArray mutableCopy];
    for (NSDictionary *dic in fakeLecArray){
        NSMutableString *string = [[NSMutableString alloc]init];
        NSDictionary *date = dic[@"classes"][0][@"date"];
        if (![date[@"start_time"] isKindOfClass:[NSString class]] ){
            [lecArray removeObject:dic];
            continue;
        }
        NSMutableArray *classArray = [[NSMutableArray alloc]initWithArray:dic[@"classes"]];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *class in classArray){
            NSMutableString *timestring = [[NSMutableString alloc]init];
            NSDictionary *time = class[@"date"];
            if (time[@"start_time"] && time[@"end_time"] && time[@"weekdays"]){
                [timestring appendString:[NSString stringWithFormat:@"%@ %@-%@ ",time[@"weekdays"],time[@"start_time"],time[@"end_time"]]];
            }
            if ([string rangeOfString:timestring].location == NSNotFound){
                [string appendString:timestring];
                [array addObject:class];
            }
        }
        NSMutableDictionary *newdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [newdic setObject:string forKey:@"timeLabel"];
        [newdic setObject:array forKey:@"classes"];
        [lecArray replaceObjectAtIndex:[fakeLecArray indexOfObject:dic] withObject:newdic];
    }
    NSLog(@"%@",lecArray[0][@"classes"]);
    tstArray = [[NSMutableArray alloc]initWithArray:self.testArray];
    tutArray = [[NSMutableArray alloc] initWithArray:self.tutorialArray];
    self.title = [NSString stringWithFormat:@"%@ %@",self.courseName,self.courseNum];
    self.isLEC = YES;
    self.isTST = NO;
    self.isTUT = NO;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStuff)];
    self.navigationItem.rightBarButtonItem = button;
}

-(NSInteger) getMinute:(NSString *)time{
    NSInteger result = 0;
    NSInteger breakpoint = 0;
    for (NSInteger i = 0; i<[time length]; i++){
        char c = [time characterAtIndex:i];
        if (c == ':'){
            breakpoint = i;
        }
    }
    NSString *hour = [time substringToIndex:breakpoint];
    NSString *minute = [time substringFromIndex:breakpoint+1];
    result = [hour intValue] * 60 + [minute intValue];
    return result;
}


-(void) addStuff{
    
    NSInteger i = [self.picker selectedRowInComponent:0];
    NSInteger tutIndex = [self.picker selectedRowInComponent:1];
    NSInteger tstIndex = [self.picker selectedRowInComponent:2];
    
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    NSDictionary *lecture;
    NSDictionary *tutorial;
    NSDictionary *test;
    
    
    if ([lecArray count] > 0){
        lecture = lecArray[i];
    }
    
    if([tutArray count]>0) {
        tutorial = self.tutorialArray[tutIndex];
    }
    
    if ([tstArray count]>0){
        test = self.testArray[tstIndex];
    }
    NSArray *classArray = lecture[@"classes"];
    NSMutableArray *addingArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < [classArray count] ; i++){
        NSMutableDictionary *clecture = [[NSMutableDictionary alloc] init];
        if (lecture){
            [clecture setValue:lecture[@"section"] forKey:@"section"];
            
            NSArray *instructorArray = lecture[@"classes"][0][@"instructors"];
            if ([instructorArray isEqualToArray:@[]]){
                [clecture setValue:@"No Instructors Found" forKey:@"instructor"];
            } else {
                [clecture setValue:instructorArray[0] forKey:@"instructor"];
            }
            
            NSDictionary *date = lecture[@"classes"][i][@"date"];
            [clecture setValue:date[@"weekdays"] forKey:@"weekdays"];
            [clecture setValue:date[@"start_time"] forKey:@"start_time"];
            [clecture setValue:date[@"end_time"] forKey:@"end_time"];
            [clecture setValue:self.courseName forKey:@"coursename"];
            [clecture setValue:self.courseNum forKey:@"coursenum"];
        }
        if (i == 0){
            if(tutorial) {
                NSMutableDictionary *tutDic = [[NSMutableDictionary alloc] init];
                NSDictionary *date = tutorial[@"classes"][0][@"date"];
                [tutDic setValue:date[@"weekdays"] forKey:@"weekdays"];
                [tutDic setValue:date[@"start_time"] forKey:@"start_time"];
                [tutDic setValue:date[@"end_time"] forKey:@"end_time"];
                [tutDic setValue:tutorial[@"section"] forKey:@"section"];
                [clecture setValue:tutDic forKey:@"tutorial"];
            }
            
            if (test){
                NSMutableDictionary *tstDic = [[NSMutableDictionary alloc] init];
                NSDictionary *date = test[@"classes"][0][@"date"];
                [tstDic setValue:date[@"weekdays"] forKey:@"weekdays"];
                [tstDic setValue:date[@"start_time"] forKey:@"start_time"];
                [tstDic setValue:date[@"end_time"] forKey:@"end_time"];
                [clecture setValue:tstDic forKey:@"test"];
            }
        }
        
        NSString *weekdays = clecture[@"weekdays"];
        NSString *section = clecture[@"section"];
        
        NSMutableArray *frameArray = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i < [weekdays length] ; i++){
            CGRect frame;
            NSInteger starttime = ([self getMinute:clecture[@"start_time"]] - 480) * 0.6666666666667 + 80;
            NSInteger endtime = ([self getMinute:clecture[@"end_time"]] - 480) *0.66666666666667 + 80;
            CGSize size = CGSizeMake(40*2.7-1, endtime - starttime);
            frame.size = size;
            frame.origin.y = starttime;
            char c = [weekdays characterAtIndex:i];
            if (c == 'M'){
                frame.origin.x = 60;
            } else if ([weekdays isEqualToString:@"Th"]){
                frame.origin.x = 60 + 3*40*2.7;;
            } else if (c == 'T'){
                frame.origin.x = 60 + 40*2.7;
            } else if (c == 'W'){
                frame.origin.x = 60 + 2*40*2.7;
            } else if (c == 'F'){
                frame.origin.x = 60 + 4*40*2.7;
            } else {
                continue;
            }
            [frameArray addObject:NSStringFromCGRect(frame)];
            NSLog(@"%@",[bookmark objectForKey:@"Frame List"]);
            if ([bookmark objectForKey:@"Frame List"]){
                NSArray *frameList = [bookmark objectForKey:@"Frame List"];
                for (NSDictionary *courseFrame in frameList){
                    NSArray *lectureFrame = courseFrame[@"lectureFrame"];
                    for (NSString *lecFrame in lectureFrame){
                        CGRect frame1 = CGRectFromString(lecFrame);
                        if (CGRectIntersectsRect(frame, frame1)){
                            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"UWCourse" message:[NSString stringWithFormat:@"You have time conflict with your existing courses:%@%@",courseFrame[@"coursename"],courseFrame[@"coursenum"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Edit", nil];
                            [alert1 show];
                            return;
                        }
                    }
                    if ([courseFrame objectForKey:@"tutorialFrame"]){
                        NSString *tutFrame = [courseFrame objectForKey:@"tutorialFrame"];
                        CGRect frame1 = CGRectFromString(tutFrame);
                        if (CGRectIntersectsRect(frame, frame1)){
                            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"UWCourse" message:[NSString stringWithFormat:@"You have time conflict with your existing courses:%@%@",courseFrame[@"coursename"],courseFrame[@"coursenum"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Edit chosen courses", nil];
                            [alert1 show];
                            return;
                        }
                    }
                }
            }
        }
        NSUserDefaults *event = [NSUserDefaults standardUserDefaults];
        if (![event objectForKey:@"Frame List"]){
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
            [newDic setObject:clecture[@"coursename"] forKey:@"coursename"];
            [newDic setObject:clecture[@"coursenum"] forKey:@"coursenum"];
            [newDic setObject:frameArray forKey:@"lectureFrame"];
            NSArray *newArray = [[NSArray alloc]initWithObjects:newDic, nil];
            [event setObject:newArray forKey:@"Frame List"];
            [event synchronize];
            NSLog(@"New Frame List:%@",[event objectForKey:@"Frame List"]);
        } else {
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
            [newDic setObject:clecture[@"coursename"] forKey:@"coursename"];
            [newDic setObject:clecture[@"coursenum"] forKey:@"coursenum"];
            [newDic setObject:frameArray forKey:@"lectureFrame"];
            NSMutableArray *arrayCopy = [[NSMutableArray alloc] initWithArray:[event objectForKey:@"Frame List"]];
            
            BOOL isExist = NO;
            for (NSDictionary *existDic in arrayCopy){
                if ([existDic[@"coursename"] isEqualToString:clecture[@"coursename"]]){
                    if ([existDic[@"coursenum"]isEqualToString:clecture[@"coursenum"]]){
                        if ([existDic[@"lectureFrame"] isEqualToArray:frameArray]){
                            isExist = YES;
                        }
                    }
                }
            }
            
            if (!isExist){
                [arrayCopy addObject:newDic];
                [event setObject:arrayCopy forKey:@"Frame List"];
                [event synchronize];
                NSLog(@"Current Frame List:%@",arrayCopy);
            }
        }
        if(clecture[@"tutorial"]){
            CGRect frame;
            NSDictionary *tutorial = [clecture objectForKey:@"tutorial"];
            NSInteger starttime = ([self getMinute:tutorial[@"start_time"]] - 480) *0.6666666666667 + 80;
            NSInteger endtime = ([self getMinute:tutorial[@"end_time"]] - 480) *0.66666666666667 + 80;
            CGSize size = CGSizeMake(40*2.7-1, endtime - starttime);
            frame.size = size;
            frame.origin.y = starttime;
            NSString *day = tutorial[@"weekdays"];
            char c;
            c = [day characterAtIndex:0];
            if (c == 'M'){
                frame.origin.x = 60;
            } else if ([day length] == 2 ){
                frame.origin.x = 60 + 3*40*2.7;;
            } else if (c == 'T'){
                frame.origin.x = 60 + 40*2.7;
            } else if (c == 'W'){
                frame.origin.x = 60 + 2*40*2.7;
            } else if (c == 'F'){
                frame.origin.x = 60 + 4*40*2.7;
            }
            
            NSArray *frameList = [event objectForKey:@"Frame List"];
            for (NSDictionary *dic in frameList){
                if ([dic[@"coursename"] isEqualToString:clecture[@"coursename"]]){
                    if ([dic[@"coursenum"] isEqualToString:clecture[@"coursenum"]]){
                        NSMutableDictionary *newdic = [dic mutableCopy];
                        [newdic setObject:NSStringFromCGRect(frame) forKey:@"tutorialFrame"];
                        NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:frameList];
                        [newArray removeObject:dic];
                        [newArray addObject:newdic];
                        [event setObject:newArray forKey:@"Frame List"];
                        [event synchronize];
                    }
                }
            }
        }
        [addingArray addObject:clecture];
    }
    [self addCourse];
    scheduleFetcher *sf = [scheduleFetcher new];
    [sf scheduleFetch:[NSString stringWithFormat:@"%@/%@",self.courseName,self.courseNum]];
    //self.tabBarController.selectedViewController= [self.tabBarController.viewControllers objectAtIndex:2];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        
    }
}

- (IBAction)hitLEC:(id)sender {
    self.isLEC = YES;
    self.isTUT = NO;
    self.isTST = NO;
    [tableView reloadData];
}

- (IBAction)hitTUT:(id)sender {
    self.isLEC = NO;
    self.isTUT = YES;
    self.isTST = NO;
    [tableView reloadData];
}


- (IBAction)hitTST:(id)sender {
    self.isLEC = NO;
    self.isTUT = NO;
    self.isTST = YES;
    [tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.isLEC){
        return [lecArray count];
    } else if (self.isTUT){
        return [tutArray count];
    } else {
        return [tstArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.isTUT){
        cell.instructorLabel.text = @"";
    }
    
    if (self.isTST){
        cell.instructorLabel.text = @"";
        cell.placeLabel.text = @"";
    }
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    if (self.isLEC){
        
        NSDictionary *lecture = lecArray[indexPath.row];
        
        cell.label1.text = lecture[@"section"];
        NSArray *instructorArray = lecture[@"classes"][0][@"instructors"];
        if ([instructorArray isEqualToArray:@[]]){
            cell.instructorLabel.text = @"No Instructors Found";
        } else {
            cell.instructorLabel.text = instructorArray[0];
        }
        
        NSDictionary *location = lecture[@"classes"][0][@"location"];
        if (!location[@"building"] || !location[@"room"]){
            cell.placeLabel.text = @"No Place Found";
        } else {
            cell.placeLabel.text = [NSString stringWithFormat:@"%@ %@",location[@"building"],location[@"room"]];
        }
        
        NSDictionary *date = lecture[@"classes"][0][@"date"];
        cell.timeLabel.text = lecture[@"timeLabel"];
    } else if (self.isTUT){
        if ([tutArray count] > 0){
            
            NSDictionary *tutorial = tutArray[indexPath.row];
            cell.label1.text = tutorial[@"section"];
            
            NSDictionary *date = tutorial[@"classes"][0][@"date"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",
                                   date[@"weekdays"],date[@"start_time"],
                                   date[@"end_time"]];
            
            NSDictionary *location = tutorial[@"classes"][0][@"location"];
            if (!location[@"building"] || !location[@"room"]){
                cell.placeLabel.text = @"No Place Found";
            } else {
                cell.placeLabel.text = [NSString stringWithFormat:@"%@ %@",location[@"building"],location[@"room"]];
            }
            
        }
        
    } else {
        if ([tstArray count] > 0){
            NSDictionary *test = tstArray[indexPath.row];
            cell.label1.text = test[@"section"];
            
            NSDictionary *date = test[@"classes"][0][@"date"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",
                                   date[@"weekdays"],date[@"start_time"],
                                   date[@"end_time"]];
            
        }
    }
    return cell;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 3;
}



- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return [lecArray count];
    
    if (component == 1)
        return  [tutArray count];
    if (component == 2)
        return [tstArray count];
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0){
        NSString *section = [lecArray objectAtIndex:row][@"section"];
        return section;
    }
    if (component == 1){
        NSString *tutorial = [tutArray objectAtIndex: row][@"section"];
        return tutorial;
    }
    if (component == 2){
        NSString *test = [tstArray objectAtIndex:row][@"section"];
        return test;
    }
    return 0;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[MoreDetailTVC class]]){
        MoreDetailTVC *mdtvc = segue.destinationViewController;
        NSIndexPath *indexPath = [tableView indexPathForCell:sender];
        if (self.isLEC){
            mdtvc.section = lecArray[indexPath.row];
        } else if (self.isTUT){
            mdtvc.section = tutArray[indexPath.row];
        } else{
            mdtvc.section = tstArray[indexPath.row];
        }
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}



- (void)addCourse
{
    int lecIndex = [self.picker selectedRowInComponent:0];
    int tutIndex = [self.picker selectedRowInComponent:1];
    int tstIndex = [self.picker selectedRowInComponent:2];
    
    NSDictionary *lecture;
    NSDictionary *tutorial;
    NSDictionary *test;
    
    if (lecArray.count > 0) {
        lecture = lecArray[lecIndex];
    } else {
        return;  // Potential bug: assume must have at least one lecture
    }
    if (tutArray.count > 0) {
        tutorial = tutArray[tutIndex];
    }
    if (tstArray.count > 0) {
        test = tstArray[tstIndex];
    }
    
    // a newCourse to be added to database
    NSMutableDictionary *newCourseDic = [[NSMutableDictionary alloc] init];
    
    // *** LEC ***
    NSMutableArray *lecArray = [[NSMutableArray alloc] init];
    NSArray *classArray = lecture[@"classes"];
    for (int i = 0; i < classArray.count; ++i) {
        NSMutableDictionary *lecDic = [[NSMutableDictionary alloc] init];
        
        // section, course name & location
        [lecDic setValue:lecture[@"section"] forKey:@"section"];
        [lecDic setValue:self.courseName forKey:@"coursename"];
        [lecDic setValue:self.courseNum forKey:@"coursenum"];
        NSDictionary *locationDic = lecture[@"classes"][i][@"location"];
        NSString *location = [NSString stringWithFormat:@"%@ %@", locationDic[@"building"], locationDic[@"room"]];
        [lecDic setValue:location forKey:@"location"];
        
        // instructor
        NSArray *instructorArray = lecture[@"classes"][0][@"instructors"];
        if ([instructorArray isEqualToArray:@[]]){
            [lecDic setValue:@"No Instructors Found" forKey:@"instructor"];
        } else {
            [lecDic setValue:instructorArray[0] forKey:@"instructor"];
        }
        
        // date & time
        NSDictionary *date = lecture[@"classes"][i][@"date"];
        [lecDic setValue:date[@"weekdays"] forKey:@"weekdays"];
        [lecDic setValue:date[@"start_time"] forKey:@"start_time"];
        [lecDic setValue:date[@"end_time"] forKey:@"end_time"];
        
        [lecArray addObject:lecDic];
    }
    [newCourseDic setValue:lecArray forKey:@"lecture"];
    
    // *** TUT ***
    if (tutorial) {
        NSMutableDictionary *tutDic = [[NSMutableDictionary alloc] init];
        NSDictionary *date = tutorial[@"classes"][0][@"date"];
        [tutDic setValue:date[@"weekdays"] forKey:@"weekdays"];
        [tutDic setValue:date[@"start_time"] forKey:@"start_time"];
        [tutDic setValue:date[@"end_time"] forKey:@"end_time"];
        [tutDic setValue:tutorial[@"section"] forKey:@"section"];
        NSDictionary *locationDic = tutorial[@"classes"][0][@"location"];
        NSString *location = [NSString stringWithFormat:@"%@ %@", locationDic[@"building"], locationDic[@"room"]];
        [tutDic setValue:location forKey:@"location"];
        [newCourseDic setValue:tutDic forKey:@"tutorial"];
    }
    
    // *** TST ***
    if (test) {
        NSMutableDictionary *tstDic = [[NSMutableDictionary alloc] init];
        NSDictionary *date = test[@"classes"][0][@"date"];
        [tstDic setValue:date[@"weekdays"] forKey:@"weekdays"];
        [tstDic setValue:date[@"start_time"] forKey:@"start_time"];
        [tstDic setValue:date[@"end_time"] forKey:@"end_time"];
        [newCourseDic setValue:tstDic forKey:@"test"];
    }
    
    // add newCourse to bookmark(database)
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    if (![bookmark objectForKey:@"Event List"]){
        NSMutableArray *markArray = [[NSMutableArray alloc] initWithObjects:newCourseDic, nil];
        [bookmark setObject:markArray forKey:@"Event List"];
        [bookmark synchronize];
    } else {
        NSMutableArray *markArray = [[NSMutableArray alloc] initWithArray:[bookmark objectForKey:@"Event List"]];
        [markArray addObject:newCourseDic];
        [bookmark setObject:markArray forKey:@"Event List"];
        [bookmark synchronize];
    }
    
     //status bar notification
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor  = self.view.tintColor;
    self.notification.notificationLabelTextColor = [UIColor whiteColor];
    [self.notification displayNotificationWithMessage:[NSString stringWithFormat:@"%@%@ has been added",self.courseName,self.courseNum] forDuration:1.0];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
