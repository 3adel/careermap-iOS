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
@synthesize refreshControl;
@synthesize userLocation;
@synthesize jobsArray;
@synthesize jobsArrayWithUsersVotesVolatile;
@synthesize jobsArrayWithUsersVotesStable;
@synthesize formatter;


- (void) viewDidAppear:(BOOL)animated{
    
    //make sure the app choice screen shows one time only
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"screenShown"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"screenShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        WelcomeAppChoiceViewController  *appChoice = [[WelcomeAppChoiceViewController alloc] initWithNibName:@"WelcomeAppChoiceView" bundle:nil];
        [self.tabBarController presentViewController:appChoice
                                            animated:YES
                                          completion:nil];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
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
            [self performSelector:@selector(retrieveFromParse)];
            
        }
        else{
            UIAlertView *needUserLocationAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You need to enable user location for this app to function properly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [needUserLocationAlert show];
            
            NSLog(@"Can't get user location");
        }
    }];
    
    
}

- (void) retrieveFromParse {
    
    NSLog(@"Retrive from parse called");
    
    //query #1 for jobs
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"voteCount >=-4"];
    PFQuery *retrieveJobs = [PFQuery queryWithClassName:@"Job" predicate:predicate];
    [retrieveJobs includeKey:@"employer"];
    [retrieveJobs includeKey:@"status"];
    [retrieveJobs includeKey:@"postedByUser"];
    [retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation withinKilometers:1000000];
    [retrieveJobs orderByDescending:@"createdAt"];
    [retrieveJobs findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            jobsArray = [[NSMutableArray alloc] initWithArray:objects];
            //NSLog(@"%lu", (unsigned long)jobsArray.count);
            
            
            //Moved inside the block. This will prevent the a crash at job list tableview
            jobsArrayWithUsersVotesVolatile= [[NSMutableArray alloc] init];
            
            NSUInteger count = 0;
            for (PFObject *i in jobsArray) {
                [jobsArrayWithUsersVotesVolatile addObject:i];
                CLLocation  *jobLocation = [[CLLocation alloc] initWithLatitude:[[i objectForKey:@"geolocation"] latitude] longitude:[[i objectForKey:@"geolocation"] longitude]];
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder reverseGeocodeLocation:jobLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                    if (error == nil && [placemarks count] > 0)
                    {
                        
                        CLPlacemark *placemark = [placemarks lastObject];
                        if ([[placemarks lastObject] locality] != nil ) {
                            [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:count] setObject:[placemark locality] forKey:@"area"];
                            
                            //add the address line as a component
                            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
                            NSString *addressString = [lines componentsJoinedByString:@"\n"];
                            
                            [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:count] setObject:addressString forKey:@"addressLine"];
                            
                        }
                        else{
                            [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:count] setObject:@"N/A" forKey:@"area"];
                            
                        }
                        
                        
                    }
                    
                    else{
                        
                        NSLog(@"Error = %@", error);
                        // cell.jobArea.text =@"-";
                    }
                    
                }];
                
                
                PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
                
                [votedQuery whereKey:@"jobVotedUp" equalTo:i.objectId];
                [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
                    
                    
                    if (!error) {
                        
                        if ([[object objectForKey:@"jobVotedUp"] containsObject:i.objectId]) {
                            
                            
                            [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:count] setObject:@"1" forKey:@"currentUserVotedUpThisJob"];
                            
                        }
                        
                        else{
                            
                            [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:count] setObject:@"0" forKey:@"currentUserVotedUpThisJob"];
                            
                        }
                        
                        
                    }
                    
                    
                    
                    NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:count inSection:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.jobTable beginUpdates];
                        [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                        [self.jobTable endUpdates];
                    });
                    
                }];
                
                
                
                
                
                //query for voting down
                PFQuery *votedQuery2 = [PFQuery queryWithClassName:@"_User"];
                [votedQuery2 whereKey:@"jobVotedDown" equalTo:i.objectId];
                [votedQuery2 getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
                    
                    
                    if (!error) {
                        
                        if ([[object objectForKey:@"jobVotedDown"] containsObject:i.objectId]) {
                            
                            
                            
                            [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:count] setObject:@"1" forKey:@"currentUserVotedDownThisJob"];
                            
                            
                            
                        }
                        
                        else{
                            
                            [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:count] setObject:@"0" forKey:@"currentUserVotedDownThisJob"];
                            
                        }
                        
                        
                    }
                    
                    
                    NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:count inSection:0];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.jobTable beginUpdates];
                        [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                        [self.jobTable endUpdates];
                    });
                    
                    
                }];
                
                
                count++;
                
                if (count == jobsArray.count) {
                    //NSLog(@"LAST ITEM REACHED=%ld",(unsigned long)count);
                    
                    //end refreshing
                    if (self.refreshControl) {
                        
                        [self.refreshControl endRefreshing];
                    }
                    
                    
                }
                
            }
            
            //this will guarantee a stable index for the jobs table view.
            jobsArrayWithUsersVotesStable = [[NSMutableArray alloc] initWithArray:jobsArrayWithUsersVotesVolatile];
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.jobTable reloadData];
        });
        
    }];
    
    NSLog(@"end of parse data reached");
    
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
    PFObject *jobObject = [jobsArrayWithUsersVotesStable objectAtIndex:indexPath.row];
    cell.jobTitleLabel.text = [jobObject objectForKey:@"title"];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    
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
    
    
    
    
    
    cell.jobVoteUpFlag.text =[jobObject objectForKey:@"currentUserVotedUpThisJob"];
    cell.jobVoteDownFlag.text =[jobObject objectForKey:@"currentUserVotedDownThisJob"];
    cell.jobVoteUpButton.titleLabel.text =[jobObject objectForKey:@"currentUserVotedUpThisJob"];
    cell.jobTitleLabel.text = [jobObject objectForKey:@"title"];
    cell.jobEmployer.text=[jobObject[@"employer"] objectForKey:@"employerName"];
    cell.jobStatus.text=[jobObject[@"status"] objectForKey:@"description"];
    cell.jobDateAdded.text=[formatter stringFromDate:[jobObject createdAt]];
    cell.jobDistanceFromUser.text = [NSString stringWithFormat:@"%@ km",[NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[jobObject objectForKey:@"geolocation"]]] ];
    cell.jobVoteLabel.text =[NSString stringWithFormat:@"%@",[jobObject objectForKey:@"voteCount"]];;
    
    //set job area
    cell.jobArea.text =[jobObject objectForKey:@"area"];
    
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedUp" equalTo:jobObject.objectId];
    
    //add a tag to the voting button to indicate the current row index
    [cell.jobVoteUpButton setTag:indexPath.row];
    [cell.jobVoteUpButton addTarget:self action:@selector(jobVoteUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.jobVoteDownButton setTag:indexPath.row];
    [cell.jobVoteDownButton addTarget:self action:@selector(jobVoteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    
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
        }
    }];
    
    return userLocation;
    
}




