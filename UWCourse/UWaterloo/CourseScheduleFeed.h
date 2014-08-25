//
//  CourseScheduleFeed.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "CourseScheduleModel.h"
@protocol CourseScheduleFeed @end

@interface CourseScheduleFeed : JSONModel
@property (strong,nonatomic) NSArray<CourseScheduleModel> *data;
@end
