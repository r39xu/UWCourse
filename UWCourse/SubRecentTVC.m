//
//  SubRecentTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/16/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "SubRecentTVC.h"

@interface SubRecentTVC ()

@end

@implementation SubRecentTVC

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
    [self fetchRecent];
}
-(void)viewWillAppear:(BOOL)animated{
    [self fetchRecent];
}

-(void)fetchRecent{
    NSUserDefaults *recent = [NSUserDefaults standardUserDefaults];
    NSMutableArray *courses = [recent objectForKey:@"Course List"];
    self.courseArray = courses;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
