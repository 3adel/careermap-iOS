//
//  CreateCVViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/19/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "CreateCVViewController.h"

@interface CreateCVViewController ()

@end

@implementation CreateCVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //set the border color of mandatory fields to red
 //   _CVjobSeekerFirstNameTextView.layer.borderColor = [[UIColor redColor] CGColor];
    _CVjobSeekerFirstNameTextView.layer.cornerRadius=5.0f;
    //_CVjobSeekerFirstNameTextView.layer.masksToBounds=YES;
    _CVjobSeekerFirstNameTextView.layer.borderColor=[[UIColor redColor]CGColor];
    _CVjobSeekerFirstNameTextView.layer.borderWidth= .5f;
    
    _CVjobSeekerLastNameTextView.layer.cornerRadius=5.0f;
    //_CVjobSeekerFirstNameTextView.layer.masksToBounds=YES;
    _CVjobSeekerLastNameTextView.layer.borderColor=[[UIColor redColor]CGColor];
    _CVjobSeekerLastNameTextView.layer.borderWidth= .5f;
    
    
    
    
    //detect when theview is tapped while the text is being edited
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
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

- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveCVButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"Save cv button pressed");
    
    
    //dismiss keyboard
    [_CVjobSeekerFirstNameTextView resignFirstResponder];
    [_CVjobSeekerLastNameTextView resignFirstResponder];
    [_CVjobSeekerCurrentTitleTextView resignFirstResponder];
    

    [self checkFieldsComplete];
    
    //validate fields, mandatory fields should not be empty
    
    
}


- (void) checkFieldsComplete{
    
    //validate mandatory fields only
    if ([_CVjobSeekerFirstNameTextView.text isEqualToString:@""] || [_CVjobSeekerLastNameTextView.text isEqualToString:@""]) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:@"You need to complete all madnatory fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
    else{
        
        
        NSLog(@"Save cv to backend");
        
        
    }
    
    
    
}


//dismiss keyboard when view is tapped
-(void) viewTapped{
    
    [_CVjobSeekerLastNameTextView resignFirstResponder];
    [_CVjobSeekerFirstNameTextView resignFirstResponder];
    [_CVjobSeekerCurrentTitleTextView resignFirstResponder];
    NSLog(@"view is tapped");
    
}



@end
