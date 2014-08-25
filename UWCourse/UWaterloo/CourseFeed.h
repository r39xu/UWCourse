//
//  CourseFeed.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/13/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "courseModel.h"
@protocol CourseFeed @end

@interface CourseFeed : JSONModel
@property (strong, nonatomic) NSArray<courseModel> * data;

@end
