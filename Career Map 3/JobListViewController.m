//
//  JobListViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobListViewController.h"
#import "JobCustomTableViewCell.h"
#import "Job.h"
#import "settingsViewController.h"


@implementation JobListViewController{
    
    
}

//track if the user received a push notification while the app is closed
bool messageIsReceived = NO;



@synthesize refreshControl;
@synthesize userLocation;
@synthesize jobsArray;
@synthesize formatter;


- (void) viewWillAppear:(BOOL)animated{

    
    //Screen count with google anlaytics
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Job List Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    

    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //make sure the app choice screen shows one time only
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"screenShown"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"screenShown"];
        
        
        //do other apps setups the first time
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:3000] forKey:@"jobDistanceFilterValue"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self retrieveJobCategoriesFromParse];
        
        WelcomeAppChoiceViewController  *appChoice = [[WelcomeAppChoiceViewController alloc] initWithNibName:@"WelcomeAppChoiceView" bundle:nil];
        [self.tabBarController presentViewController:appChoice
                                            animated:YES
                                          completion:nil];
        
        
        
    }

    
    
    //filter parameters
    _jobsFilterDistance =[[NSUserDefaults standardUserDefaults] objectForKey:@"jobDistanceFilterValue" ];
    _jobCategoriesSelectedArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"jobsCategorySelectedArrayForFilter" ];


    _noJobsView = [[LoadingJobListEmptyView alloc] init];

    
    //if the user is coming from message push notif, show the message dialog first
    if (messageIsReceived) {
        
        //get notif payload that was set in app delegate
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSDictionary *notificationPayload = appDelegate.notificationPayload;
        JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
        jobChatScreen.jobEmployerUserObjectID = [[notificationPayload valueForKey:@"otherPFUser"] objectForKey:@"objectId"];
        jobChatScreen.jobPosterPFUser = [notificationPayload valueForKey:@"otherPFUser"];
        [self presentViewController:jobChatScreen animated:YES completion:nil];
        
    }
    
    
    //table cell autolayout
    _jobTable.estimatedRowHeight = 100.0;
    self.jobTable.rowHeight = UITableViewAutomaticDimension;

    //progress spinner initialization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:_jobTable animated:YES];
    _HUDProgressIndicator.labelText = @"Loading jobs around you...";
    _HUDProgressIndicator.detailsLabelText = @"Locating you ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;

    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor colorWithRed:255/255.0 green:149.0/255.0 blue:0.0/0.0 alpha:0.8];

    self.refreshControl.tintColor = [UIColor colorWithRed:220.0/255.0 green:234.0/255 blue:255.0/255.0 alpha:1];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    [self.jobTable addSubview:self.refreshControl];
    
    
    
    
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.userLocation = geoPoint;
            
            //get user city
            [self getUserCity:self.userLocation];

            [self reloadData];
            
 
        }
        else{
            UIAlertView *needUserLocationAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You need to enable user location for this app to function properly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [needUserLocationAlert show];
            
            NSLog(@"Can't get user location");
        }
    }];
    
    
    
    //update message tabbar item with how many unread messages
    MessagesViewController *messaagesVC = [[MessagesViewController alloc] init];
    
    
    [messaagesVC getUsersWhoBlockedMe];
    
    
}

