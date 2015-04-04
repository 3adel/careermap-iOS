//
//  ExistingUserLoginViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/4/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface ExistingUserLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;
- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)dismissLoginScreen:(UIButton *)sender;

@end
