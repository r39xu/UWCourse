//
//  finalScheduleFeed.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/18/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "finalScheduleData.h"
@interface finalScheduleFeed : JSONModel
@property (strong,nonatomic) finalScheduleData* data;
@end