- (void) retrieveFromParse {
    
    
    //query #1 for jobs
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"reportCount <=7"];
    PFQuery *retrieveJobs = [PFQuery queryWithClassName:@"Job" predicate:predicate];
    [retrieveJobs includeKey:@"employer"];
    [retrieveJobs includeKey:@"status"];
    [retrieveJobs includeKey:@"postedByUser"];
    [retrieveJobs includeKey:@"appliedByUsers"];
    [retrieveJobs includeKey:@"jobIndustry"];


    
    //Prepare filterd categories
    NSMutableArray *arrayOfCategoriesSelectedAsPFObjects = [[NSMutableArray alloc] init];
    for (NSString *categoryObject in _jobCategoriesSelectedArray) {
   [arrayOfCategoriesSelectedAsPFObjects addObject:[PFObject objectWithoutDataWithClassName:@"JobIndustry" objectId:categoryObject]];

    }

    [retrieveJobs whereKey:@"jobIndustry" containedIn:arrayOfCategoriesSelectedAsPFObjects];
    [retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation withinKilometers:_jobsFilterDistance.doubleValue];
    
    
    
  
    retrieveJobs.limit =1000;
    //[retrieveJobs orderByDescending:@"createdAt"];
    
    
    [retrieveJobs findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if (objects.count==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUDProgressIndicator hide:YES];
                    if (self.refreshControl) {
                        [self.refreshControl endRefreshing];
                        
                        //call empty view message
                        
                        [_jobTable addSubview:_noJobsView];
                        
                        _jobListNavigationItem.title = [NSString stringWithFormat:@"%d Jobs Around You",0];
                        

                    }
                    

                });

            } else{

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_noJobsView) {
                        [_noJobsView removeFromSuperview];

                    }
                    
                    //update jobs count
                    _jobListNavigationItem.title = [NSString stringWithFormat:@"%lu Jobs Around You",(unsigned long)[objects count]];
                    
                });
                
                

                
                
                jobsArray = [[NSMutableArray alloc] initWithArray:objects];

                
                
                //get job area and update ui
                NSUInteger count = 0;
                for (PFObject *i in jobsArray) {
                    CLLocation  *jobLocation = [[CLLocation alloc] initWithLatitude:[[i objectForKey:@"geolocation"] latitude] longitude:[[i objectForKey:@"geolocation"] longitude]];
                    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                    [geocoder reverseGeocodeLocation:jobLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error == nil && [placemarks count] > 0)
                        {
                            
                            CLPlacemark *placemark = [placemarks lastObject];
                            if ([[placemarks lastObject] locality] != nil ) {
                                [(PFObject *)[jobsArray objectAtIndex:count] setObject:[placemark locality] forKey:@"area"];
                                
                                //add the address line as a component
                                NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
                                NSString *addressString = [lines componentsJoinedByString:@", "];
                                
                                [(PFObject *)[jobsArray objectAtIndex:count] setObject:addressString forKey:@"addressLine"];
                                
                                
                                //when area is available, update the respective cell
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:count inSection:0];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.jobTable beginUpdates];
                                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.jobTable endUpdates];
                                });
                                
                                
                                
                                
                            }
                            else{
                                [(PFObject *)[jobsArray objectAtIndex:count] setObject:@"N/A" forKey:@"area"];
                                
                            }
                            
                            
                        }
                        
                        else{
                            
                            NSLog(@"Error = %@", error);
                            
                            /*
                            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                            [alert show];*/
                            
                            // cell.jobArea.text =@"-";
                        }
                        
                    }];
                    
                    
                    //Reporting a job query
                    PFQuery *votedQuery2 = [PFQuery queryWithClassName:@"_User"];
                    //[votedQuery2 includeKey:@"aJobSeekerID"];
                    [votedQuery2 whereKey:@"jobVotedDown" equalTo:i.objectId];
                    [votedQuery2 getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
                        
                        
                        if (!error) {
                            
                            if ([[object objectForKey:@"jobVotedDown"] containsObject:i.objectId]) {
                                
                                
                                
                                [(PFObject *)[jobsArray objectAtIndex:count] setObject:@"1" forKey:@"currentUserVotedDownThisJob"];
                              //  [(PFObject *)[jobsArray objectAtIndex:count] setObject:[object objectForKey:@"aJobSeekerID"] forKey:@"jobSeekerID"];
                                
                                
                                
                            }
                            
                            else{
                                
                                [(PFObject *)[jobsArray objectAtIndex:count] setObject:@"0" forKey:@"currentUserVotedDownThisJob"];
                                
                            }
                            
                            
                        }
                        
                        
                        NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:count inSection:0];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.jobTable beginUpdates];
                            [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                            [self.jobTable endUpdates];
                        });
                        
                        
                    }];
                    
