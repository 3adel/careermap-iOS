//
//  LoginViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/29/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *loginOverlayView;

@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;

@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;

- (IBAction)registerUser:(UIButton *)sender;
- (void) checkFieldsComplete;
- (IBAction)registeredButton:(UIButton *)sender;
- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

@end
