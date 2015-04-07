//
//  settingsViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/29/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface settingsViewController : UIViewController
- (IBAction)logoutButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property BOOL checkIfUserIsAnonymous;

- (void) disableLogoutButton;
- (void) enableLogoutButton;
- (IBAction)loginButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
