//
//  CourseFetcher.h
//  UWCourse
//
//  Created by Jack Xu on 3/12/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseFetcher : NSObject


+(NSURL *)URLForSubject;
+(NSURL *) URLForCourse:(NSString *) coursename;
+(NSURL *) URLForDeatail:(NSString *)courseName courseNum:(NSString *)courseNum;
@end
