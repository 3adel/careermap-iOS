//
//  ViewEditMyCVViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/20/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "ViewEditMyCVViewController.h"
#import "AppHorizontalMessage.h"

@interface ViewEditMyCVViewController ()

@end

@implementation ViewEditMyCVViewController

-(void) CVEditSuccess{
    

    /*
    //[_saveCVButtonPressedMessage hideMessage];
    
    //Show successfull cv saved message
    AppHorizontalMessage *appMessage = [[AppHorizontalMessage alloc] init];
    appMessage.center = CGPointMake(self.view.center.x,[UIScreen mainScreen].bounds.size.height - 69);
    [[[UIApplication sharedApplication] keyWindow] addSubview:appMessage
     ];
    [appMessage showWithMessageAutoHide:@"CV saved" withColor:[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:0.0/0.0 alpha:0.8]];
    */
    
    
    
    //this will guaranteed that the activity indicator is shown while the data is loading
    _CVContentScrollView.hidden =YES;
    [_editCVButton setEnabled:YES];
    _noCVFoundView.hidden =YES;
    [_editCVButton setEnabled:NO];
   // [_CVDataLoadingIndicator startAnimating];
    [self CVViewEdit];
    
    
    
}


-  (void) saveCVButtonPressedNotifSelector{
    
   // NSLog(@"save button tapped notification");
    
    //progress spinner initialization
    _MBProgressHUDSaveButtonPressedIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _MBProgressHUDSaveButtonPressedIndicator.labelText = @"Saving CV ...";
    _MBProgressHUDSaveButtonPressedIndicator.mode = MBProgressHUDModeIndeterminate;
    

    /*
    //Show successfull cv saved message
    _saveCVButtonPressedMessage = [[AppHorizontalMessage alloc] init];
    _saveCVButtonPressedMessage.center = CGPointMake(self.view.center.x,[UIScreen mainScreen].bounds.size.height - 69);
    [[[UIApplication sharedApplication] keyWindow] addSubview:_saveCVButtonPressedMessage
     ];
    
    
    //orange color
    [_saveCVButtonPressedMessage showMessage:@"Saving ..." withColor:[UIColor colorWithRed:255/255.0 green:149.0/255.0 blue:0.0/0.0 alpha:0.8]];
*/
    //this will guaranteed that the activity indicator is shown while the data is loading
    _CVContentScrollView.hidden =YES;
    _noCVFoundView.hidden =YES;
    [_editCVButton setEnabled:NO];
    //[_CVDataLoadingIndicator startAnimating];
    [[NSNotificationCenter defaultCenter] removeObserver:self];


}




-(void) viewWillAppear:(BOOL)animated{
    
    
    //NSLog(@"view will appear");

    //add NSNotificatin selector for CV Edit (should refactor using delegation)
    [super viewWillAppear:animated];
    

    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CVEditSuccess) name:@"CVEditedSuccessNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCVButtonPressedNotifSelector) name:@"saveCVButtonPressed" object:nil];
    
    
   // [[NSNotificationCenter defaultCenter] removeObserver:<#(id)#>]
    


}



