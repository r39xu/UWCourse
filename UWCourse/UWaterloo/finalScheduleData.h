//
//  finalScheduleData.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/18/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "finalScheduleModel.h"
@protocol finalScheduleData @end
@interface finalScheduleData : JSONModel
@property (strong,nonatomic) NSString* course;
@property (strong, nonatomic) NSArray<NSObject>* sections;
@end
