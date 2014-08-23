//
//  CustomVC.h
//  UWCourse
//
//  Created by Jack Xu on 3/25/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomVC : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    IBOutlet UITableView *tableView;
    NSMutableArray *lecArray;
    NSMutableArray *tutArray;
    NSMutableArray *tstArray;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic,strong) NSArray *lectureArray;
@property (nonatomic,strong) NSArray *tutorialArray;
@property (nonatomic,strong) NSArray *testArray;
@property (nonatomic,strong) NSString *courseName;
@property (nonatomic,strong) NSString *courseNum;

@end
