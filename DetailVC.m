//
//  DetailVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/13/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "DetailVC.h"
#import "CourseFetcher.h"
#import "CustomCell.h"
#import "MoreDetailTVC.h"


@interface DetailVC () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (nonatomic) BOOL isLEC;
@property (nonatomic) BOOL isTUT;
@property (nonatomic) BOOL isTST;
@end

@implementation DetailVC
- (IBAction)changeTable:(id)sender {
    if (self.segControl.selectedSegmentIndex == 0){
        self.isLEC = YES;
        self.isTUT = NO;
        self.isTST = NO;
        [tableView reloadData];
    } else if (self.segControl.selectedSegmentIndex == 1){
        self.isLEC = NO;
        self.isTUT = YES;
        self.isTST = NO;
        [tableView reloadData];
    } else {
        self.isLEC = NO;
        self.isTUT = NO;
        self.isTST = YES;
        [tableView reloadData];
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
    self.isLEC = YES;
    self.isTUT = NO;
    self.isTST = NO;
    lecArray = [[NSMutableArray alloc]initWithArray:self.lectureArray];
    tstArray = [[NSMutableArray alloc]initWithArray:self.testArray];
    tutArray = [[NSMutableArray alloc] initWithArray:self.tutorialArray];
    for (NSDictionary *dic in lecArray){
        NSDictionary *date = dic[@"classes"][0][@"date"];
        if (![date[@"start_time"] isKindOfClass:[NSString class]] ){
            NSLog(@"%@",dic);
            [lecArray removeObject:dic];
        }
    }
    
    /*
    self.title = [NSString stringWithFormat:@"%@ %@",self.courseName,self.courseNum];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }
    
    
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 44.5+yDelta, 310, 50)];
    self.segmentedControl4.sectionTitles = @[@"TUT", @"LEC", @"TST"];
    self.segmentedControl4.selectedSegmentIndex = 1;
    self.segmentedControl4.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.segmentedControl4.textColor = [UIColor whiteColor];
    self.segmentedControl4.selectedTextColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    self.segmentedControl4.tag = 3;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl4 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(320 * index, 0, 320, 304) animated:YES];
    }];
    [self.view addSubview:self.segmentedControl4];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85+yDelta, 320, 304)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(960,304);
    [self.scrollView scrollRectToVisible:CGRectMake(320, 0 ,320, 304) animated:YES];
    [self.view addSubview:self.scrollView];
    
    
    self.tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(330, 0, 310, 200)];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.scrollView addSubview:self.tableView1];
    
    
    self.tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 310, 200)];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.scrollView addSubview:self.tableView2];
     */

}

//Button methods


-(void) fetchDetail:(NSString *)coursename
          courseNum:(NSString *)courseNum
           lecArray:(NSMutableArray *)lectureArray
           tutArray:(NSMutableArray *)tutArray
           tstArray:(NSMutableArray *)tstArray
               term:(NSString *) term{
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




//table delegete

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
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",
                               date[@"weekdays"],date[@"start_time"],
                               date[@"end_time"]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
