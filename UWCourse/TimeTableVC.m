//
//  ViewController.m
//  TimeTableDemo
//
//  Created by Jack on 2014-06-08.
//  Copyright (c) 2014 Jack App Factory. All rights reserved.
//

#import "TimeTableVC.h"
#import "EventVCViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CCOLOR [UIColor clearColor]


@interface TimeTableVC () {
    
    UIScrollView *scrollview;
    
    float xMargin;
    float yMargin;
    int numOfDay;
    int numOfHour;
    float hourHeight;
    float dayWidth;
}

@end

@implementation TimeTableVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[EventVCViewController class]]) {
            [vc removeFromParentViewController];
            [vc.view removeFromSuperview];
        }
    }
    [self drawFrame];
    [self drawEvents];
}


- (void)viewDidLoad
{
    CGRect fullScreenRect= [[UIScreen mainScreen] applicationFrame];
    scrollview=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollview.contentSize=CGSizeMake(450,540);
    scrollview.delegate = self;
    
    dayWidth = 75;
    hourHeight = 25;
    numOfDay = 5;
    numOfHour = 16;
    xMargin = 20;
    yMargin = 50;
    
    [self drawFrame];
    [self drawEvents];
    
    [scrollview setScrollEnabled:YES];
    scrollview.maximumZoomScale = 3.0f;
    [scrollview setZoomScale:3.0f];
}

#pragma mark - Scrolll view Delegate




#pragma mark - Draw Event Utility

-(void) drawEvents {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *eventList = [defaults objectForKey:@"Event List"];
    NSLog(@"%@",eventList);
    
    for (NSDictionary *course in eventList) {
        
        // Draw LEC
        NSArray *lectureArray = course[@"lecture"];
        for (NSDictionary *lecture in lectureArray) {
            
            // weekdays
            NSString *weekdays = lecture[@"weekdays"];
            NSArray *daysArray = [self parseWeekdays:weekdays];
            
            // time
            NSString *startTime = lecture[@"start_time"];
            NSString *endTime = lecture[@"end_time"];
            int startHour = [startTime substringWithRange:(NSRange){0,2}].intValue;
            int startMinute = [startTime substringWithRange:(NSRange){3,2}].intValue;
            int endHour = [endTime substringWithRange:(NSRange){0,2}].intValue;
            int endMinute = [endTime substringWithRange:(NSRange){3,2}].intValue;
            
            // location
            NSString *location = lecture[@"location"];
            
            // otherInfo
            NSString *title = [NSString stringWithFormat:@"%@ %@ - %@", course[@"lecture"][0][@"coursename"], course[@"lecture"][0][@"coursenum"], lecture[@"section"]];
            NSString *instructor = lecture[@"instructor"];
            
            float originX, originY, height;
            for (int i = 0; i < daysArray.count; ++i) {
                originX = 50 + ([(NSNumber *)[daysArray objectAtIndex:i] intValue]-1) * dayWidth;
                originY = ((float)(startHour*60 + startMinute - 7*60) /60) * 25 + 95;
                height = ((float)(endHour*60 + endMinute - startHour*60 - startMinute) /60) * 25;
                EventVCViewController *courseEvent = [EventVCViewController new];
                courseEvent.view.frame = (CGRect){originX,originY,dayWidth,height};
                courseEvent.view.backgroundColor = RGBA(65, 170, 60, 0.4);
                courseEvent.view.layer.borderColor = RGBA(65, 170, 60, 1.0).CGColor;
                courseEvent.type = @[@"lecture"].mutableCopy;
                courseEvent.titles = @[title].mutableCopy;
                courseEvent.location = @[location].mutableCopy;
                courseEvent.instructor = nil;
                courseEvent.startTime = @[startTime].mutableCopy;
                courseEvent.endTime = @[endTime].mutableCopy;
                courseEvent.weekdays = @[weekdays].mutableCopy;
                [self addChildViewController:courseEvent];
                [scrollview addSubview:courseEvent.view];
                [courseEvent didMoveToParentViewController:self];
            }
        }
    }
}

-(NSArray*)parseWeekdays:(NSString*)weekdays
{
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < weekdays.length; ++i) {
        char day = [weekdays characterAtIndex:i];
        switch (day) {
            case 'M':
                [daysArray addObject:@(1)];
                break;
            case 'W':
                [daysArray addObject:@(3)];
                break;
            case 'F':
                [daysArray addObject:@(5)];
                break;
            case 'T':
                if (i+1 < weekdays.length && [weekdays characterAtIndex:i+1] == 'h') {
                    [daysArray addObject:@(4)];
                    ++i;
                } else {
                    [daysArray addObject:@(2)];
                }
                break;
            default:
                break;
        }
    }
    return daysArray;
}

    
#pragma mark - Draw Table Utility