#pragma mark - Get thumb data
                    
                    /*
                    PFQuery *query =[PFQuery queryWithClassName:@"_User"];
                    
                    [query getObjectInBackgroundWithId:[[i objectForKey: @"postedByUser"] objectId] block:^(PFObject *object, NSError *error) {
                        
                        
                        
                        if (!error) {
                            
                            if ([object objectForKey:@"userThumb"]) {
                               // NSLog(@"object has job seeker id");
                                
                                

                                [(PFObject *)[jobsArray objectAtIndex:count] setObject:[object objectForKey:@"aJobSeekerID"] forKey:@"jobSeeker"];
                                
                               // NSLog(@"array object = %@", [jobsArray objectAtIndex:count]);
  
      
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:count inSection:0];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.jobTable beginUpdates];
                                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.jobTable endUpdates];
                                });
                                
                                
                                
                                
                            }
                            
                            else{
                                
                            //    NSLog(@"object has NO job seeker id");

                                                                [(PFObject *)[jobsArray objectAtIndex:count] setObject:@"" forKey:@"jobSeeker"];
                                
                                
                           //     NSLog(@"array object = %@", [jobsArray objectAtIndex:count]);

                 
                            }
                            

                        }
                        
                        else{
                            
                            NSLog(@"error");
                        }
                        
                        
                        
                        
                        
                    }];
                    
                    */
                    

                    
                    
                    
                    
                    
                    
                    count++;
                    
                    if (count == jobsArray.count) {
                        //NSLog(@"LAST ITEM REACHED=%ld",(unsigned long)count);
                        
                        //end refreshing
                        if (self.refreshControl) {
                            
                            [self.refreshControl endRefreshing];
                        }
                        
                        
                    }
                    
                    
                }
                
                

                
                
                

                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.jobTable reloadData];
                
                [_HUDProgressIndicator hide:YES];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                
                
                
                //refresh unread messages badge
                MessagesViewController *messaagesVC = [[MessagesViewController alloc] init];
                [messaagesVC getUsersWhoBlockedMe];
                
                
            });
                
            }
            
            
 
        
    }];
    
    NSLog(@"retrieve from parse called")
    ;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return jobsArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"jobCell";
    JobCustomTableViewCell *cell = [_jobTable dequeueReusableCellWithIdentifier:CellIdentifier];
    PFObject *jobObject = [jobsArray objectAtIndex:indexPath.row];
    
    //NSLog(@"Job object = %@", jobObject);
    
    
   // NSLog(@"JobObject Applied by = %@", [jobObject objectForKey:@"appliedByUsers"]);
    
    
    cell.jobTitleLabel.text = [jobObject objectForKey:@"title"];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    /*
    // programattic upvote button
    UIButton *voteUpButtonTest = [[UIButton alloc] initWithFrame:
                                  CGRectMake(260, 0, 40, 40)];
    [voteUpButtonTest setTitle:[jobObject objectForKey:@"currentUserVotedUpThisJob"] forState:UIControlStateNormal];
    [voteUpButtonTest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell addSubview:voteUpButtonTest];
    [voteUpButtonTest setTag:indexPath.row];
    [voteUpButtonTest addTarget:self action:@selector(jobVoteUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //set the image of the upvote button
    //set downvoting button icons
    if ([[jobObject objectForKey:@"currentUserVotedUpThisJob"] isEqualToString:@"1"]) {
        [voteUpButtonTest setImage:[UIImage imageNamed:@"JobVoteUp-selected"] forState:UIControlStateNormal];
    } else{
        
        [voteUpButtonTest setImage:[UIImage imageNamed:@"JobVoteUp-no-selected"] forState:UIControlStateNormal];
    }
    
    // programattic downvote button
    UIButton *voteDownButtonTest = [[UIButton alloc] initWithFrame:
                                    CGRectMake(260, 50, 40, 40)];
    [voteDownButtonTest setTitle:[jobObject objectForKey:@"currentUserVotedDownThisJob"] forState:UIControlStateNormal];
    [voteDownButtonTest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell addSubview:voteDownButtonTest];
    [voteDownButtonTest setTag:indexPath.row];
    
    [voteDownButtonTest addTarget:self action:@selector(jobVoteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //set downvoting button icons
    if ([[jobObject objectForKey:@"currentUserVotedDownThisJob"] isEqualToString:@"1"]) {
        [voteDownButtonTest setImage:[UIImage imageNamed:@"JobVoteDwn-selected"] forState:UIControlStateNormal];
    } else{
        
        [voteDownButtonTest setImage:[UIImage imageNamed:@"JobVoteDwn-no-selected"] forState:UIControlStateNormal];
    }
    
    */
    
    
    
    cell.jobVoteUpFlag.text =[jobObject objectForKey:@"currentUserVotedUpThisJob"];
    cell.jobVoteDownFlag.text =[jobObject objectForKey:@"currentUserVotedDownThisJob"];
    cell.jobVoteUpButton.titleLabel.text =[jobObject objectForKey:@"currentUserVotedUpThisJob"];
    cell.jobTitleLabel.text = [jobObject objectForKey:@"title"];
    cell.jobEmployer.text=[jobObject objectForKey:@"businessName"];
    cell.jobStatus.text=[jobObject[@"status"] objectForKey:@"description"];
    //cell.jobPostedByUsernameLabel.text = [jobObject[@"postedByUser"] objectForKey:@"username"];
    
    
    
    if ([[[PFUser currentUser] objectId] isEqualToString: [jobObject[@"postedByUser"] objectId]])
         {
             //you're the job poster
             cell.jobPostedByUsernameLabel.font = [UIFont boldSystemFontOfSize:10.0];
             //light blue
             [cell setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:234.0/255.0 blue:254.0/255.0 alpha:1]];
             if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
             
                 cell.jobPostedByUsernameLabel.text = @"You (Anonymous)";

             }
             
             else{
                 cell.jobPostedByUsernameLabel.text = [jobObject[@"postedByUser"] objectForKey:@"username"];
                 
                 

             }
   
             
         }
         
         else{

             //you're not the job poster
             cell.jobPostedByUsernameLabel.font = [UIFont systemFontOfSize:10.0];
             cell.backgroundColor = [UIColor whiteColor];

             if ([[jobObject[@"postedByUser"] objectForKey:@"signedUp"] isEqual:@YES] ) {
                 cell.jobPostedByUsernameLabel.text = [jobObject[@"postedByUser"] objectForKey:@"username"];

             }
             else{
                 cell.jobPostedByUsernameLabel.text = @"Anonymous";

                 
                 
             }

             
         }
    

    DateConverter *dateConverter = [[DateConverter alloc] init];
    cell.jobDateAdded.text = [dateConverter convertDateToLocalTime:[jobObject createdAt]];
    
    //prevent nulling of area name
    if (![jobObject objectForKey:@"area"]) {
        
        cell.jobDistanceFromUser.text =[NSString stringWithFormat:@"%.2f km",[self.userLocation distanceInKilometersTo:[jobObject objectForKey:@"geolocation"]]];
    }
    else{
        cell.jobDistanceFromUser.text = [NSString stringWithFormat:@"%@ km, %@",[NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[jobObject objectForKey:@"geolocation"]]], [jobObject objectForKey:@"area"]];
    }

    
    //set job area
    cell.jobArea.text =[jobObject objectForKey:@"area"];
    

    
    
    //set thumbnails
    if ([[jobObject objectForKey:@"postedByUser"] objectForKey:@"userThumb"]) {
           // NSLog(@"job object = %@", [[jobObject objectForKey:@"postedByUser"] objectForKey:@"userThumb"]);
        
        

        
        
        //update cv image thumb
        _userProfileThumbFile= [[jobObject objectForKey:@"postedByUser"] objectForKey:@"userThumb"];
        
        
        
        [_userProfileThumbFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                
                if (imageData) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.jobPosterImageView.image = [UIImage imageWithData:imageData];
 
                        
                    });
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    cell.jobPosterImageView.image = [UIImage imageNamed:@"Default_Profile_Picture@3x.png"];                        
                        
                    });
                    

                    
                }
                
            }
            else{
                
                NSLog(@"Error updating seeker cv image");
                /*
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];*/
            }
            
        }];
        

        
        
    }
    
    else{
        
        cell.jobPosterImageView.image = [UIImage imageNamed:@"Default_Profile_Picture@3x.png"];
        
        
    }
    
    
    
    
    

    
    
    
    return cell;
    
    
    
}



