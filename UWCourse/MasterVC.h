//
//  MasterVC.h
//  UWCourse
//
//  Created by Jack Xu on 3/18/14.
//  Copyright (c) 2014 Jack's App Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterVC : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) NSArray *courseArray;

@end
