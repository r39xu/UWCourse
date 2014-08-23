//
//  SubjectScheduleTVC.h
//  UWCourse
//
//  Created by Jack Xu on 3/26/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubjectScheduleTVC : UITableViewController <UISearchBarDelegate>

@property (nonatomic,strong) NSArray *subjectArray;
@property (nonatomic,strong) NSMutableArray *resultArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end