- (PFGeoPoint *) getUserLocation{
    
    //retrieve user location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            self.userLocation= geoPoint;
            
        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
            /*
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];*/
        }
    }];
    
    return userLocation;
    
}








- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showJob"]) {
        
        NSIndexPath *indexPath = [self.jobTable indexPathForSelectedRow];
        PFObject *jobObject = [jobsArray objectAtIndex:indexPath.row];
        
        JobDetailsViewController *destViewController = segue.destinationViewController;
        // Recipe *recipe = [recipes objectAtIndex:indexPath.row];
        destViewController.jobTitle = [jobObject objectForKey:@"title"];
        destViewController.jobDescription = [jobObject objectForKey:@"description"];
        destViewController.jobDistanceFromUser = [NSString stringWithFormat:@"%@ km",[NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[jobObject objectForKey:@"geolocation"]]] ];
        destViewController.jobEmployer =[jobObject objectForKey:@"businessName"];

        //destViewController.jobDateAdded =[formatter stringFromDate:[jobObject createdAt]];
        
        DateConverter *dateConverter = [[DateConverter alloc]init];
        destViewController.jobDateAdded = [dateConverter convertDateToLocalTime:[jobObject createdAt]];
        
        
        
        
        
        destViewController.jobArea =[jobObject objectForKey:@"addressLine"];
        destViewController.jobRequiredSkills = [jobObject objectForKey:@"skillsRequired"];
        destViewController.jobEducation =[jobObject objectForKey:@"degreeRequired"];
        destViewController.userLocation = self.userLocation;
        
        destViewController.jobRolesAndResponsibilities =[jobObject objectForKey:@"rolesAndResponsibilities"];
        destViewController.jobCompensation =[jobObject objectForKey:@"compensation"];
        destViewController.jobEmploymentType =[jobObject objectForKey:@"employmentType"];
        destViewController.jobIndustryType =[[jobObject objectForKey:@"jobIndustry"] objectForKey:@"name"];
        
        

        
        
        
        
        
        CLLocation  *jobLocation = [[CLLocation alloc] initWithLatitude:[[jobObject objectForKey:@"geolocation"] latitude] longitude:[[jobObject objectForKey:@"geolocation"] longitude]];
        destViewController.jobLocation = jobLocation;
        
        
        destViewController.jobAddressLine = [jobObject objectForKey:@"addressLine"];
        
        //this is basically an employer userID from the users table
        destViewController.jobEmployerUserObjectID= [[jobObject objectForKey:@"postedByUser"] objectId];
        destViewController.jobPosterPFUser =[jobObject objectForKey:@"postedByUser"];
        
        
        if ([[jobObject objectForKey:@"postedByUser"] objectForKey:@"userThumb"]) {
            destViewController.userProfileThumbFile =[[jobObject objectForKey:@"postedByUser"] objectForKey:@"userThumb"];;
            

        }
        
        //NSLog(@"Employer User = %@", [jobObject objectForKey:@"postedByUser"]);
       // destViewController.
        //array to hold who applied to the job
        destViewController.jobAppliedByUsers =[jobObject objectForKey:@"appliedByUsers"];
       // NSLog(@"Before segue: job applied by = %@",[jobObject objectForKey:@"appliedByUsers"] );
        
        //actually it's better to pass the entire pf object to the destination
        destViewController.jobObject = jobObject;
        
        
        //set the flag bar menu button according to reporting status
        
        if ([[jobObject objectForKey:@"currentUserVotedDownThisJob"] isEqualToString:@"1"]) {
            destViewController.reportJobBarButton.enabled =NO;
        } else{
            
            destViewController.reportJobBarButton.enabled =YES;
            [destViewController.reportJobBarButton setTintColor:[UIColor redColor]];

        }
        
        

        
        
        
        
        //set the style of the button update the report button.
        

        //NSLog(@"Posted by User: username: %@ objectID: %@", [[jobObject objectForKey:@"postedByUser"] objectForKey:@"username"],[[jobObject objectForKey:@"postedByUser"] objectId] );
        //NSLog(@"Employer Name: %@", [jobObject[@"employer"] objectForKey:@"employerName"]);
        //NSLog(@"UserType: %@", [jobObject[@"employer"] objectForKey:@"userType"]);
        //NSLog(@"%@", [jobObject[@"employer"] objectForKey:@"aboutEmployer"]);
        
    }
}


