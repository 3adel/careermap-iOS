//
//  ViewEditMyCVViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/20/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "ViewEditMyCVViewController.h"

@interface ViewEditMyCVViewController ()

@end

@implementation ViewEditMyCVViewController

-(void) viewWillAppear:(BOOL)animated{
    
    //this will guaranteed that the activity indicator is shown while the data is loading
    _CVContentScrollView.hidden =YES;
    _noCVFoundView.hidden =YES;
    [_editCVButton setEnabled:NO];
}

-(void) viewDidAppear:(BOOL)animated{
    
    NSLog(@"view did appear called");
    
    [_CVDataLoadingIndicator startAnimating];
    [self CVViewEdit];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load called");
    // Do any additional setup after loading the view.
    
    
    //check if the user has a cv already
    //instantiate CreateCV
    
    
        //if they do, view the CV
    
    
    
    
        // if they don't have a cv, disable the edit button inititate cv creation flow
            //when done, dismiss the cv creation screen
            //then save the cv
            //then refresh the view
    
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


- (void) CVViewEdit{
    
    
    
    //If the user don't have a CV, take them to the CV creation flow.
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query includeKey:@"aJobSeekerID"];
    [query getObjectInBackgroundWithId: [[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        //start animating loading indicator
        
        if (!error) {
            //save jobSeeker object in property
            _jobSeekerObject = object;
            
            if ([object objectForKey:@"aJobSeekerID"]) {
                //user does have CV
                NSLog(@"job seeker ID found = %@", [[object objectForKey:@"aJobSeekerID"] objectId]);
                
                NSLog(@"job seeker name = %@", [[object objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"]);
                
                
                
                
               // dispatch_async(ge, <#^(void)block#>)
                
                //Reenable send button and text field after process is done
                dispatch_async(dispatch_get_main_queue(), ^{
                    _CVContentScrollView.hidden =NO;
                    _noCVFoundView.hidden =YES;
                    [_editCVButton setEnabled:YES];
                    
                    //update fields values
                    _fullNameLabel.text =[NSString stringWithFormat:@"%@ %@",[[object objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"],[[object objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"]];
                    
                    
                  //  [[object objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"];
                    
                    
                    
                    //_lastNameLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"];
                    
                    
                    
                });
                




                
              //  NSLog(@"People who applied to this job = %@", [_jobObject objectForKey:@"appliedByUsers"]);
            }
            
            else{
                
               // _createCVAlert.delegate = self;
                NSLog(@"No cv has been found, create one then");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _noCVFoundView.hidden =NO;
                    _CVContentScrollView.hidden = YES;
                    
                });
                

                                
                //_createCVAlert =[[UIAlertView alloc] initWithTitle:@"Create Micro CV" message:@"It will take you seconds!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create Micro CV ", nil];
                
                
  
            }
            
            
        }
        
        else{
            
            NSLog(@"Error retrieving job seekerID: %@", error);
        }
        
        //return YES;
        
        NSLog(@"done retrieveing date");
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [_CVDataLoadingIndicator stopAnimating];
            
        });
        
        
        //[_CVDataLoadingIndicator removeFromSuperview];
        
    }];
    
    
    
    //If the user created the cv already and did not apply, just apply and reflect on the UI
    //query the user table, if the user has a aJobSeekerID,
    
    
    
    
    
    
    //if the user applied already, show that they applied already and change the button labeling accordingly
    
    
    
    
    
    
    
    //return NO;
}

- (IBAction)createCVButtonPressed:(UIButton *)sender {
    
    
    //instantiate cv creation
     CreateCVViewController *createCVInstance = [[CreateCVViewController alloc] initWithNibName:@"CreateCVView" bundle:nil];
     [self presentViewController:createCVInstance animated:YES completion:nil];
    

}

- (IBAction)editCVButtonPressed:(UIBarButtonItem *)sender {
    
    
    //update the cv fields in the CreateCV VC
    

    
    
    
    
    
    CreateCVViewController *createCVInstance = [[CreateCVViewController alloc] initWithNibName:@"CreateCVView" bundle:nil];
    
    [self presentViewController:createCVInstance animated:YES completion:nil];
    
    
    
    //populate edit cv screen with existing values
    if (_jobSeekerObject) {
        createCVInstance.CVjobSeekerFirstNameTextView.text =[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"];
        createCVInstance.CVjobSeekerLastNameTextView.text =[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"];
        
    }
    

    

    
}

@end