- (IBAction)jobVoteDownPressed:(UIButton *)sender {
    
    PFObject *jobObject = [jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag];
    
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedDown" equalTo:jobObject.objectId];
    [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        if (!error) {
            //NSLog(@"Users Query Objects: %@", object);
            
            // if a record is found in the user table in the voted up
            //if the user did not vote down yet
            if (![[object objectForKey:@"jobVotedDown"] containsObject:jobObject.objectId]) {
                
                //if the user has already pressed vote up before pressing the down
                if ([[object objectForKey:@"jobVotedUp"] containsObject:jobObject.objectId]) {
                    [jobObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:-1]];
                    [[PFUser currentUser] removeObject:jobObject.objectId forKey:@"jobVotedUp"];
                    [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedUpThisJob"];
                    
                }
                
                
                [jobObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:-1]];
                
                [jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //NSLog(@"Career object removed");
                        [[PFUser currentUser] removeObject:jobObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] addUniqueObject:jobObject.objectId forKey:@"jobVotedDown"];
                        
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag] setObject:@"1" forKey:@"currentUserVotedDownThisJob"];
                                
                                
                                
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                
                                
                                //NSLog(@"NO ERRORS: Index Array = %@", cellIndexPath1);
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.jobTable beginUpdates];
                                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.jobTable endUpdates];
                                });
                                
                                
                            }
                        }];
                        
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
            }
            
            
            //if the user already voted, decrease count and refresh
            else{
                
                [jobObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:1]];
                
                [jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [[PFUser currentUser] removeObject:jobObject.objectId forKey:@"jobVotedDown"];
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedDownThisJob"];
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.jobTable beginUpdates];
                                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.jobTable endUpdates];
                                });
                                
                                
                            }
                        }];
                        
                        
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
                
            }
            
            
            
            
        }
        
        
    }];
    
    
    
    
    
}




