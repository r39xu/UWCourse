//
//  DetailVC.h
//  UWCourse
//
//  Created by Jack Xu on 3/13/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UIViewController {
    NSMutableArray *lecArray;
    NSMutableArray *tutArray;
    NSMutableArray *tstArray;
    IBOutlet UITableView *tableView;
    
}

@property (nonatomic,strong) NSString *courseName;
@property (nonatomic,strong) NSString *courseNum;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSArray *lectureArray;
@property (nonatomic,strong) NSArray *tutorialArray;
@property (nonatomic,strong) NSArray *testArray;
@property (nonatomic,strong) NSDictionary *courseInfo;

@end
