//
//  TUTMarkTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/24/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "TUTMarkTVC.h"
#import "MarkTableViewCell.h"

@interface TUTMarkTVC ()

@property (nonatomic,strong) UIAlertView *alert;
@end

@implementation TUTMarkTVC


-(void)setTutorialArray:(NSArray *)tutorialArray{
    _tutorialArray = tutorialArray;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([self.tutorialArray count] == 0){
        self.alert = [[UIAlertView alloc] initWithTitle:@"UWCourse" message:@"NO TUT FOUND" delegate:self cancelButtonTitle:@"What the hell?!!" otherButtonTitles:nil, nil];
        [self.alert show];
    }
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
    return [self.tutorialArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    if ([self.tutorialArray count] > 0){
        
        NSDictionary *tutorial = self.tutorialArray[indexPath.row];
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
