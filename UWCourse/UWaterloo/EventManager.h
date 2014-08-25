//
//  EventManager.h
//  UWaterloo
//
//  Created by Jack Zhang on 7/31/14.
//  Copyright (c) 2014 Jack Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;
-(NSArray *)getLocalEventCalendars;


@end
