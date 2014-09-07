//
//  scheduleFetcher.m
//  UWCourse
//
//  Created by Jack Zhang on 8/24/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "scheduleFetcher.h"
#import "LeafNotification.h"
#import "CourseScheduleModel.h"
#import "CourseScheduleFeed.h"
#import "JSONModelLib.h"
#import "finalScheduleFeed.h"
@interface scheduleFetcher(){
    CourseScheduleFeed *feed;
    finalScheduleFeed *finalFeed;
}
@end
@implementation scheduleFetcher


- (void)scheduleFetch: (NSString*) courseUrl {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString *url=[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/schedule.json?key=bfa6876183c9fe16289b72828224ede2",courseUrl];
    feed=[[CourseScheduleFeed alloc] initFromURLWithString:url completion:^(JSONModel *model, JSONModelError *err) {
        
        
        /*NSError *error = nil;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Courses"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"catalog_number = %@", courseUrl]];
        //[request setFetchLimit:1];
        NSUInteger count = [context countForFetchRequest:request error:&error];
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            
        }*/
        int count=0;
        if (count == 0){
            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Courses" inManagedObjectContext:context];
            [newDevice setValue:courseUrl forKey:@"catalog_number"];
            for (CourseScheduleModel *course in feed.data){
                NSString *section=course.section;
                if ([section rangeOfString:@"TST"].location!=NSNotFound){
                    //NSString *str=course.section;
                    classesModel *class=course.classes[0];
                    
                    [newDevice setValue:[class.date valueForKey:@"start_time"] forKey:@"midtermStart_time"];
                    [newDevice setValue:[class.date valueForKey:@"end_time"] forKey:@"midtermEnd_time"];
                    //[newDevice setValue:[class.date valueForKey:@"weekdays"] forKey:@"weekdays"];
                    [newDevice setValue:[class.date valueForKey:@"start_date"] forKey:@"midtermDate"];
                    
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"HH:mm/MM/dd/yyyy"];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy"];
                    NSString *yearString = [formatter stringFromDate:[NSDate date]];
                    
                    NSString *str=[NSString stringWithFormat:@"%@/%@/%@",[class.date valueForKey:@"start_time"],[class.date valueForKey:@"start_date"],yearString];
                    
                     NSString *str2=[NSString stringWithFormat:@"%@/%@/%@",[class.date valueForKey:@"end_time"],[class.date valueForKey:@"start_date"],yearString];
                    
                    NSManagedObject *Device2 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
                    NSDate *startDate=[dateFormat dateFromString:str];
                    [Device2 setValue:startDate forKey:@"taskFullDate"];
                    NSDate *endDate=[dateFormat dateFromString:str2];
                    [Device2 setValue:endDate forKey:@"taskFullEndDate"];
                    [dateFormat setDateFormat:@"HH:mm"];
                    NSDate *startTime=[dateFormat dateFromString:[class.date valueForKey:@"start_time"]];
                    [Device2 setValue:startTime forKey:@"taskStartTime"];
                    NSDate *endTime=[dateFormat dateFromString:[class.date valueForKey:@"end_time"]];
                    [Device2 setValue:endTime  forKey:@"taskEndTime"];
                    [dateFormat setDateFormat:@"MM/dd"];
                    NSDate *date=[dateFormat dateFromString:[class.date valueForKey:@"start_date"]];
                    [Device2 setValue:date  forKey:@"taskDate"];
                    //find the Day of the event
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"EEEE"];
                    NSString *dayName = [dateFormatter stringFromDate:date];
                    [Device2 setValue:dayName forKey:@"taskDay"];
                    NSString *name1 = [[NSString stringWithFormat:@"%@ Midterm",courseUrl] stringByReplacingOccurrencesOfString:@"/"
                                                                                                                  withString:@" "];
                    [Device2 setValue:name1 forKey:@"taskName"];
                    
                    
                    
                    NSString *url=[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/examschedule.json?key=bfa6876183c9fe16289b72828224ede2",courseUrl];
                    finalFeed=[[finalScheduleFeed alloc] initFromURLWithString:url completion:^(JSONModel *model, JSONModelError *err) {
                        //[HUD hideUIBlockingIndicator];
                        finalScheduleModel* section= finalFeed.data.sections[0];
                        [newDevice setValue:[section valueForKey:@"start_time"]forKey:@"finalStart_Time"];
                        [newDevice setValue:[section valueForKey:@"end_time"] forKey:@"finalEnd_Time"];
                        [newDevice setValue:[section valueForKey:@"date"] forKey:@"finalDate"];
                        [newDevice setValue:[section valueForKey:@"day"] forKey:@"finalDay"];
                        [newDevice setValue:[section valueForKey:@"location"] forKey:@"finalLocation"];
                        
                        
                        [dateFormat setDateFormat:@"yyyy-MM-dd/hh:mm a"];
                        
                        NSString *str=[NSString stringWithFormat:@"%@/%@",[section valueForKey:@"date"],[section valueForKey:@"start_time"]];
                        NSManagedObject *Device2 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
                        NSDate *startDate=[dateFormat dateFromString:str];
                        

                        
                        [Device2 setValue:startDate forKey:@"taskFullDate"];
                        [dateFormat setDateFormat:@"HH:mm"];
                        NSDate *startTime=[dateFormat dateFromString:[section valueForKey:@"start_time"]];
                        [Device2 setValue:startTime forKey:@"taskStartTime"];
                        NSDate *endTime=[dateFormat dateFromString:[section valueForKey:@"end_time"]];
                        [Device2 setValue:endTime  forKey:@"taskEndTime"];
                        [dateFormat setDateFormat:@"MM/dd"];
                        
                        NSDate *date=[dateFormat dateFromString:[section valueForKey:@"start_date"]];
                        [Device2 setValue:date forKey:@"taskDate"];
                        NSString *name = [[NSString stringWithFormat:@"%@ Final",courseUrl] stringByReplacingOccurrencesOfString:@"/"
                                                                    withString:@" "];
                        [Device2 setValue:name forKey:@"taskName"];
                        [Device2 setValue:[section valueForKey:@"location"] forKey:@"taskLocation"];
                        NSLog(@"Data: %@", finalFeed.data.course);
                        
                    }];
                    
                    
                }
                
            }
            
            //[LeafNotification showInController:self withText:@"Course Added!" type:LeafNotificationTypeSuccess];
            
            
        } else {
            //[LeafNotification showInController:self withText:@"Course Already Exists!"];
        }
        
        
        //[HUD hideUIBlockingIndicator];
        NSLog(@"Data: %@", feed.data);
        
    }];
    // Create a new managed object
    
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
        NSString *str= context.persistentStoreCoordinator.managedObjectModel.entities;
    }
    return context;
}
@end
