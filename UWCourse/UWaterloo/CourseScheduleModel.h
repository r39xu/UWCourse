//
//  CourseScheduleModel.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "classesModel.h"
@protocol CourseScheduleModel @end

@interface CourseScheduleModel : JSONModel

@property(strong, nonatomic) NSString *subject;
@property(strong, nonatomic) NSString *catalog_number;
@property(strong, nonatomic) NSString *section;
@property(strong, nonatomic) NSString *enrollment_capacity;
@property(strong, nonatomic) NSString *enrollment_total;
@property(strong, nonatomic) NSString *waiting_capacity;
@property(strong, nonatomic) NSString *waiting_total;
@property(strong,nonatomic) NSArray<classesModel> *classes;
@property(strong, nonatomic) NSString *last_updated;
@property(strong, nonatomic) NSString *term;
@property(strong, nonatomic) NSString *academic_level;


@end
