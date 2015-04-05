//
//  settingsViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/29/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "settingsViewController.h"

@implementation settingsViewController
@synthesize checkIfUserIsAnonymous;


- (void) viewWillAppear:(BOOL)animated{
    
   // checkIfUserIsAnonymous =YES;
    
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        // i.checkIfUserIsAnonymous =YES;
        NSLog(@"We have an already existing anonymous user");
        [self disableLogoutButton];
        
        
    } else {
        //No anonymous users are already created, create one please
         [self enableLogoutButton];
        NSLog(@"user is NOT anonymous detected");
        
        
    }

    
    
    
    /*
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        //user is anonymous detected
        [self disableLogoutButton];
        NSLog(@"user is anonymous detected");
    } else {
        //user is not anynymous detected
        [self enableLogoutButton];
        NSLog(@"user is NOT anonymous detected");

    }*/
}

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    
    
    [PFUser logOut];
    
    
    
    //make sure to create an anonymous session if the user logs out. Then perform logout segue so the table view is not empty.
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Anonymous login failed.");
        } else {
            NSLog(@"Anonymous user logged in.");
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"logout" sender:self];
        }
    }];
    
   
    
    
}


- (void) enableLogoutButton{
    
    //unhide logout button
    [_logoutButton setHidden:NO];
    NSLog(@"unhhide the logout button");
    
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    //maintain the anonymous user and take the user to login/registration screen
    [self performSegueWithIdentifier:@"login" sender:self];

    
    
}


- (void) disableLogoutButton{
    
    //unhide logout button
    [_logoutButton setHidden:YES];
    NSLog(@"Hid the logout button");
    
    
}




@end