- (void)drawFrame {
    
    //draw basic frame
    UIView *FirstHorizontalLine = [[UIView alloc] initWithFrame:(CGRect){20, 50, 405, 1}];
    UIView *SecondHorizontalLine = [[UIView alloc] initWithFrame:(CGRect){20, 70, 405, 1}];
    FirstHorizontalLine.backgroundColor = RGBA(240, 240, 240, 0.8);
    SecondHorizontalLine.backgroundColor = RGBA(240, 240, 240, 0.8);
    
    [scrollview addSubview:FirstHorizontalLine];
    [scrollview addSubview:SecondHorizontalLine];
    
    [self drawVerticalLineAtWidth:50];
    
    UIView *headerLayer = [[UIView alloc] initWithFrame:(CGRect){20, 50, 407.5, 20}];
    headerLayer.backgroundColor = RGBA(212, 212, 212, 0.7);
    [scrollview addSubview:headerLayer];
    
    for (int i = 0; i < numOfHour; i++) {
        NSInteger hour = i + 7;
        [self drawHorizontalLineAtHeight:95+i*hourHeight width:50];
        [self drawTimeLabelWithTime:hour atHeight:95+i*hourHeight];
    }
    
    NSArray *dayArray = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri"];
    
    for (int i = 0; i < numOfDay; i++) {
        
        [self drawVerticalLineAtWidth:125+dayWidth*i];
        [self drawDays:dayArray[i] atWidht:50+i*75];
    }
    
    //fill Tuesday and Tursday with grey block
    
    for (int i = 0; i < 17; i++) {
        UIView *greyblockForTue = [[UIView alloc] initWithFrame:(CGRect){125, 71+i*25, 75, 24}];
        greyblockForTue.backgroundColor = RGBA(250, 250, 250, 0.8);
        UIView *greyblockForTur = [[UIView alloc] initWithFrame:(CGRect){275, 71+i*25, 75, 24}];
        greyblockForTur.backgroundColor = RGBA(250, 250, 250, 0.8);
        
        [scrollview addSubview:greyblockForTue];
        [scrollview addSubview:greyblockForTur];
    }
    
    [self.view addSubview:scrollview];
    
}

- (void)drawHorizontalLineAtHeight:(float)height width:(float)width
{
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){width, height, 375, 1}];
    //lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lineView.backgroundColor = RGBA(220, 220, 220, 0.7);
    [scrollview addSubview:lineView];
}

- (void)drawVerticalLineAtWidth:(float)width
{
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){width, 70, 2, 470}];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    lineView.backgroundColor = RGBA(240, 240, 240, 0.7);
    [scrollview addSubview:lineView];
}


-(void)drawTimeLabelWithTime:(int)time atHeight:(float)height
{
    if (time == 12) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:(CGRect){20,height-12.5,30,25}];
        timeLabel.text = [NSString stringWithFormat:@"noon"];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = RGBA(49, 51, 49, 0.7);
        timeLabel.font = [UIFont boldSystemFontOfSize:10];
        [scrollview addSubview:timeLabel];
        return;
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:(CGRect){20,height-12.5,15,25}];
    if (time > 12){
        timeLabel.text = [NSString stringWithFormat:@"%d", time-12];
    } else {
        timeLabel.text = [NSString stringWithFormat:@"%d", time];
    }
    
    timeLabel.textColor = RGBA(49, 51, 49, 0.7);
    timeLabel.font = [UIFont boldSystemFontOfSize:10];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    UILabel *APMLabel = [[UILabel alloc] initWithFrame:(CGRect){35,height-12.5,15,25}];
    if (time > 12) {
        APMLabel.text = @"PM";
    } else {
        APMLabel.text = @"AM";
    }
    APMLabel.font = [UIFont systemFontOfSize:8];
    APMLabel.textColor = RGBA(83, 87, 83, 0.7);
    APMLabel.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:APMLabel];
    
    [scrollview addSubview:timeLabel];
}

-(void) drawDays:(NSString *)title atWidht:(float) width {
     UILabel *dayLabel = [[UILabel alloc] initWithFrame:(CGRect){width , 50 , 75, 20}];
    dayLabel.text = title;
    dayLabel.font = [UIFont boldSystemFontOfSize:12];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.textColor = RGBA(83, 87, 83, 0.7);
    [scrollview addSubview:dayLabel];
}


@end
