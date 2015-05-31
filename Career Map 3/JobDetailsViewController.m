//
//  JobDetailsViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobDetailsViewController.h"
#import "JobChatViewController.h"
#import "AppHorizontalMessage.h"

@interface JobDetailsViewController ()

@end

@implementation JobDetailsViewController

@synthesize jobTitle;
//@synthesize jobTitleLabel;
@synthesize jobDescription;
@synthesize jobDescriptionLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    

    //styles
    _applyWithCVButton.layer.cornerRadius =5.0f;
    _messageEmployerButton.layer.cornerRadius =5.0f;

    
    
    
    
    // Do any additional setup after loading the view.
    
    //zoom to job location
    [self zoomToJobLocation];
    
    //set the values of view controller
   // self.jobTitleLabel.text = self.jobTitle;
    
    
    if (self.jobDescription) {
        self.jobDescriptionLabel.text=self.jobDescription;
    }
    
    if (self.jobTitle) {
        self.jobTitleTextView.text= self.jobTitle;
    }
    
    if (self.jobArea) {
    self.jobAreaLabel.text = self.jobArea;
    }
    
    if (self.jobDateAdded) {
    self.jobDateAddedLabel.text = self.jobDateAdded;
    }
    
    if (self.jobEmployer) {
        self.jobEmployerLabel.text = self.jobEmployer;
    }
    
    if (self.jobEmployer) {
        self.jobEmployerLabel.text = self.jobEmployer;
    }
    
    if (self.jobDistanceFromUser) {
        self.jobDistanceFromUserLabel.text = self.jobDistanceFromUser;
    }
    
    if (self.jobEducation) {
        self.jobEducationTextView.text = self.jobEducation;
    }
    
    if (self.jobRolesAndResponsibilities) {
        self.jobRolesAndResponsibilitiesTextView.text = self.jobRolesAndResponsibilities;
    }
    
    if (self.jobCompensation) {
        self.jobCompensationTextView.text = self.jobCompensation;
    }
    
    if (self.jobEmploymentType) {
        self.jobEmploymentTypeTextView.text = self.jobEmploymentType;
    }
    
    if (self.jobIndustryType) {
        self.jobIndustryTypeTextView.text = self.jobIndustryType;
    }


    self.jobMap.delegate = self;
    self.jobMap.mapType = MKMapTypeStandard;
    //detect when the map is tapped
    UITapGestureRecognizer *mapTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showJobDirection)];
    [self.jobMap addGestureRecognizer:mapTapGesture];
    
    
    //add job skills view
   // [self.jobDetailsScrollView addSubview:self.jobSkillsView];
   // [self.jobSkillsView setBackgroundColor:[UIColor redColor]];
    
    if (self.jobRequiredSkills.count <1) {
        _jobsSkillsTextView.text =@"-";
    }
    else{
        _jobsSkillsTextView.text =@"";
        int count =0;
        for (NSString *skill in self.jobRequiredSkills) {
            
            
            
            _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:[NSString stringWithFormat:@"%d. %@",count+1,skill]];
            
            if (!(count == ([self.jobRequiredSkills count])-1)) {
                _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:@"\n"];
            }
            
            
            
            count++;
        }
        
        
        
        
    }
    

    
    
    
    //if the user already applied, disable apply button
    if ([[_jobObject objectForKey:@"appliedByUsers"] containsObject:[[PFUser currentUser] objectId]]) {
        NSLog(@"user already applied");
        [_applyWithCVButton setTitle:@"You Applied" forState:UIControlStateNormal];
        [_applyWithCVButton setBackgroundColor:[UIColor grayColor]];
        self.applyWithCVButton.enabled =NO;
        
    }
    
    
    
    //set the style of the button update the report button.
    
    [_reportJobBarButton setTintColor:[UIColor redColor]];
    if ([[_jobObject objectForKey:@"currentUserVotedDownThisJob"] isEqualToString:@"1"]) {
        _reportJobBarButton.enabled =NO;
    } else{
        
        _reportJobBarButton.enabled =YES;
    }
    
    
    
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


