//
//  locationModel.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
@protocol locationModel @end
@interface locationModel : JSONModel
@property (strong, nonatomic) NSString *building;
@property (strong, nonatomic) NSString *room;
@end
