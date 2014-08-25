//
//  finalScheduleModel.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/18/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
@protocol finalScheduleModel @end
@interface finalScheduleModel : JSONModel
@property (strong, nonatomic) NSString* section;
@property (strong, nonatomic) NSString* day;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* start_time;
@property (strong, nonatomic) NSString* end_time;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSString* notes;
@end
