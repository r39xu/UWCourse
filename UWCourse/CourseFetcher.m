//
//  CourseFetcher.m
//  UWCourse
//
//  Created by Jack Xu on 3/12/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "CourseFetcher.h"
#import "UWAPI.h"

@implementation CourseFetcher

+(NSURL *) URLForQuery:(NSString *)query{
    query = [NSString stringWithFormat:@"%@?key=%@",query,UWAPIKey];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:query];
    return url;
}

+(NSURL *) URLForCourse:(NSString *) coursename{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/courses/%@.json",coursename]];
}

+(NSURL *) URLForSubject{
    return [self URLForQuery:@"https://api.uwaterloo.ca/v2/codes/subjects.json"];
}

+(NSURL *) URLForDeatail:(NSString *)courseName
               courseNum:(NSString *)courseNum{
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    NSString *term = [bookmark objectForKey:@"Term"];
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.uwaterloo.ca/v2/terms/%@/%@/%@/schedule.json",term,courseName,courseNum]];
}

@end
