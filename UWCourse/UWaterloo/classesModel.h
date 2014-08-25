//
//  classesModel.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/15/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "dateModel.h"
#import "locationModel.h"
@protocol classesModel @end
@interface classesModel : JSONModel

@property (strong,nonatomic) NSObject *date;
@property(strong,nonatomic) NSObject *location;
@property(strong,nonatomic) NSArray *instructors;
@end
