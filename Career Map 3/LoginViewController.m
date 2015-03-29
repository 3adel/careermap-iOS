//
//  LoginViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/29/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController




- (void)viewDidAppear:(BOOL)animated{
    
    
    //Check if the user is already logged in and transfer to app accordingly
    PFUser *user = [PFUser currentUser];
    
    if (user.username !=nil) {
        NSLog(@"User is already logged");
        
        //take me to app
        [self performSegueWithIdentifier:@"login" sender:self];
        
       // [self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>]
    }
}



- (IBAction)registerUser:(UIButton *)sender {
    
   
    //dismiss keyboard
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];

    
    
    
    [self checkFieldsComplete];
    
    
}





- (void) checkFieldsComplete{
    
    if ([_emailField.text isEqualToString:@""] || [_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:@"You need to complete all fields correctly" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
    //you need  to add validation for email format
    
    else{
        
        
        NSLog(@"Success!");
        [self registerNewUser];
        
    }
    
    
    
}

//i am already registered button
- (IBAction)registeredButton:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _loginOverlayView.frame = self.view.frame;
    
    
    
    }];
    
}



- (void) registerNewUser{
    
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.password = _passwordField.text;
    newUser.email = _emailField.text;
    
    
    //register now
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //blog
        
        if (!error) {
            NSLog(@"Registration success");
           
            //take me to the app
            [self performSegueWithIdentifier:@"login" sender:self];
            
            
        }
        
        else{
            
            NSLog(@"Registration error: %@", error);
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [alert show];

        }
    }];
    
    
    
}



@end
