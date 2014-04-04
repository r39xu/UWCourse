//
//  CourseTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/13/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "CourseTVC.h"
#import "DetailVC.h"
#import "CourseFetcher.h"
#import "SectionMarkTVC.h"
#import "CustomVC.h"
@interface CourseTVC () 

@end

@implementation CourseTVC

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *course = self.courseArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",course[@"subject"],course[@"catalog_number"]];
    cell.detailTextLabel.text = course[@"title"];
    
    return cell;
}



#pragma mark - Navigation

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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	//[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	//HUD.delegate = self;
    
    //[HUD show:YES];
    if ([segue.identifier isEqualToString:@"Display Detail"]){
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *course = self.courseArray[indexPath.row];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[DetailVC class]]){
        DetailVC *dvc = segue.destinationViewController;
        dvc.description = course[@"description"];
        dvc.courseName = course[@"subject"];
        dvc.courseNum = course[@"catalog_number"];
        
        NSMutableArray *lecArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tutArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tstArray = [[NSMutableArray alloc]initWithArray:@[]];
        
        [self fetchDetail:course[@"subject"] courseNum:course[@"catalog_number"] lecArray:lecArray tutArray:tutArray tstArray:tstArray];
        NSLog(@"%@",lecArray);
        dvc.tutorialArray = tutArray;
        dvc.lectureArray = lecArray;
        dvc.testArray = tstArray;
        dvc.courseInfo = course;
        NSUserDefaults *recents = [NSUserDefaults standardUserDefaults];
        if (![recents objectForKey:@"Course List"]){
            NSMutableArray *urlArray = [[NSMutableArray alloc] initWithObjects:self.courseArray[indexPath.row], nil];
            [recents setObject:urlArray forKey:@"Course List"];
        } else {
            NSMutableArray *urlArray = [[NSMutableArray alloc] initWithArray:[recents objectForKey:@"Course List"]];
            BOOL isExist = NO;
            for (NSDictionary *photo in urlArray){
                if ([photo isEqualToDictionary:self.courseArray[indexPath.row]]){
                    isExist = YES;
                }
            }
            if (!isExist){
                [urlArray addObject:self.courseArray[indexPath.row]];
                [recents setObject:urlArray forKey:@"Course List"];
                [recents synchronize];
            }
        }
    }
        if ([segue.destinationViewController isKindOfClass:[CustomVC class]]){
            CustomVC *smtvc = segue.destinationViewController;
            NSMutableArray *lecArray = [[NSMutableArray alloc]initWithArray:@[]];
            NSMutableArray *tutArray = [[NSMutableArray alloc]initWithArray:@[]];
            NSMutableArray *tstArray = [[NSMutableArray alloc]initWithArray:@[]];
            
            
            NSUserDefaults *recents = [NSUserDefaults standardUserDefaults];
            if (![recents objectForKey:@"Course List"]){
                NSMutableArray *urlArray = [[NSMutableArray alloc] initWithObjects:self.courseArray[indexPath.row], nil];
                [recents setObject:urlArray forKey:@"Course List"];
            } else {
                NSMutableArray *urlArray = [[NSMutableArray alloc] initWithArray:[recents objectForKey:@"Course List"]];
                BOOL isExist = NO;
                for (NSDictionary *photo in urlArray){
                    if ([photo isEqualToDictionary:self.courseArray[indexPath.row]]){
                        isExist = YES;
                    }
                }
                if (!isExist){
                    [urlArray addObject:self.courseArray[indexPath.row]];
                    [recents setObject:urlArray forKey:@"Course List"];
                    [recents synchronize];
                }
            }

            [self fetchDetail:course[@"subject"] courseNum:course[@"catalog_number"] lecArray:lecArray tutArray:tutArray tstArray:tstArray];
            smtvc.tutorialArray = tutArray;
            smtvc.lectureArray = lecArray;
            smtvc.testArray = tstArray;
            smtvc.courseName = course[@"subject"];
            smtvc.courseNum = course[@"catalog_number"];
            //[HUD hide:YES];
        }
        
  }
}

@end
