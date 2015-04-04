//
//  ExistingUserLoginViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/4/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "ExistingUserLoginViewController.h"

@interface ExistingUserLoginViewController ()

@end

@implementation ExistingUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButton:(UIButton *)sender {
    
    
    [PFUser logInWithUsernameInBackground:_loginUsernameField.text password:_loginPasswordField.text block:^(PFUser *user, NSError *error) {
        
        if (!error) {
            NSLog(@"Success: Logged the user");
            
            //reset fields
            _loginUsernameField.text = nil;
            _loginPasswordField.text = nil;
            
            
            //_usernameField.text = nil;
            //_emailField.text = nil;
            //_passwordField.text = nil;
            
            [self performSegueWithIdentifier:@"loginSuccess" sender:self];
           // [self dismissViewControllerAnimated:NO completion:nil];

        }
        
        if (error) {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:error.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        
        
    }];

    
    
    
}

- (IBAction)dismissLoginScreen:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
