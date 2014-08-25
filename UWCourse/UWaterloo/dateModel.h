//
//  dateModel.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
@protocol dataModel @end
@interface dateModel : JSONModel
@property (strong, nonatomic) NSString *start_time;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *weekdays;
@property (strong, nonatomic) NSString *start_date;
@property (strong, nonatomic) NSString *end_date;
@property (strong,nonatomic) NSString *is_tba;
@property (strong,nonatomic) NSString *is_cancelled;
@property (strong,nonatomic) NSString *is_closed;
@end
