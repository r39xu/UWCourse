//
//  BookMarkTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/16/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "BookMarkTVC.h"
#import "CourseFetcher.h"
#import "DetailVC.h"
#import "CustomVC.h"

@interface BookMarkTVC ()

@end

@implementation BookMarkTVC

-(void)setMarkArray:(NSMutableArray *)markArray{
    _markArray = markArray;
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
    return [self.markArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Mark Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *mark = self.markArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@-%@",mark[@"lecture"][0][@"coursename"],mark[@"lecture"][0][@"coursenum"],mark[@"lecture"][0][@"section"]];
    if ([mark objectForKey:@"tutorial"]){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"with %@",[mark objectForKey:@"tutorial"][@"section"]];
    } else {
        cell.detailTextLabel.text = @"";
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSUInteger row = [indexPath row];
        NSDictionary *object = self.markArray[row];
        [self.markArray removeObjectAtIndex:row];
        
        NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
        NSMutableArray *markArray = [[bookmark objectForKey:@"Event List"]mutableCopy];
        [markArray removeObject:object];
        [bookmark setObject:markArray forKey:@"Event List"];
        [bookmark synchronize];
        
        
        NSMutableArray *frameList = [[bookmark objectForKey:@"Frame List"]mutableCopy];
        for (NSDictionary *frameDic in frameList){
            if ([frameDic[@"coursename"] isEqualToString:object[@"coursename"]]){
                if ([frameDic[@"coursenum"] isEqualToString:object[@"coursenum"]]){
                    [frameList removeObject:frameDic];
                    break;
                }
            }
        }
        
        [bookmark setObject:frameList forKey:@"Frame List"];
        [bookmark synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSUInteger count = [self.markArray count];
    
    if (row <= count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
}

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

-(void) fetchDetail:(NSString *)coursename
          courseNum:(NSString *)courseNum
           lecArray:(NSMutableArray *)lectureArray
           tutArray:(NSMutableArray *)tutArray
           tstArray:(NSMutableArray *)tstArray{
    NSURL *url = [CourseFetcher URLForDeatail:coursename courseNum:courseNum];
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
    NSDictionary *course = self.markArray[indexPath.row];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[CustomVC class]]){
        CustomVC *dvc = segue.destinationViewController;
        dvc.courseName = course[@"lecture"][0][@"coursename"];
        dvc.courseNum = course[@"lecture"][0][@"coursenum"];
        
        NSMutableArray *lecArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tutArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tstArray = [[NSMutableArray alloc]initWithArray:@[]];
        
        [self fetchDetail:course[@"lecture"][0][@"coursename"] courseNum:course[@"lecture"][0][@"coursenum"] lecArray:lecArray tutArray:tutArray tstArray:tstArray];
        dvc.tutorialArray = tutArray;
        dvc.lectureArray = lecArray;
        dvc.testArray = tstArray;
    }
}

@end
