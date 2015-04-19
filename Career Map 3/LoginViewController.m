//
//  LoginViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/29/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController



- (void) viewDidLoad{
    
    
    
    //set the border color of mandatory fields to red
    _usernameField.layer.cornerRadius=5.0f;
    _usernameField.layer.borderColor=[[UIColor redColor]CGColor];
    _usernameField.layer.borderWidth= .5f;
    
    _passwordField.layer.cornerRadius=5.0f;
    _passwordField.layer.borderColor=[[UIColor redColor]CGColor];
    _passwordField.layer.borderWidth= .5f;
    
    _emailField.layer.cornerRadius=5.0f;
    _emailField.layer.borderColor=[[UIColor redColor]CGColor];
    _emailField.layer.borderWidth= .5f;
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    
    //check if the user is loggedin with an anoymous user, if so, show the login/registration screen
    if (![PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        
        
        //Check if the user is already logged in and transfer to app accordingly
        PFUser *user = [PFUser currentUser];
        
        if (user.username !=nil) {
            NSLog(@"User is already logged");
            
            //take me to app
            [self performSegueWithIdentifier:@"login" sender:self];
            
            // [self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>]
        }
        
        
        
        
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
           
            //reset fields
            _loginUsernameField.text = nil;
            _loginPasswordField.text = nil;
            _usernameField.text = nil;
            _emailField.text = nil;
            _passwordField.text = nil;
            
            
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


//i am already registered button
- (IBAction)registeredButton:(UIButton *)sender {
   
    /*
    [UIView animateWithDuration:0.3 animations:^{
        _loginOverlayView.frame = self.view.frame;
        
            
    }];*/
    
    [self performSegueWithIdentifier:@"iHaveAnAccountAlready" sender:self];
    
    
    
}







@end
