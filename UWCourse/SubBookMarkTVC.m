//
//  SubBookMarkTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/16/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "SubBookMarkTVC.h"

@interface SubBookMarkTVC ()

@end

@implementation SubBookMarkTVC

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
    [self fetchMark];
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchMark];
}

-(void)fetchMark{
    
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    NSMutableArray *markArray = [[NSMutableArray alloc] initWithArray:[bookmark objectForKey:@"Event List"]];;
    self.markArray = markArray;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
