//
//  settingsViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/29/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "settingsViewController.h"

@implementation settingsViewController

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    
    
    [PFUser logOut];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"logout" sender:self];
    
    
}
@end
