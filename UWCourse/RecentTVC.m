//
//  RecentTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/16/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "RecentTVC.h"
#import "DetailVC.h"
#import "CourseFetcher.h"

@interface RecentTVC ()

@end

@implementation RecentTVC

-(void)setCourseArray:(NSArray *)courseArray{
    _courseArray = courseArray;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.courseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *course = self.courseArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",course[@"subject"],course[@"catalog_number"]];
    cell.detailTextLabel.text = course[@"title"];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

-(void) fetchDetail:(NSString *)coursename
          courseNum:(NSString *)courseNum
           lecArray:(NSMutableArray *)lectureArray
           tutArray:(NSMutableArray *)tutArray
           tstArray:(NSMutableArray *)tstArray{
    NSURL *url = [CourseFetcher URLForDeatail:coursename courseNum:courseNum ];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    NSArray *subArray = subDic[@"data"];
    
    for (NSDictionary *dic in subArray){
        NSString *section = dic[@"section"];
        if ([section hasPrefix:@"LEC"]){
            [lectureArray addObject:dic];
        } else if ([section hasPrefix:@"TUT"]){
            [tutArray addObject:dic];
        } else {
            [tstArray addObject:dic];
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *course = self.courseArray[indexPath.row];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[DetailVC class]]){
        DetailVC *dvc = segue.destinationViewController;
        dvc.description = course[@"description"];
        dvc.courseName = course[@"subject"];
        dvc.courseNum = course[@"catalog_number"];
        dvc.courseInfo = course;
        
        NSMutableArray *lecArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tutArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tstArray = [[NSMutableArray alloc]initWithArray:@[]];
        
        [self fetchDetail:course[@"subject"] courseNum:course[@"catalog_number"] lecArray:lecArray tutArray:tutArray tstArray:tstArray];
        dvc.tutorialArray = tutArray;
        dvc.lectureArray = lecArray;
        dvc.testArray = tstArray;
    }
}

@end