-(void) reloadData{
    
    // Reload table data
    [self retrieveFromParse];
    
}



- (void) getUserCity:(PFGeoPoint *)userGeoPoint{
    
    
    CLLocation  *myLocation = [[CLLocation alloc] initWithLatitude:userGeoPoint.latitude longitude:userGeoPoint.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            
            CLPlacemark *placemark = [placemarks lastObject];
            if ([[placemarks lastObject] locality] != nil ) {
                
                _HUDProgressIndicator.detailsLabelText = placemark.locality;
                
            }
            else{
                NSLog(@"error getting the city");
                /*
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];*/
                
            }
            
        }
        
        else{
            
            NSLog(@"Error = %@", error);
            /*
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];*/
        }
        
    }];
    


}

-(void) changeMessageIsReceivedValue{

    messageIsReceived = true;

    
    
}

- (IBAction)filterJobsButtonPressed:(UIBarButtonItem *)sender {
    
    
    JobsListFilterViewController *jobsFilterVC = [[JobsListFilterViewController alloc] initWithNibName:@"JobsListFilterView" bundle:nil];
    
    jobsFilterVC.delegate = self;
    [self presentViewController:jobsFilterVC animated:YES completion:nil];
    
    
}

- (void) sendFilterDistance: (double) distance{
    

    _jobsFilterDistance = [NSNumber numberWithDouble:distance];
    
    NSLog(@"delegate called with value, %f", distance);
}


