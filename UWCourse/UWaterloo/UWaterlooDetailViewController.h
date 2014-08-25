//
//  UWaterlooDetailViewController.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/13/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UWaterlooDetailViewController : UIViewController

- (IBAction)addCourse:(UIBarButtonItem *)sender;

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *course_id;
@property (strong, nonatomic) IBOutlet UILabel *subject;
@property (strong, nonatomic) IBOutlet UILabel *catelog_number;
@property (strong, nonatomic) IBOutlet UITextView *description;

@property (strong, nonatomic) IBOutlet UILabel *academic_level;

@property (strong,nonatomic) NSString *course_idValue;
@property (strong,nonatomic) NSString *subjectValue;
@property (strong,nonatomic) NSString *catelog_numberValue;
@property (strong,nonatomic) NSString *descriptionValue;
@property (strong,nonatomic) NSString *academic_levelValue;

@end
