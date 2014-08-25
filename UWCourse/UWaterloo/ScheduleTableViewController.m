//
//  ScheduleTableViewController.m
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "JSONModelLib.h"
#import "CourseScheduleModel.h"
#import "ScheduleTableCellTableViewCell.h"
#import "addScheduleDetailViewController.h"
#import "AppDelegate.h"

@interface ScheduleTableViewController ()
//-(void)requestAccessToEvents;
@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation ScheduleTableViewController

/*-(void)requestAccessToEvents{
 [self.appDelegate.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
 if (error == nil) {
 // Store the returned granted value.
 self.appDelegate.eventManager.eventsAccessGranted = granted;
 }
 else{
 // In case of error, just log its description to the debugger.
 NSLog(@"%@", [error localizedDescription]);
 }
 }];
 }*/

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Courses"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    
    self.courses = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Make self the delegate and datasource of the table view.
    //self.tblEvents.delegate = self;
    //self.tblEvents.dataSource = self;
    //[self performSelector:@selector(requestAccessToEvents) withObject:nil afterDelay:0.4];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wood2.png"]];
    [tempImageView setFrame:self.tableView.frame];
    selectedIndex=-1;
    self.tableView.backgroundView = tempImageView;
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleTableCell" bundle:nil] forCellReuseIdentifier:@"ScheduleTableCell"];
    //[HUD showUIBlockingIndicatorWithText:@"Loading"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"ScheduleCell";
    static NSString *CellIdentifier = @"ScheduleTableCell";
    
    ScheduleTableCellTableViewCell *cell = (ScheduleTableCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    // Configure the cell...
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    NSManagedObject *device = [self.courses objectAtIndex:indexPath.row];
    
    //midterm date
    
    /*NSDate *currentTime = [NSDate date];
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"HH:mm/MM/dd/yyyy"];
     NSString *dateString = [dateFormat stringFromDate:currentTime];
     NSString *str=[NSString stringWithFormat:@"%@/%@/2014",[device valueForKey:@"midtermStart_time"],[device valueForKey:@"midtermDate"]];*/
    
    //finaltime
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:currentTime];
    //NSString *str=[NSString stringWithFormat:@"%@",[device valueForKey:@"finalDate"]];
    NSDate *secondDate=[device valueForKey:@"taskDate"];
    
    //NSDate* secondDate = [dateFormat dateFromString:str];
    NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:currentTime];
    
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit; //| NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:currentTime  toDate:secondDate  options:0];
    
    //NSLog(@"Break down: %d min : %d hours : %d days : %d months",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day]);
    //NSLog(@"%d", [breakdownInfo day]);
    //, [breakdownInfo month]
    //[date1 release];
    //[date2 release];
    NSLog(@"date: %@", dateString);
    long days=[breakdownInfo day];
    UIColor * color = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:21/255.0f alpha:1.0f];
    if (days<0){
        days=-days;
        cell.countDown.textColor=color;
    } else {
        cell.countDown.textColor=[UIColor redColor];
    }
    //[cell.textLabel setText:[NSString stringWithFormat:@"%@: %ld days",[device valueForKey:@"catalog_number"],(long)[breakdownInfo day]]];
    /*cell.location.text=[NSString stringWithFormat:@"Location: %@",[device valueForKey:@"finalLocation"]];
     cell.countDown.text=[NSString stringWithFormat:@"%ld",(long)days];
     cell.courseName.text=[NSString stringWithFormat:@"%@ Final",[device valueForKey:@"catalog_number"]];*/
    //cell.Date.text=str;
    cell.location.text=[NSString stringWithFormat:@"Location: %@",[device valueForKey:@"taskLocation"]];
    
    if (days==0){
        if ([breakdownInfo hour]==0){
            cell.countDown.text=[NSString stringWithFormat:@"%ld",(long)[breakdownInfo minute]];
            cell.unitLabel.text=@"Mins";
        } else{
            cell.countDown.text=[NSString stringWithFormat:@"%ld",(long)[breakdownInfo hour]];
            cell.unitLabel.text=@"Hours";
        }
    } else {
        cell.countDown.text=[NSString stringWithFormat:@"%ld",(long)days];
        cell.unitLabel.text=@"Days";
    }
    cell.courseName.text=[NSString stringWithFormat:@"%@",[device valueForKey:@"taskName"]];
    cell.Date.text=[dateFormat stringFromDate:secondDate];
    cell.clipsToBounds = YES;
    
    if (selectedIndex==indexPath.row){
        
    } else {
        
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex==indexPath.row){
        return 163;
    } else {
        return 81;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex==indexPath.row){
        selectedIndex=-1;
        //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [tableView beginUpdates];
        [tableView endUpdates];
        if (!tableView.isEditing) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        return;
    }
    if (selectedIndex!=indexPath.row){
        NSIndexPath *prePath=[NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex=indexPath.row;
        [tableView beginUpdates];
        [tableView endUpdates];
        if (!tableView.isEditing) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:prePath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    selectedIndex=indexPath.row;
    //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView beginUpdates];
    [tableView endUpdates];
    /*if (!tableView.isEditing) {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     }*/
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 NSManagedObjectContext *context = [self managedObjectContext];
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete object from database
 [context deleteObject:[self.courses objectAtIndex:indexPath.row]];
 
 NSError *error = nil;
 if (![context save:&error]) {
 NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
 return;
 }
 
 // Remove device from table view
 [self.courses removeObjectAtIndex:indexPath.row];
 [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 }*/
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bookmark" message:@"Save to favorites successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            break;
        }
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email sent" message:@"Just sent the image to your INBOX" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            break;
        }
        case 2:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook Sharing" message:@"Just shared the pattern image on Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            break;
        }
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Sharing" message:@"Just shared the pattern image on Twitter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        default:
            break;
    }
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // More button is pressed
            /*addScheduleDetailViewController *destView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
             [self.navigationController pushViewController:destView animated:YES];*/
            self.selectedRow=[self.tableView indexPathForCell:cell];
            [self performSegueWithIdentifier:@"edit" sender:self];
            
            /*UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", nil];
             [shareActionSheet showInView:self.view];*/
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            NSManagedObjectContext *context = [self managedObjectContext];
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            [context deleteObject:[self.courses objectAtIndex:cellIndexPath.row]];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            
            // Remove device from table view
            [self.courses removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default:
            break;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"edit"]) {
        NSManagedObject *selectedEvent = [self.courses objectAtIndex:[self.selectedRow row]];
        
        addScheduleDetailViewController *destViewController = segue.destinationViewController;
        destViewController.event = selectedEvent;
    }
}
@end