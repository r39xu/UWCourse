//
//  CourseScheduleFetcher.m
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "CourseScheduleFetcher.h"
#import "CourseScheduleFeed.h"
#import "JSONModelLib.h"
@interface CourseScheduleFetcher()
{
    CourseScheduleFeed *feed;
}
@end
@implementation CourseScheduleFetcher
-(CourseScheduleModel*)getSchedule:(NSString*)url{
    feed=[[CourseScheduleFeed alloc] initFromURLWithString:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@/schedule.json?key=bfa6876183c9fe16289b72828224ede2",url ] completion:^(JSONModel *model, JSONModelError *err) {
        //[HUD hideUIBlockingIndicator];
        NSLog(@"Data: %@", feed.data);

    }];
    for (CourseScheduleModel *course in feed.data){
        NSString *section=course.section;
        if ([section rangeOfString:@"TST"].location!=NSNotFound){
            return course;
        }
        
    }
    return NULL;
    //return feed.data;
}
@end
