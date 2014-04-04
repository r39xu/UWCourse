//
//  SectionMarkTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/24/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "SectionMarkTVC.h"
#import "MarkTableViewCell.h"
#import "TUTMarkTVC.h"

@interface SectionMarkTVC ()

@property (nonatomic) BOOL isMarked;

@end

@implementation SectionMarkTVC


- (IBAction)hitMark:(UIButton *)sender {
    
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    int i = [sender.accessibilityIdentifier intValue];
    NSDictionary *lecture = self.lectureArray[i];
    
    NSMutableDictionary *clecture = [[NSMutableDictionary alloc] init];
    [clecture setValue:lecture[@"section"] forKey:@"section"];
    
    NSArray *instructorArray = lecture[@"classes"][0][@"instructors"];
    if ([instructorArray isEqualToArray:@[]]){
        [clecture setValue:@"No Instructors Found" forKey:@"instructor"];
    } else {
        [clecture setValue:instructorArray[0] forKey:@"instructor"];
    }
    
    NSDictionary *date = lecture[@"classes"][0][@"date"];
    [clecture setValue:date[@"weekdays"] forKey:@"weekdays"];
    [clecture setValue:date[@"start_time"] forKey:@"start_time"];
    [clecture setValue:date[@"end_time"] forKey:@"end_time"];
    [clecture setValue:self.courseName forKey:@"coursename"];
    [clecture setValue:self.courseNum forKey:@"coursenum"];

    if ([sender.currentTitle isEqualToString:@"☆"]){
        [sender setTitle:@"★" forState:UIControlStateNormal];
        [sender setTitleColor:sender.tintColor forState:UIControlStateNormal];
        if (![bookmark objectForKey:@"Event List"]){
            NSMutableArray *markArray = [[NSMutableArray alloc] initWithObjects:clecture, nil];
            //NSLog(@"First: %@",markArray);
            [bookmark setObject:markArray forKey:@"Event List"];
            [bookmark synchronize];
        } else {
            NSMutableArray *markArray = [[NSMutableArray alloc] initWithArray:[bookmark objectForKey:@"Event List"]];
            
            BOOL isExist = NO;
            for (NSDictionary *course in markArray){
                if ([course isEqualToDictionary:clecture]){
                    isExist = YES;
                }
            }
            if (!isExist){
                [markArray addObject:clecture];
                [bookmark setObject:markArray forKey:@"Event List"];
                [bookmark synchronize];
            }
        }
        [self.tableView reloadData];
    } else {
        NSMutableArray *markArray = [[NSMutableArray alloc] initWithArray:[bookmark objectForKey:@"Event List"]];
        [markArray removeObject:clecture];
        [bookmark setObject:markArray forKey:@"Event List"];
        
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitle:@"☆" forState:UIControlStateNormal];
        [bookmark synchronize];
        [self.tableView reloadData];
    }
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.lectureArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    NSDictionary *lecture = self.lectureArray[indexPath.row];
    
    if ([lecture[@"campus"] isEqualToString:@"ONLN ONLINE"]){
        return [[UITableViewCell alloc] init];
    }
    
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
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",
                           date[@"weekdays"],date[@"start_time"],
                           date[@"end_time"]];
    
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    NSMutableArray *markArray = [[NSMutableArray alloc] initWithArray:[bookmark objectForKey:@"Event List"]];
    
    BOOL isExist = NO;
    for (NSDictionary *course in markArray){
        if ([course[@"coursename"] isEqualToString:self.courseName]){
            if ([course[@"coursenum"] isEqualToString:self.courseNum]){
                if ([course[@"section" ] isEqualToString:lecture[@"section"]]){
                    isExist = YES;
                }
            }
        }
    }
    if (isExist){
        [cell.markButton setTitle:@"★" forState:UIControlStateNormal];
        [cell.markButton setTitleColor:cell.markButton.tintColor forState:UIControlStateNormal];
    }
    [cell.markButton setAccessibilityIdentifier:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[TUTMarkTVC class]]){
        TUTMarkTVC *tmtvc = segue.destinationViewController;
        tmtvc.tutorialArray = self.tutorialArray;
        tmtvc.testArray = self.testArray;
        tmtvc.courseName = self.courseName;
        tmtvc.courseNum = self.courseNum;
    }
}

@end
