//
//  EventVCViewController.m
//  UWCourse
//
//  Created by Jack on 2014-08-23.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import "EventVCViewController.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CCOLOR [UIColor clearColor]

@interface EventVCViewController ()

@end

@implementation EventVCViewController {
    UILabel *titleLabel;
    UILabel *locationLabel;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.cornerRadius = 8.0f;
    self.view.layer.borderWidth = 1.0f;
    self.view.userInteractionEnabled = YES;
    
    float height = 10;
    NSLog(@"%f", self.view.frame.size.height);
    
    titleLabel = [UILabel new];
    titleLabel.frame = (CGRect){0,2,75,height};
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGB(100, 50, 150);
    titleLabel.font = [UIFont systemFontOfSize:7];
//    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    titleLabel.backgroundColor = CCOLOR;
    [self.view addSubview:titleLabel];
    
//    int y = CGRectGetMaxY(titleLabel.frame);
    
    locationLabel = [UILabel new];
    locationLabel.frame = (CGRect){0,12,75,height};
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.textColor = RGB(100, 50, 150);
    locationLabel.font = [UIFont systemFontOfSize:7];
//    locationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    locationLabel.backgroundColor = CCOLOR;
    [self.view addSubview:locationLabel];
    
}


-(void)setTitles:(NSMutableArray *)titles
{
    _titles = titles;
    if (titles.count == 1) {
        titleLabel.text = [titles objectAtIndex:0];
    } else {
        for (NSString *text in titles) {
//            UILabel *label = [UILabel new];
//            label.frame = (CGRect){0,2,self.view.bounds.size.width,10};
//            label.textAlignment = NSTextAlignmentCenter;
//            label.textColor = RGB(100, 50, 150);
//            label.font = [UIFont systemFontOfSize:4];
//            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//            label.backgroundColor = CCOLOR;
//            [self.view addSubview:label];
//            label.text = [label.text stringByAppendingString:text];
        }
    }
}

-(void)setLocation:(NSMutableArray *)location
{
    _location = location;
    if (location.count == 1) {
        locationLabel.text = [[location objectAtIndex:0] mutableCopy];
    }
}

@end
