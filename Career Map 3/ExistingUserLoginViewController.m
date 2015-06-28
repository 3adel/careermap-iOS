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
    
    
    
    //style
    _loginButton.layer.cornerRadius = 5.0f;
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
    
    //always convert username to lowercase
    [PFUser logInWithUsernameInBackground:[_loginUsernameField.text lowercaseString] password:_loginPasswordField.text block:^(PFUser *user, NSError *error) {
        
        if (!error) {
            //NSLog(@"Success: Logged the user");
            
            //reset fields
            _loginUsernameField.text = nil;
            _loginPasswordField.text = nil;
            

            //save the user to parse installation table
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = [PFUser currentUser];
            [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    ;
                    //NSLog(@"saving user to parse installation table succeeded");
                }
                
                else{
                    NSLog(@"saving user to parse installation table FAILED");
                    
                    
                }
            }];
            
            
            
            
            [self performSegueWithIdentifier:@"loginSuccess" sender:self];
           // [self dismissViewControllerAnimated:NO completion:nil];

        }
        
        if (error) {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            
            
            
            [alert show];
        }
        
        
        
    }];

    
    
    
}

- (IBAction)dismissLoginScreen:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    //[self performSegueWithIdentifier:@"loginSuccess" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)lostPasswordButtonPressed:(UIButton *)sender {
    
    
    
    
    _passwordResetAlert = [[UIAlertView alloc]initWithTitle:@"Lost password" message:@"Please enter your email address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset password", nil];
    _passwordResetAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_passwordResetAlert textFieldAtIndex:0].delegate = self;
    [_passwordResetAlert textFieldAtIndex:0].placeholder = @"Email";
    [_passwordResetAlert show];
    
    
}


//handle different alert views
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(actionSheet== _passwordResetAlert) {//alertLogout
        if (buttonIndex == 1){
            
            
            _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _HUDProgressIndicator.labelText = @"Sending password reset email...";_HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
            
            //send reset password
            [PFUser requestPasswordResetForEmailInBackground:[_passwordResetAlert textFieldAtIndex:0].text block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    _HUDProgressIndicator.hidden= YES;
                    
                    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Success" message:@"Check your email to reset password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                else {
                    _HUDProgressIndicator.hidden= YES;
                    
                    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    
                }
            }];
            
            
        }
        
        
    }
    
    
}


@end
