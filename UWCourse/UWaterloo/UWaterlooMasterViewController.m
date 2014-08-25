//
//  UWaterlooMasterViewController.m
//  UWaterloo
//
//  Created by Jack Zhang on 7/13/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "UWaterlooMasterViewController.h"

#import "UWaterlooDetailViewController.h"

#import "JSONModelLib.h"
#import "CourseFeed.h"
#import "HUD.h"

#import "CourseScheduleFeed.h"

@interface UWaterlooMasterViewController ()
{
    CourseFeed *feed;
    CourseScheduleFeed *feed2;
    bool feedComplted;
    NSArray *searchResult;
}

@end


@implementation UWaterlooMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[HUD showUIBlockingIndicatorWithText:@"Loading"];
    feed=[[CourseFeed alloc] initFromURLWithString:@"https://api.uwaterloo.ca/v2/courses/CS.json?key=bfa6876183c9fe16289b72828224ede2" completion:^(JSONModel *model, JSONModelError *err) {
        //[HUD hideUIBlockingIndicator];
        //NSLog(@"Data: %@", feed.data);
        for (courseModel *course in feed.data){
            NSString *fullname=[NSString stringWithFormat:@"%@/%@",course.subject ,course.catalog_number];
            course.catalog_number=fullname;
            
        }
        [self.tableView reloadData];
        feedComplted=false;
    }];
    self.tableView.backgroundColor=[UIColor brownColor];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==self.searchDisplayController.searchResultsTableView){
        return [searchResult count];
    } else {
        return [feed.data count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"courseItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (tableView ==self.searchDisplayController.searchResultsTableView){
        courseModel *course=searchResult[indexPath.row];
        cell.textLabel.text=course.catalog_number;
    } else {
        courseModel *course=feed.data[indexPath.row];
        cell.textLabel.text = course.catalog_number;
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!feedComplted){
    //[HUD showUIBlockingIndicatorWithText:@"Loading"];
      //  feedComplted=true;
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCourseDetail"]) {
        NSIndexPath *indexPath = nil;
 
        UWaterlooDetailViewController *destViewController = segue.destinationViewController;
        if ([self.searchDisplayController isActive]){
            indexPath=[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            courseModel *course=[searchResult objectAtIndex:indexPath.row];
            destViewController.course_idValue=course.course_id;
            destViewController.subjectValue=course.subject;
            destViewController.academic_levelValue=course.academic_level;
            destViewController.catelog_numberValue=course.catalog_number;
            destViewController.descriptionValue=course.description;
            
        } else {
            indexPath=[self.tableView indexPathForSelectedRow];
        courseModel *course=feed.data[indexPath.row];
        destViewController.course_idValue=course.course_id;
        destViewController.subjectValue=course.subject;
        destViewController.academic_levelValue=course.academic_level;
        destViewController.catelog_numberValue=course.catalog_number;
        destViewController.descriptionValue=course.description;
        
        
        
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.searchDisplayController.searchResultsTableView){
        [self performSegueWithIdentifier:@"showCourseDetail" sender:self];
    }
}

- (void) filterContentForSearchText:(NSString*)searchText scope:(NSString*) scope{
    NSPredicate *Predicatecontains=[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    NSPredicate *resultPredicate =[NSPredicate predicateWithBlock:^BOOL(courseModel *evaluatedObject, NSDictionary *bindings) {
        return [Predicatecontains evaluateWithObject:evaluatedObject.catalog_number];
        //[evaluatedObject.catalog_number hasPrefix:searchText];
    }];
   /* NSPredicate *resultPredicate=[NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
        searchResult = [feed.data filteredArrayUsingPredicate:resultPredicate];*/
    //[NSPredicate predicateWithFormat:@"SELF contains[cd] %@",  searchText];
    
    searchResult = [feed.data filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

@end
