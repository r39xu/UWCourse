//
//  SubCourseTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/13/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "SubCourseTVC.h"
#import "CourseFetcher.h"
#import "Reachability.h"

@interface SubCourseTVC ()

@end

@implementation SubCourseTVC

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)name:kReachabilityChangedNotification object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    
    [reach startNotifier];
    
}
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        [self fetchCourse];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NO INTERNET" message:@"FUCK" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) fetchCourse{
    dispatch_queue_t subQueue = dispatch_queue_create("subect", NULL);
    dispatch_async(subQueue, ^{
        NSURL *url = [CourseFetcher URLForCourse:self.coursename];
        NSData *json = [NSData dataWithContentsOfURL:url];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        NSArray *courseArray = subDic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.courseArray = courseArray;
        });
    });
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
