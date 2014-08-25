//
//  courseModel.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/13/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol courseModel @end


@interface courseModel : JSONModel
@property (strong, nonatomic) NSString *course_id;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *catalog_number;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *units;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *academic_level;
//@property (strong, nonatomic) NSString *fullname;
@end