- (void) zoomToJobLocation{
    
    
    
    /*
    //convert job cllocation to parse point to be used for zooming
    PFGeoPoint *jobLocationPoint = [[PFGeoPoint alloc] init];
    jobLocationPoint.latitude =self.jobLocation.coordinate.latitude;
    jobLocationPoint.longitude =self.jobLocation.coordinate.longitude;
    
*/
    
    //double k = ;
   // NSLog(@"distance is = %f",k);
    
    
    //zoom to job location
    CLLocationCoordinate2D jobZoomLocation;
    jobZoomLocation= self.jobLocation.coordinate;
  //  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(jobZoomLocation, ([self.userLocation distanceInKilometersTo: jobLocationPoint])*250, ([self.userLocation distanceInKilometersTo: jobLocationPoint])*250);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(jobZoomLocation, 50, 50);
    [_jobMap setRegion:viewRegion animated:YES];
    [_jobMap setScrollEnabled:NO];
    
   
  //  NSNumber *jobDistanceNumber = [NSNumber numberWithDouble:[self.userLocation2 distanceInKilometersTo:self.jobLocation]];
   // NSLog(@"user location %@", jobDistanceNumber);

    
    //[self.joblocation distanceInKilometersTo
    
    //add job annotation
    // Add an annotation
    MKPointAnnotation *jobPoint = [[MKPointAnnotation alloc] init];
    jobPoint.coordinate = self.jobLocation.coordinate;
    jobPoint.title = self.jobTitle;
   // jobPoint.subtitle = [self.jobDistanceFromUser stringByAppendingString:[NSString stringWithFormat:@", %@", self.jobAddressLine]];
    jobPoint.subtitle = self.jobAddressLine;
    [_jobMap addAnnotation:jobPoint];
    
    
    
    
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   // [mapView deselectAnnotation:view.annotation animated:YES];
    
 //   DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
  //  controller.annotation = view.annotation;
   // self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
   // self.popover.delegate = self;
   // [self.popover presentPopoverFromRect:view.frame
          //                        inView:view.superview
           //     permittedArrowDirections:UIPopoverArrowDirectionAny
                      //          animated:YES];
    
    NSLog(@"map annotation selected selected");

}


//custom annotation view
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    
    MKAnnotationView *jobAnnView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"jobLocation"];
    jobAnnView.image = [ UIImage imageNamed:@"job-annotation-icon3.png" ];
    
    UIButton *showDirectionsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [showDirectionsButton addTarget:self action:@selector(showJobDirection) forControlEvents:UIControlEventTouchUpInside];
    
    jobAnnView.rightCalloutAccessoryView = showDirectionsButton;
    jobAnnView.canShowCallout = YES;
    return jobAnnView;
}

- (void) showJobDirection{
    
    NSLog(@"show me job directions please");
        [self performSegueWithIdentifier:@"jobMap" sender:self];
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"jobMap"]) {
        

        JobMapViewController *destViewController = segue.destinationViewController;
        destViewController.jobLocation = self.jobLocation;
        
        NSLog(@"go to map");
    }
}


//start chat with employer
- (IBAction)chatWithEmployerButtonPressed:(UIButton *)sender {
    
    
    
  //  JobChatViewController *jobChatViewController = [[JobChatViewController alloc] initWithNib:@"JobChatView" bundle:nil];
   // [self pushViewController:viewControllerB animated:YES];
    
    
    NSLog(@"Chat with employer button pressed");
    
    JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
    /*
    [self.tabBarController presentViewController:appChoice
                                        animated:YES
                                      completion:nil];*/
    
    //pass the user id of the job poster to the destination chat screen.
    jobChatScreen.jobEmployerUserObjectID =_jobEmployerUserObjectID;
    jobChatScreen.jobPosterPFUser = _jobPosterPFUser;
    
    
    [self presentViewController:jobChatScreen animated:YES completion:nil];
}

