//
//  MoreDetailTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/20/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "MoreDetailTVC.h"
#import "DetailCustomCell.h"
#import "WebVC.h"

@interface MoreDetailTVC ()

@end

@implementation MoreDetailTVC

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
    [self changeForm];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) changeForm{
    NSMutableArray *infoArray = [[NSMutableArray alloc]init];
    [infoArray addObject:@{@"head":@"Class Number",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"class_number"]]}];
    [infoArray addObject:@{@"head":@"Campus",
                           @"content":self.section[@"campus"]}];
    [infoArray addObject:@{@"head":@"Entollment Capacity",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"enrollment_capacity"]]}];
    [infoArray addObject:@{@"head":@"Entollment Total",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"enrollment_total"]]}];
    
    NSArray *instructorArray = self.section[@"classes"][0][@"instructors"];
    if ([instructorArray isEqualToArray:@[]]){
        [infoArray addObject:@{@"head":@"Instructor",
                               @"content":@"No Instructor Found"}];

    } else {
        [infoArray addObject:@{@"head":@"Instructor",
                            @"content":instructorArray[0]}];
    }
    [infoArray addObject:@{@"head":@"Term",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"term"]]}];
    [infoArray addObject:@{@"head":@"Last Updated",
                           @"content":self.section[@"last_updated"]}];
    self.infoArray = infoArray;
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
    return [self.infoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail Cell" forIndexPath:indexPath];
    NSDictionary *box = self.infoArray[indexPath.row];
    cell.catagoryLabel.text = box[@"head"];
    cell.infoLabel.text = box[@"content"];
    if ([box[@"head"] isEqualToString:@"Instructor"] && ![box[@"content"] isEqualToString:@"No Instructor Found"]){
        cell.webButton.hidden =NO;
    } else {
        cell.webButton.hidden = YES;
    }
    
    // Configure the cell...
    
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
    if ([segue.destinationViewController isKindOfClass:[WebVC class]]){
        WebVC *wvc = segue.destinationViewController;
        NSDictionary *info  = nil;
        for (NSDictionary *dic in self.infoArray){
            if ([dic[@"head"] isEqualToString:@"Instructor"]){
                info = dic;
            }
        }
        wvc.instructorString = info[@"content"];
    }
}

@end
