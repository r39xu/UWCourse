//
//  SubSubjectTVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/12/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "SubSubjectTVC.h"
#import "CourseFetcher.h"

@interface SubSubjectTVC ()

@end

@implementation SubSubjectTVC

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
	[self fetchSubject];
}

-(void) fetchSubject{
    dispatch_queue_t subQueue = dispatch_queue_create("subect", NULL);
    dispatch_async(subQueue, ^{
        NSURL *url = [CourseFetcher URLForSubject];
        NSData *json = [NSData dataWithContentsOfURL:url];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        NSArray *subArray = subDic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.subjectArray = subArray;
        });
    });
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
