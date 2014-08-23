//
//  WebVC.h
//  UWCourse
//
//  Created by Jack Xu on 3/21/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *instructorString;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (strong,nonatomic) NSTimer *timer;
@end
