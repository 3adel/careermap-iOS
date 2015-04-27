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

-(void) updateCVContentAfterEdit{
    
    NSLog(@"notification");
    
    //this will guaranteed that the activity indicator is shown while the data is loading
    _CVContentScrollView.hidden =YES;
    _noCVFoundView.hidden =YES;
    [_editCVButton setEnabled:NO];
    [_CVDataLoadingIndicator startAnimating];
    [self CVViewEdit];
}


-(void) viewWillAppear:(BOOL)animated{
    

    //add NSNotificatin selector for CV Edit (should refactor using delegation)
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCVContentAfterEdit) name:@"CVEditedSuccessNotification" object:nil];
    


}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load called");
    // Do any additional setup after loading the view.
    
    
    //check if the user has a cv already
    //instantiate CreateCV
    
    
        //if they do, view the CV
    
    
    [_CVDataLoadingIndicator startAnimating];
    [self CVViewEdit];
    
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
                
                
                NSLog(@"job seeker object = *%@",[object objectForKey:@"aJobSeekerID" ] );
                
                
                
                
               // dispatch_async(ge, <#^(void)block#>)
                
                //Reenable send button and text field after process is done
                dispatch_async(dispatch_get_main_queue(), ^{
                    _CVContentScrollView.hidden =NO;
                    _noCVFoundView.hidden =YES;
                    [_editCVButton setEnabled:YES];
                    
                    //move to main thread
                    //update fields values
                    _fullNameLabel.text =[NSString stringWithFormat:@"%@ %@",[[object objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"],[[object objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"]];
                    
                    //update cv image thumb
                    PFFile *CVThumbImageFile = [[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerThumb"];
                    [CVThumbImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            NSLog(@"success updating seeker cv image");
                             _aJobSeekerThumb.image = [UIImage imageWithData:imageData];
                            
                           // = ;
                        }
                        else{
                            
                            NSLog(@"Error updating seeker cv image");
                        }
                        
                        
                    }];
                    
                    
                    
                  //  _aJobSeekerThumb.image = [[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerThumb"];
                    
                    
                    
                    
                    
                    
                    
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
           [_CVDataLoadingIndicator setHidesWhenStopped:YES];
            
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
        createCVInstance.CVjobSeekerCurrentTitleTextView.text =[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"currentTitle"];
        createCVInstance.CVAboutMeTextView.text=[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerAbout"];
        createCVInstance.CVEducationTextField.text=[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducation"];
        createCVInstance.CVDegreeTextField.text=[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducationDegree"];
        createCVInstance.yearsOfExperienceLabel.text=[[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerYearsOfExperience"] stringValue];
        
        
        
        //update cv image thumb
        PFFile *CVThumbImageFile = [[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerThumb"];
        [CVThumbImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                NSLog(@"success updating seeker cv image");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    createCVInstance.CVjobSeekerThumb.image = [UIImage imageWithData:imageData];
                    
                });

            }
            else{
                
                NSLog(@"Error updating seeker cv image");
            }
            
            
        }];
        
        
        /*
        //update skills
        
        NSLog(@"job seeker object skills =%@", [[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"skills"]);
        
        
        createCVInstance.jobSeekerSkills =[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"skills"];
        
        int count =0;
        for (NSString *skill in createCVInstance.jobSeekerSkills) {
            // NSLog(@"Job skills array =%@", skill);
            
            //add skills to the skills view
            
             UITextField *skillTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 50*count, 200, 40)];
            //[skillTextField setuse]
             [skillTextField setBackgroundColor:[UIColor grayColor]];
             [skillTextField setFont:[UIFont systemFontOfSize:18]];
             skillTextField.text = skill;
             [createCVInstance.jobSkillsView addSubview:skillTextField];
            

            
            
            
            count++;
        }
        
        
        */
        
        
        
        
        
    }
    

    

    
}

@end
