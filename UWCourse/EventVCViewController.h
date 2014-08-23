//
//  EventVCViewController.h
//  UWCourse
//
//  Created by Jack on 2014-08-23.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventVCViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *type;
@property (strong, nonatomic) NSMutableArray *location;
@property (strong, nonatomic) NSMutableArray *instructor;
@property (strong, nonatomic) NSMutableArray *startTime;
@property (strong, nonatomic) NSMutableArray *endTime;
@property (strong, nonatomic) NSMutableArray *weekdays;


-(void)setTitles:(NSMutableArray *)titles;
-(void)setLocation:(NSMutableArray *)location;

@end
