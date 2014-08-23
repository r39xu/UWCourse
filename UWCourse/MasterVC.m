//
//  MasterVC.m
//  UWCourse
//
//  Created by Jack Xu on 3/18/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "MasterVC.h"
#import "CourseFetcher.h"
#import "DetailVC.h"

@interface MasterVC ()

@end

@implementation MasterVC

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
    self.textField.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchDetail:(NSString *)coursename
          courseNum:(NSString *)courseNum
           lecArray:(NSMutableArray *)lectureArray
           tutArray:(NSMutableArray *)tutArray
           tstArray:(NSMutableArray *)tstArray{
    NSURL *url = [CourseFetcher URLForDeatail:coursename courseNum:courseNum ];
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
-(void) fetchCourse: (NSString *)courseName{
    dispatch_queue_t subQueue = dispatch_queue_create("test", NULL);
    dispatch_async(subQueue, ^{
        NSURL *url = [CourseFetcher URLForCourse:courseName];
        NSData *json = [NSData dataWithContentsOfURL:url];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        NSArray *courseArray = subDic[@"data"];
        NSLog(@"%@",courseArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.courseArray = courseArray;
        });
    });
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (![self.textField.text isEqualToString:@""]){
        [self performSegueWithIdentifier:@"Direct" sender:nil];
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.textField resignFirstResponder];
}




// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Direct"]){
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        NSString *message = [[self.textField.text uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSInteger nameIndex = 0;
        NSInteger numIndex = 0;
        for (NSInteger i = 0; i < [message length]; i++){
            char c = [message characterAtIndex:i];
            if (c<'A' || c>'Z'){
                nameIndex = i;
                break;
            }
        }
        
        for (NSInteger i = nameIndex; i< [message length]; i++){
            char c = [message characterAtIndex:i];
            if (c != ' '){
                numIndex = i;
                break;
            }
        }
        
        NSString *courseName = [message substringToIndex:nameIndex];
        NSString *courseNum = [[message substringFromIndex:numIndex]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSURL *url = [CourseFetcher URLForCourse:courseName];
        NSData *json = [NSData dataWithContentsOfURL:url];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        NSArray *courseArray = subDic[@"data"];
        self.courseArray = courseArray;
        
        NSDictionary *course = nil;
        for (NSDictionary *c in self.courseArray){
            if ([c[@"subject"] isEqualToString:courseName] && [c[@"catalog_number"] isEqualToString:courseNum] ){
                course = c;
            }
        }
        
        if (course == nil){
            return;
        }
        
        DetailVC *dvc = segue.destinationViewController;
        dvc.courseName = courseName;
        dvc.courseNum = courseNum;
        
        NSMutableArray *lecArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tutArray = [[NSMutableArray alloc]initWithArray:@[]];
        NSMutableArray *tstArray = [[NSMutableArray alloc]initWithArray:@[]];
        
        [self fetchDetail:courseName courseNum:courseNum lecArray:lecArray tutArray:tutArray tstArray:tstArray];
        dvc.tutorialArray = tutArray;
        dvc.lectureArray = lecArray;
        dvc.testArray = tstArray;
        dvc.courseInfo = course;
        NSUserDefaults *recents = [NSUserDefaults standardUserDefaults];
        if (![recents objectForKey:@"Course List"]){
            NSMutableArray *urlArray = [[NSMutableArray alloc] initWithObjects:course, nil];
            [recents setObject:urlArray forKey:@"Course List"];
        } else {
            NSMutableArray *urlArray = [[NSMutableArray alloc] initWithArray:[recents objectForKey:@"Course List"]];
            BOOL isExist = NO;
            for (NSDictionary *photo in urlArray){
                if ([photo isEqualToDictionary:course]){
                    isExist = YES;
                }
            }
            if (!isExist){
                [urlArray addObject:course];
                [recents setObject:urlArray forKey:@"Course List"];
                [recents synchronize];
            }
        }
    }
}


@end
