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
#import "MBProgressHUD.h"

@interface ExistingUserLoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;
@property (strong, nonatomic) UIAlertView *passwordResetAlert;
@property (nonatomic, strong) MBProgressHUD *HUDProgressIndicator;


- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)dismissLoginScreen:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)lostPasswordButtonPressed:(UIButton *)sender;

@end