- (IBAction)jobVoteUpPressed:(UIButton *)sender {
    
    
    PFObject *jobObject = [jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag];
    
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedUp" equalTo:jobObject.objectId];
    [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    
    
    //  NSLog(@"V2 Current user ID=%@",[[PFUser currentUser] objectId]);
    
    
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        
        if (!error) {
            //NSLog(@"Users Query Objects: %@", object);
            
            // if a record is found in the user table in the voted up
            //if the user did not vote up yet
            if (![[object objectForKey:@"jobVotedUp"] containsObject:jobObject.objectId]) {
                
                [jobObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:1]];
                
                //if the user has already pressed vote down before pressing the up
                if ([[object objectForKey:@"jobVotedDown"] containsObject:jobObject.objectId]) {
                    [jobObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:1]];
                    [[PFUser currentUser] removeObject:jobObject.objectId forKey:@"jobVotedDown"];
                    [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedDownThisJob"];
                    
                }
                
                
                
                [jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //NSLog(@"Career object removed");
                        
                        [[PFUser currentUser] addUniqueObject:jobObject.objectId forKey:@"jobVotedUp"];
                        
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag] setObject:@"1" forKey:@"currentUserVotedUpThisJob"];
                                
                                
                                
                                
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.jobTable beginUpdates];
                                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.jobTable endUpdates];
                                });
                            }
                        }];
                        
                        
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
            }
            
            
            //if the user already voted, decrease count and refresh
            else{
                
                
                //NSLog(@"The user already voted up for this");
                
                [jobObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:-1]];
                
                [jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        
                        [[PFUser currentUser] removeObject:jobObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotesVolatile objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedUpThisJob"];
                                
                                
                                
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.jobTable beginUpdates];
                                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.jobTable endUpdates];
                                });
                            }
                        }];
                        
                        
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
                
                
                
            }
            
            
            
            
        }
        
        
    }];
    
    
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showJob"]) {
        
        NSIndexPath *indexPath = [self.jobTable indexPathForSelectedRow];
        PFObject *jobObject = [jobsArrayWithUsersVotesVolatile objectAtIndex:indexPath.row];
        
        JobDetailsViewController *destViewController = segue.destinationViewController;
        // Recipe *recipe = [recipes objectAtIndex:indexPath.row];
        destViewController.jobTitle = [jobObject objectForKey:@"title"];
        destViewController.jobDescription = [jobObject objectForKey:@"description"];
        destViewController.jobDistanceFromUser = [NSString stringWithFormat:@"%@ km",[NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[jobObject objectForKey:@"geolocation"]]] ];
        destViewController.jobEmployer =[jobObject[@"employer"] objectForKey:@"employerName"];
        destViewController.jobVote = [NSString stringWithFormat:@"%@",[jobObject objectForKey:@"voteCount"]];
        destViewController.jobDateAdded =[formatter stringFromDate:[jobObject createdAt]];
        destViewController.jobArea =[jobObject objectForKey:@"area"];
        destViewController.jobRequiredSkills = [jobObject objectForKey:@"skillsRequired"];
        destViewController.jobEducation =[jobObject objectForKey:@"education"];
        destViewController.userLocation = self.userLocation;
        
        
        CLLocation  *jobLocation = [[CLLocation alloc] initWithLatitude:[[jobObject objectForKey:@"geolocation"] latitude] longitude:[[jobObject objectForKey:@"geolocation"] longitude]];
        destViewController.jobLocation = jobLocation;
        
        
        destViewController.jobAddressLine = [jobObject objectForKey:@"addressLine"];
        
        //this is basically an employer userID from the users table
        destViewController.jobEmployerUserObjectID= [[jobObject objectForKey:@"postedByUser"] objectId];
        destViewController.jobPosterPFUser =[jobObject objectForKey:@"postedByUser"];
        //NSLog(@"Employer User = %@", [jobObject objectForKey:@"postedByUser"]);
        
        
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








@end