- (void)viewDidLoad {
    [super viewDidLoad];
  //  NSLog(@"view did load called");
    // Do any additional setup after loading the view.
    //_CVViewNavigationBar.hidden = YES;
    //[_CVViewNavigationBar removeFromSuperview];

    
    
    
    //style
    _aJobSeekerThumb.layer.cornerRadius = _aJobSeekerThumb.frame.size.width/2;
    _aJobSeekerThumb.clipsToBounds = YES;
    _messageCandidateButton.layer.cornerRadius = 5.0f;
    NSLog(@"coming from applicant list?: %d", _cominfFromApplicantsList);
    
    
    
    if (_cominfFromApplicantsList) {
        //_editCVButton.title = @"Close";
        _CVNavigationItem.title =[NSString stringWithFormat:@"%@ %@",[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"],[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"]];
        _messageCandidateButton.enabled = YES;
        _messageCandidateButton.hidden = NO;
        
        _closeCVButton.enabled = YES;
        [_closeCVButton setTitle:@"Close"];
        
        [_editCVButton setEnabled:NO];
        [_editCVButton setTitle:@""];

        

    }
    else{
        //_editCVButton.title = @"Edit";
        [_editCVButton setEnabled:YES];
        [_editCVButton setTitle:@"Edit"];

        
        
        _closeCVButton.enabled = NO;
        [_closeCVButton setTitle:@""];



    }

    //check if the user has a cv already
    //instantiate CreateCV
    
    
        //if they do, view the CV
    
    //styles
    _createCVButton.layer.cornerRadius = 5.0f;
    
    
    //progress spinner initialization
    _MBProgressHUDLoadingCV = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _MBProgressHUDLoadingCV.labelText = @"Loading CV ...";
    _MBProgressHUDLoadingCV.mode = MBProgressHUDModeIndeterminate;
    
    
    //[_CVDataLoadingIndicator startAnimating];

    
    
    if (_cominfFromApplicantsList) {
        //fill candidates field
        
        [self fillCandidateCV];
        
    }
    
    else{
        //fill cv fields
        
        [self CVViewEdit];

    }
    

    
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



-(void)fillCandidateCV{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [_MBProgressHUDLoadingCV setHidden:YES];
        _CVContentScrollView.hidden = NO;
        _noCVFoundView.hidden =YES;

    });
    

    _fullNameLabel.text = [_jobCandidateObject objectForKey:@"username"];
    
    
    if (![[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"] isEqualToString:@""]) {
        _fullNameLabel.text = @"";
        _fullNameLabel.text =[NSString stringWithFormat:@"%@ %@",[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"],[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"]];
        _fullNameLabel.textColor = [UIColor blackColor];
    }
    else{
        _fullNameLabel.text = @"None";
        _fullNameLabel.textColor = [UIColor orangeColor];
        
        
    }
    
    if (![[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"currentTitle"] isEqualToString:@""]) {
        _CVJobSeekerCurrentTitleLabel.text = @"";
        _CVJobSeekerCurrentTitleLabel.text =[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"currentTitle"];
        _CVJobSeekerCurrentTitleLabel.textColor = [UIColor blackColor];
        
    }
    else{
        _CVJobSeekerCurrentTitleLabel.text = @"None";
        _CVJobSeekerCurrentTitleLabel.textColor = [UIColor orangeColor];
        
        
        
    }
    
    if (![[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerAbout"] isEqualToString:@""]) {
        _CVJobSeekerAboutMeTextView.text = @"";
        _CVJobSeekerAboutMeTextView.text =[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerAbout"];
        _CVJobSeekerAboutMeTextView.textColor = [UIColor blackColor];
        
    }
    else{
        _CVJobSeekerAboutMeTextView.text = @"None";
        _CVJobSeekerAboutMeTextView.textColor = [UIColor orangeColor];
        
        
        
    }
    
    
    if (![[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducation"] isEqualToString:@""]) {
        _CVJobSeekerEducationLabel.text = @"";
        _CVJobSeekerEducationLabel.text =[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducation"];
        _CVJobSeekerEducationLabel.textColor = [UIColor blackColor];
        
    }
    else{
        _CVJobSeekerEducationLabel.text = @"None";
        _CVJobSeekerEducationLabel.textColor = [UIColor orangeColor];
        
        
        
    }
    
    if (![[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducationDegree"] isEqualToString:@""]) {
        _CVJobSeekerDegreeLabel.text = @"";
        _CVJobSeekerDegreeLabel.text =[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducationDegree"];
        _CVJobSeekerDegreeLabel.textColor = [UIColor blackColor];
        
    }
    else{
        _CVJobSeekerDegreeLabel.text = @"None";
        _CVJobSeekerDegreeLabel.textColor = [UIColor orangeColor];
        
        
        
    }
    
    if (![[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"school"] isEqualToString:@""]) {
        _CVJobSeekerSchool.text = @"";
        _CVJobSeekerSchool.text =[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"school"];
        _CVJobSeekerSchool.textColor = [UIColor blackColor];
        
    }
    else{
        _CVJobSeekerSchool.text = @"None";
        _CVJobSeekerSchool.textColor = [UIColor orangeColor];
        
        
        
    }
    
    
    
    
    
    
    // _CVJobSeekerEducationLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducation"];
    // _CVJobSeekerDegreeLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducationDegree"];
    _CVJobSeekerYearsOfExperienceLabel.text =[[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerYearsOfExperience"] stringValue];
    
    //update skills
    
    
    
    if ([(NSArray *)[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"skills"] count]>0) {
        
        _jobSkillsTextView.text = @"";
        _jobSkillsTextView.textColor = [UIColor blackColor];
        int count =0;
        for (NSString *skill in (NSArray *)[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"skills"]) {
            
            
            
            
            _jobSkillsTextView.text = [_jobSkillsTextView.text stringByAppendingString:[NSString stringWithFormat:@"- %@",skill]];
            
            if (!(count == ([(NSArray *)[[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"skills"] count])-1)) {
                _jobSkillsTextView.text = [_jobSkillsTextView.text stringByAppendingString:@"\n"];
            }
            
            count++;
        }
        
    }
    
    else{
        _jobSkillsTextView.text = @"No skills yet";
        _jobSkillsTextView.textColor = [UIColor orangeColor];
        
        
        
        
    }

    //update cv image thumb
    PFFile *CVThumbImageFile = [[_jobCandidateObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerThumb"];
    [CVThumbImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            // NSLog(@"success updating seeker cv image");
            _aJobSeekerThumb.image = [UIImage imageWithData:imageData];
            
            // = ;
        }
        else{
            
            NSLog(@"Error updating seeker cv image");
        }
        
        
    }];

    
}



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
                //NSLog(@"job seeker ID found = %@", [[object objectForKey:@"aJobSeekerID"] objectId]);
                
               // NSLog(@"job seeker name = %@", [[object objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"]);
                
                
              //  NSLog(@"job seeker object = *%@",[object objectForKey:@"aJobSeekerID" ] );
                
                
                
                
               // dispatch_async(ge, <#^(void)block#>)
                
                //Reenable send button and text field after process is done
                dispatch_async(dispatch_get_main_queue(), ^{
                    _CVContentScrollView.hidden =NO;
                    _noCVFoundView.hidden =YES;
                    [_editCVButton setEnabled:YES];
                    
                    //move to main thread
                    //update fields values
                    if (![[[object objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"] isEqualToString:@""]) {
                        _fullNameLabel.text = @"";
                        _fullNameLabel.text =[NSString stringWithFormat:@"%@ %@",[[object objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"],[[object objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"]];
                        _fullNameLabel.textColor = [UIColor blackColor];
                    }
                    else{
                        _fullNameLabel.text = @"None";
                        _fullNameLabel.textColor = [UIColor orangeColor];
                        
                        
                    }
                    
                    if (![[[object objectForKey:@"aJobSeekerID"] objectForKey:@"currentTitle"] isEqualToString:@""]) {
                        _CVJobSeekerCurrentTitleLabel.text = @"";
                        _CVJobSeekerCurrentTitleLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"currentTitle"];
                        _CVJobSeekerCurrentTitleLabel.textColor = [UIColor blackColor];

                    }
                    else{
                        _CVJobSeekerCurrentTitleLabel.text = @"None";
                        _CVJobSeekerCurrentTitleLabel.textColor = [UIColor orangeColor];

                        
    
                    }
                    
                    if (![[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerAbout"] isEqualToString:@""]) {
                        _CVJobSeekerAboutMeTextView.text = @"";
                        _CVJobSeekerAboutMeTextView.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerAbout"];
                        _CVJobSeekerAboutMeTextView.textColor = [UIColor blackColor];

                    }
                    else{
                        _CVJobSeekerAboutMeTextView.text = @"None";
                        _CVJobSeekerAboutMeTextView.textColor = [UIColor orangeColor];

                        
                        
                    }
                    
                    
                    if (![[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducation"] isEqualToString:@""]) {
                        _CVJobSeekerEducationLabel.text = @"";
                        _CVJobSeekerEducationLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducation"];
                        _CVJobSeekerEducationLabel.textColor = [UIColor blackColor];

                    }
                    else{
                        _CVJobSeekerEducationLabel.text = @"None";
                        _CVJobSeekerEducationLabel.textColor = [UIColor orangeColor];

                        
                        
                    }
                    
                    if (![[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducationDegree"] isEqualToString:@""]) {
                        _CVJobSeekerDegreeLabel.text = @"";
                        _CVJobSeekerDegreeLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducationDegree"];
                        _CVJobSeekerDegreeLabel.textColor = [UIColor blackColor];

                    }
                    else{
                        _CVJobSeekerDegreeLabel.text = @"None";
                        _CVJobSeekerDegreeLabel.textColor = [UIColor orangeColor];

                        
                        
                    }
                    
                    if (![[[object objectForKey:@"aJobSeekerID"] objectForKey:@"school"] isEqualToString:@""]) {
                        _CVJobSeekerSchool.text = @"";
                        _CVJobSeekerSchool.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"school"];
                        _CVJobSeekerSchool.textColor = [UIColor blackColor];
                        
                    }
                    else{
                        _CVJobSeekerSchool.text = @"None";
                        _CVJobSeekerSchool.textColor = [UIColor orangeColor];
                        
                        
                        
                    }
                    
                    
                    
                    
                    

                   // _CVJobSeekerEducationLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducation"];
                   // _CVJobSeekerDegreeLabel.text =[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerEducationDegree"];
                    _CVJobSeekerYearsOfExperienceLabel.text =[[[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerYearsOfExperience"] stringValue];
                    
                    //update skills
                    

                    
                    if ([(NSArray *)[[object objectForKey:@"aJobSeekerID"] objectForKey:@"skills"] count]>0) {
                        
                        _jobSkillsTextView.text = @"";
                        _jobSkillsTextView.textColor = [UIColor blackColor];
                        int count =0;
                        for (NSString *skill in (NSArray *)[[object objectForKey:@"aJobSeekerID"] objectForKey:@"skills"]) {
                            
                            
                            
                            
                            _jobSkillsTextView.text = [_jobSkillsTextView.text stringByAppendingString:[NSString stringWithFormat:@"- %@",skill]];
                            
                            if (!(count == ([(NSArray *)[[object objectForKey:@"aJobSeekerID"] objectForKey:@"skills"] count])-1)) {
                                _jobSkillsTextView.text = [_jobSkillsTextView.text stringByAppendingString:@"\n"];
                            }
                            
                            count++;
                        }

                    }
                    
                    else{
                        _jobSkillsTextView.text = @"No skills yet";
                        _jobSkillsTextView.textColor = [UIColor orangeColor];

                        
                        
                        
                    }
                    

                    
                    //update cv image thumb
                    PFFile *CVThumbImageFile = [[object objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerThumb"];
                    [CVThumbImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                           // NSLog(@"success updating seeker cv image");
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
            
            //if the use is an employer
            else if ([object objectForKey:@"anEmployerID"]){
                
                NSLog(@"user is an employer");
                //logic to update cv with employer data
            }
            
            
            else{
                
               // _createCVAlert.delegate = self;
                //NSLog(@"No cv has been found, create one then");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [_MBProgressHUDLoadingCV setHidden:YES];
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
        
        //NSLog(@"done retrieveing date");
        
        dispatch_async(dispatch_get_main_queue(), ^{
         //  [_CVDataLoadingIndicator stopAnimating];
            
           //[_CVDataLoadingIndicator setHidesWhenStopped:YES];
            
            
            
            [_MBProgressHUDLoadingCV setHidden:YES];

                [_MBProgressHUDSaveButtonPressedIndicator setHidden:YES];
                
          
            
        });
        
        
        //[_CVDataLoadingIndicator removeFromSuperview];
        
    }];
    
    
    
    //If the user created the cv already and did not apply, just apply and reflect on the UI
    //query the user table, if the user has a aJobSeekerID,
    
    
    
    
    
    
    //if the user applied already, show that they applied already and change the button labeling accordingly
    
    
    
    
    
    
    
    //return NO;
}

- (IBAction)createCVButtonPressed:(UIButton *)sender {
    
    //if user is anonymous, prompt for login
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        _registerAlert.delegate = self;
        _registerAlert =[[UIAlertView alloc] initWithTitle:@"Register" message:@"Please create a user account first" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Register", nil];
        [_registerAlert show];
    }
    
    else{

        //instantiate cv creation
        CreateCVViewController *createCVInstance = [[CreateCVViewController alloc] initWithNibName:@"CreateCVView" bundle:nil];
        [self presentViewController:createCVInstance animated:YES completion:nil];

    }

    

}

- (IBAction)editCVButtonPressed:(UIBarButtonItem *)sender {
    
    
    


        
        //update the cv fields in the CreateCV VC
        CreateCVViewController *createCVInstance = [[CreateCVViewController alloc] initWithNibName:@"CreateCVView" bundle:nil];
        
        //Get the existing skills of job seeker
        if ([[[NSMutableArray alloc] initWithArray:[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"skills"]] count]>0){
            
            createCVInstance.existingSkills =[[NSMutableArray alloc] initWithArray:[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"skills"]];
            
        }
        
        else{
            createCVInstance.existingSkills =[[NSMutableArray alloc] init];
            
            
        }
        
        
        
        
        
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
            createCVInstance.CVSchoolTextField.text =  createCVInstance.CVSchoolTextField.text=[[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"school"];
            
            
            
            
            //update cv image thumb
            PFFile *CVThumbImageFile = [[_jobSeekerObject objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerThumb"];
            [CVThumbImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    //NSLog(@"success updating seeker cv image");
                    
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

- (IBAction)messageCandidateButtonPressed:(UIButton *)sender {
    
    
    
    JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
    
    jobChatScreen.jobEmployerUserObjectID =[_jobCandidateObject objectId];
    jobChatScreen.jobPosterPFUser = _jobCandidateObject;
    
    [self presentViewController:jobChatScreen animated:YES completion:nil];
    
    
    
    
    
}


//handle different alert views
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if(actionSheet== _registerAlert) {//alertLogout
        if (buttonIndex == 0){
            //NSLog(@"0: Cancel");
            ;
            
        }
        
        else if(buttonIndex==1){
            
           // NSLog(@"Register");
            LoginViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"registrationViewController"];
            //  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:registerViewController];
            //[self.navigationController pushViewController:navi animated:YES];
            [self presentViewController:registerViewController animated:YES completion:nil];
            
        }
    }
    
    
}

- (IBAction)closeCVButtonPressed:(UIBarButtonItem *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
