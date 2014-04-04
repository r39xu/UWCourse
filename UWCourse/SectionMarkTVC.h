//
//  SectionMarkTVC.h
//  UWCourse
//
//  Created by Jack Xu on 3/24/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionMarkTVC : UITableViewController{
}

@property (nonatomic,strong) NSArray *lectureArray;
@property (nonatomic,strong) NSArray *tutorialArray;
@property (nonatomic,strong) NSArray *testArray;
@property (nonatomic,strong) NSString *courseName;
@property (nonatomic,strong) NSString *courseNum;

@end