- (void) sendFilterCategoriesSelected: (NSMutableArray *) categoriesSelected{
    
    _jobCategoriesSelectedArray =categoriesSelected;
    
}



- (void) reloadDelegateData{
    
    NSLog(@"reload data called");
    

    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:[_jobTable superview] animated:YES];
    _HUDProgressIndicator.labelText = @"Filtering jobs ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    [self retrieveFromParse];
}



- (void) retrieveJobCategoriesFromParse{
    
    NSLog(@"rerieve jobs categories from parse called");
    
    PFQuery *jobsCategoriesQuery = [PFQuery queryWithClassName:@"JobIndustry"];
    [jobsCategoriesQuery setLimit:1000];
    [jobsCategoriesQuery orderByAscending:@"name"];
    [jobsCategoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //NSLog(@"object = %@", objects);
            
            _jobCategoriesArray = [[NSMutableArray alloc] initWithArray:
                                   objects];
            _jobCategoriesSelectedArray = [[NSMutableArray alloc] init];
            _jobCategoriesSelectedDictionary =[[NSMutableDictionary alloc] init];
            
            int count =0;
            for (PFObject *categoryObject in _jobCategoriesArray) {
                [_jobCategoriesSelectedArray addObject:[categoryObject objectId]];
                [_jobCategoriesSelectedDictionary setValue:[categoryObject objectForKey:@"name"] forKey:[categoryObject objectId]];
                
                count++;
            }
            
            
            //save all categories and categories selected to device
            [[NSUserDefaults standardUserDefaults] setObject:_jobCategoriesSelectedArray forKey:@"jobsCategoriesArray"];
            [[NSUserDefaults standardUserDefaults] setObject:_jobCategoriesSelectedArray forKey:@"jobsCategorySelectedArrayForFilter"];
           // [[NSUserDefaults standardUserDefaults] setObject:_jobCategoriesSelectedDictionary forKey:@"jobsCategorySelectedDictionaryForFilter"];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
  
            //refresh once categories are availabe for the first time
            [self retrieveFromParse];
            
        }
        
        else{
            NSLog(@"error finding jobs category objects");
            /*
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];*/
            
            
        }
    }];
    
    
}




@end
