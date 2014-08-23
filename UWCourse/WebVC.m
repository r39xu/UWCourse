//
//  WebVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/21/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()

@end

@implementation WebVC

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
    NSInteger surnameIndex = 0;
    NSInteger firstnameIndex = 0;
    for (NSInteger i = 0; i < [self.instructorString length] ; i++){
        char c = [self.instructorString characterAtIndex:i];
        if (c == ','){
            surnameIndex = i;
            firstnameIndex = i+1;
            break;
        }
    }
    
    NSString *surname = [self.instructorString substringToIndex:surnameIndex];
    NSString *firstname = [self.instructorString substringFromIndex:firstnameIndex];
    
    NSLog(@"%@",self.instructorString);
    NSLog(@"%@",surname);
    NSLog(@"%@",firstname);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ratemyprofessors.com/search.jsp?query1=%@+%@&queryoption1=TEACHER&search_submit1=Search&prerelease=true",firstname,surname]]]];
    [self.webView addSubview:self.activityInd];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loading) userInfo:nil repeats:YES];
    
}


-(void)loading{
    if (!self.webView.loading){
        [self.activityInd stopAnimating];
    } else {
        [self.activityInd startAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
