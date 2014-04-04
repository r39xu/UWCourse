//
//  SubjectTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/12/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "SubjectScheduleTVC.h"
#import "SubCourseTVC.h"
#import "CourseFetcher.h"

@interface SubjectScheduleTVC ()  {
}

@property (nonatomic,strong) NSMutableArray *indexSubject;
@property (nonatomic,strong) NSMutableArray *indices;
@property (nonatomic) BOOL isFiltered;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@end

@implementation SubjectScheduleTVC
- (IBAction)Close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) fetchSubject{
    //HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
	//HUD.delegate = self;
	//HUD.labelText = @"Loading";
    dispatch_queue_t subQueue = dispatch_queue_create("subect", NULL);
    dispatch_async(subQueue, ^{
         NSURL *url = [CourseFetcher URLForSubject];
            NSData *json = [NSData dataWithContentsOfURL:url];
            NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
            NSArray *subArray = subDic[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.activityind stopAnimating];
                [self.spinner stopAnimating];
                self.subjectArray = subArray;});});
}

-(void)setSubjectArray:(NSArray *)subjectArray{
    _subjectArray = subjectArray;
    self.indexSubject = [self transform:subjectArray];
    self.indices = [self.indexSubject valueForKey:@"headerTitle"];
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

-(NSMutableArray *)transform:(NSArray *) subArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *alphabet = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",
                         @"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"Z",nil];
    for (int i = 0; i < [alphabet count] ; i++){
        NSString *key = alphabet[i];
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        [row setValue:@[] forKey:@"rowValues"];
        [row setValue:key forKey:@"headerTitle"];
        [result addObject:row];
    }
    
    for (NSDictionary *subject in subArray){
        NSString *name = subject[@"subject"];
        NSString *firstChar = [name substringToIndex:1];
        
        for (NSDictionary *row in result){
            if ([firstChar isEqualToString:row[@"headerTitle"]]){
                NSArray *value = [row valueForKey:@"rowValues"];
                NSMutableArray *newValue = [[NSMutableArray alloc] initWithArray:value];
                [newValue addObject:subject];
                [row setValue:newValue forKey:@"rowValues"];
            }
        }
    }
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spinner= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame;
    frame.origin.x = 160;
    frame.origin.y = 240;
    self.spinner.frame = frame;
    [self.tableView addSubview:self.spinner];
    [self.spinner startAnimating];
    [self fetchSubject];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.spinner startAnimating];
    [self fetchSubject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView){
        // Return the number of sections.
        return [self.indices count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView){
        // Return the number of rows in the section.
        return [[[self.indexSubject objectAtIndex:section] objectForKey:@"rowValues"] count];
    } else {
        return [self.resultArray count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Subject Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (tableView == self.tableView){
        // Configure the cell...
        NSDictionary *subject = [[[self.indexSubject objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex: indexPath.row];
        cell.textLabel.text = subject[@"subject"];
        cell.detailTextLabel.text = subject[@"description"];
    } else {
        NSDictionary *subject = self.resultArray[indexPath.row];
        cell.textLabel.text = subject[@"subject"];
        cell.detailTextLabel.text = subject[@"description"];
    }
    return cell;
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView){
        return [[self.indexSubject objectAtIndex:section] objectForKey:@"headerTitle"];
    } else {
        return nil;
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.tableView){
        return self.indices;
    } else {
        return nil;
    }
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0){
        self.isFiltered = NO;
    } else {
        self.isFiltered = YES;
        self.resultArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in self.subjectArray){
            NSString *name = dic[@"subject"];
            NSRange range =  [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (range.location != NSNotFound){
                [self.resultArray addObject:dic];
            }
        }
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.destinationViewController isKindOfClass:[SubCourseTVC class]]){
        if ([segue.identifier isEqualToString:@"Courses"]){
            if (self.searchDisplayController.isActive){
                NSLog(@"gethere");
            }
            SubCourseTVC *sctvc = segue.destinationViewController;
            NSDictionary *subject = [[[self.indexSubject objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex: indexPath.row];
            NSLog(@"%@",subject);
            if (self.searchDisplayController.isActive){
                indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
                sctvc.coursename = self.resultArray[indexPath.row][@"subject"];
                NSLog(@"%@",sctvc.coursename);
            } else{
                sctvc.coursename = subject[@"subject"];
            }
        }
    }
}


@end