- (IBAction)applyWithCVButtonPressed:(UIButton *)sender {
    
    
    //progress spinner initialization
    MBProgressHUD *HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUDProgressIndicator.labelText = @"Applying ...";
    HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    
    
    //If the user don't have a CV, take them to the CV creation flow.
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query includeKey:@"aJobSeekerID"];
    [query getObjectInBackgroundWithId: [[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        if (!error) {
            
            if ([object objectForKey:@"aJobSeekerID"]) {
                //user does have CV
                NSLog(@"job seeker ID found = %@", [[object objectForKey:@"aJobSeekerID"] objectId]);
                NSLog(@"People who applied to this job = %@", [_jobObject objectForKey:@"appliedByUsers"]);
                
                //did the user apply with their CV?
                if ([[_jobObject objectForKey:@"appliedByUsers"] containsObject:[[PFUser currentUser] objectId]]) {
                    //user already applied. Do nothing. viewDidLoad took care of updating ui.
                    NSLog(@"user already applied");

                    
                }
                
                else{
                    NSLog(@"user did not apply");
                    //user has cv but did NOT apply apply
                    //Make them apply now

                    //Update job table. Add user objectId to who applied
                    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
                    [query includeKey:@"appliedByUsers"];
                    [query getObjectInBackgroundWithId:_jobObject.objectId block:^(PFObject *jobObject, NSError *error) {
                        
                        if (!error) {
                            [jobObject addUniqueObject:[[PFUser currentUser] objectId] forKey:@"appliedByUsers"];
                            [jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    NSLog(@"Applied to job successfully");
                                    
                                    
                                    
                                    //update apply button (you already applied)
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [_applyWithCVButton setTitle:@"You Applied" forState:UIControlStateNormal];
                                        [_applyWithCVButton setBackgroundColor:[UIColor grayColor]];
                                        self.applyWithCVButton.enabled =NO;
                                        [HUDProgressIndicator setHidden:YES];
                                        
                                        
                                        
                                        
                                        
                                        
                                    });
                                    
                                    [_jobObject addUniqueObject:[[PFUser currentUser] objectId] forKey:@"appliedByUsers"];
                                    
                                    //now sync the local _job object to reflect the job application

                                    
                                    NSLog(@"applied by user: %@",[_jobObject objectForKey:@"appliedByUsers"]  );

                                    
                                } else {
                                    NSLog(@"Error applying to job");
                                }
                            }];;
                        }
                        
                        else{
                            
                            NSLog(@"error retrieving job record");
                        }
                        
                        
        
                        
                    }];


                }
                
                
                

            }
            
            else{
                [HUDProgressIndicator setHidden:YES];
                
                _createCVAlert.delegate = self;
                NSLog(@"No cv has been found, create one then");
                 _createCVAlert =[[UIAlertView alloc] initWithTitle:@"No CV found" message:@"Please create a CV so you can apply" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create My CV ", nil];

                
                
                
                
                //[createCVAlert addButtonWithTitle:@"Foo" block:^{ NSLog(@"Foo"); }];
                //[createCVAlert addButtonWithTitle:<#(NSString *)#>]
                
                
               [_createCVAlert show];
                //The user doesn't have a CV,take to cv creation flow
            }
            
            
        }
        
        else{
            
            NSLog(@"Error retrieving job seekerID: %@", error);
        }
    }];

    
    
    //If the user created the cv already and did not apply, just apply and reflect on the UI
                //query the user table, if the user has a aJobSeekerID,
    

    
    

    
    //if the user applied already, show that they applied already and change the button labeling accordingly
    

    
    
}

- (IBAction)reportJobButtonPressed:(UIBarButtonItem *)sender {
    
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedDown" equalTo:_jobObject.objectId];
    [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    
    //progress spinner initialization
     MBProgressHUD *HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUDProgressIndicator.labelText = @"Thanks for reporting";
    HUDProgressIndicator.detailsLabelText = @"We'll take care of this";
    HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    //orange color
   // [_HUDProgressIndicator setColor:[UIColor colorWithRed:255/255.0 green:149.0/255.0 blue:0.0/0.0 alpha:0.8]];
    
    
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        if (!error) {
            
            
            [_jobObject incrementKey:@"reportCount" byAmount:[NSNumber numberWithInteger:1]];
            
            [_jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[PFUser currentUser] addObject:_jobObject.objectId forKey:@"jobVotedDown"];
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            
                            //update job object array
                            [_jobObject setObject:@"1" forKey:@"currentUserVotedDownThisJob"];
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                _reportJobBarButton.enabled =NO;
                                [HUDProgressIndicator setHidden:YES];
                                
                            });
                            
                            
                        }
                    }];
                    
                    
                } else {
                    NSLog(@"Error saving career object");
                }
                
            }];
            
            
        }
        
        
        
        
        
        
        
    }];
    
    
    
    
}
















//handle different alert views
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet== _createCVAlert) {//alertLogout
        if (buttonIndex == 0){
            NSLog(@"0: Cancel");
            
        }
        
        else if(buttonIndex==1){
            
            NSLog(@"Create CV flow");
            
           // CreateCVViewController *createCVScreen = [[CreateCVViewController alloc] initWithNibName:@"CreateCVView" bundle:nil];
            
            
            [self.tabBarController setSelectedIndex:1];
            
            
           // [self presentViewController:createCVScreen animated:YES completion:nil];
            
        }
    }

    
}



@end
