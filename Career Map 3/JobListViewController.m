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
    
   // NSArray *jobs;
   // PFGeoPoint *userLocation;
   // PFQuery *employerQuery;
    
}
@synthesize refreshControl;
@synthesize userLocation;
@synthesize jobsArray;
@synthesize jobsArrayWithUsersVotes;
//@synthesize locationManager;


- (void) viewDidAppear:(BOOL)animated{
    
    //make sure the app choice screen shows one time only
    
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"screenShown"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"screenShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Screen showedddddddddd");
        
        WelcomeAppChoiceViewController  *appChoice = [[WelcomeAppChoiceViewController alloc] initWithNibName:@"WelcomeAppChoiceView" bundle:nil];
        [self.tabBarController presentViewController:appChoice
                                            animated:YES
                                          completion:nil];
        
    }
    
    else{
        
        //   [self performSegueWithIdentifier:@"jobSeeker" sender:self];
        
        
    }
    // TestWelcomeView
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    //make sure the app choice screen shows one time only
    
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"screenShown"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"screenShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Screen showed");
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        WelcomeAppChoiceViewController *appChoice =
        [storyboard instantiateViewControllerWithIdentifier:@"WelcomeAppChoiceViewController"];
        
        [self presentViewController:appChoice
                           animated:YES
                         completion:nil];
        
    }
    
    else{
        
     //   [self performSegueWithIdentifier:@"jobSeeker" sender:self];
        
        
    }
    
    */
    
    
    
    
    //if the user is already logged in
                //do nothing and just view the list.
    //if the user is not logged in, create an anynymous user and hide the logout button
    
    
    
    //if the user is already logged in with an anynymous user, don't create an anoymous user and just disable the logout button instead
    
    
   // settingsViewController *i = [[settingsViewController alloc] init];
   // settingsViewController *i = [[settingsViewController alloc] initWithNibName:@"settingsViewController" bundle:nil];
 //   settingsViewController *i = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];

   // i.checkIfUserIsAnonymous = NO;
    
    
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
       // i.checkIfUserIsAnonymous =YES;
        
         //[i disableLogoutButton];
        
        
    } else {
        //No anonymous users are already created, create one please
       // [i enableLogoutButton];
        NSLog(@"user is NOT anonymous detected");
        
     
    }
    
        
        /*
         PFUser *user = [PFUser user];
         user.username = @"adelshehadehjj";
         user.password = @"passwordjkljjjjk342";
         user.email = @"email@examplfffeu.com";*/
        
        // other fields can be set just like with PFObject
        //user[@"phone"] = @"415-392-0202";
        
        /*
         [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (!error) {
         NSLog(@"User logged");
         } else {
         
         
         NSLog(@"error with login");
         }
         }];*/
        
        //login
        /*  [PFUser logInWithUsernameInBackground:user.username password:user.password
         block:^(PFUser *user, NSError *error) {
         if (user) {
         NSLog(@"User logged");
         } else {
         NSLog(@"error with login");
         }
         }];*/
        
        
        
        
        
        self.locationManager = [[CLLocationManager alloc] init];
        // [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        // [self.locationManager startUpdatingLocation];
        
        //  self.locationManager.delegate =self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        
        //  NSLog(@"User is here: %@", [self getUserLocation]);
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                self.userLocation = geoPoint;
                [self performSelector:@selector(retrieveFromParse)];
                // [self.jobTable reloadData];
                // NSLog(@"jobs data reloaded");
            }
            else{
                UIAlertView *needUserLocationAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You need to enable user location for this app to function properly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [needUserLocationAlert show];
                
                NSLog(@"Can't get user location");
            }
        }];
        
        
        
        
    
    
    
}

- (void) retrieveFromParse {
    
    //query #1 for jobs
    PFQuery *retrieveJobs = [PFQuery queryWithClassName:@"Job"];
    [retrieveJobs includeKey:@"employer"];
    [retrieveJobs includeKey:@"status"];
    [retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation withinKilometers:1000000];
  // [retrieveJobs orderByDescending:@"geolocation"];
    [retrieveJobs orderByDescending:@"createdAt"];

    
    
    
    //query #2 for voting up data inclusion
    //PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    //[votedQuery whereKey:@"objectID" equalTo:[[PFUser currentUser] objectId]];
    //[votedQuery whereKey:@"jobVotedUp" equalTo:];


    jobsArrayWithUsersVotes = [[NSMutableArray alloc] init];

    
    // query.cachePolicy = kPFCachePolicyCacheThenNetwork;
   // jobsArrayWithUsersVotes = [[NSMutableArray alloc]init];
    
    [retrieveJobs findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            jobsArray = [[NSMutableArray alloc] initWithArray:objects];
             // NSLog(@"%@", jobsArray);
            
            
            NSUInteger count = 0;
            for (PFObject *i in jobsArray) {
              //  NSLog(@"Index = %lu, ObjID = %@, Title=%@", (unsigned long)count, i.objectId, [i objectForKey:@"title"]);
                
                
               // [i setObject:@"1" forKey:@"currentUserVotedUpThisJob"];
               // NSLog(@"Title # %ld: %@, votedUp = %@",count,[i objectForKey:@"title"], [i objectForKey:@"currentUserVotedUpThisJob"]);
              //  NSLog(@"Title # %ld: %@, votedUp = %@",count,[i objectForKey:@"title"], [i objectForKey:@"currentUserVotedUpThisJob"]);

                [jobsArrayWithUsersVotes addObject:i];
        
                
                
                
                //get area of job
                
                 //area of the job
                
              //  NSLog(@"job = %@", i);
                
                CLLocation *jobLocation = [[CLLocation alloc] initWithLatitude:[[i objectForKey:@"geolocation"] latitude] longitude:[[i objectForKey:@"geolocation"] longitude]];
                 CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                 [geocoder reverseGeocodeLocation:jobLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                 // NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                 if (error == nil && [placemarks count] > 0)
                 {
                 
                 
                     CLPlacemark *placemark = [placemarks lastObject];
                     if ([[placemarks lastObject] locality] != nil ) {
                         [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:count] setObject:[placemark locality] forKey:@"area"];
                         NSLog(@"%@", [placemark locality]);
                     }
                     else{
                         [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:count] setObject:@"N/A" forKey:@"area"];
                         
                     }
                     
                     
                     
                 
                 //NSLog(@"Job: %@",[tempObject objectForKey:@"title"] );
                 //   CLPlacemark *placemark =
                 
                 //  cell.jobArea.text =placemark.locality;
                 
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
                            
                            
                            
                           // NSLog(@" #%ld: object found VOTED UP", count);
                            [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:count] setObject:@"1" forKey:@"currentUserVotedUpThisJob"];
                           // NSLog(@"1: %@", [i objectForKey:@"title"]);

                            
                     
                            
                            
                            
                            
                            

                            
                        }
                        
                        else{
                            //NSLog(@" #%ld: object NOT found VOTED UP", count);

                            [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:count] setObject:@"0" forKey:@"currentUserVotedUpThisJob"];
                           // NSLog(@"0: %@", [i objectForKey:@"title"]);
                           // [self.jobTable reloadData];

                         
                            
                            
                        }
                        
                        // NSLog(@"object ID temp: %@",i.objectId);
                        
                        // NSLog(@"UpVote: %@ Title: %@", [i objectForKey:@"currentUserVotedUpThisJob"], [i objectForKey:@"title"]);
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    else{
                        NSLog(@"weeeeeeeeeeeee");
                        
                        
                    }
                    
                    NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:count inSection:0];
                    [self.jobTable beginUpdates];
                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                    [self.jobTable endUpdates];
                    
                }];
                
                
                
                
                
                //query for voting down
                
                
                PFQuery *votedQuery2 = [PFQuery queryWithClassName:@"_User"];
                
                [votedQuery2 whereKey:@"jobVotedDown" equalTo:i.objectId];
                [votedQuery2 getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
                    
                    
                    if (!error) {
                        
                        if ([[object objectForKey:@"jobVotedDown"] containsObject:i.objectId]) {
                            
                            
                            
                          //  NSLog(@" #%ld: object found VOTED down", count);
                            [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:count] setObject:@"1" forKey:@"currentUserVotedDownThisJob"];
                            // NSLog(@"1: %@", [i objectForKey:@"title"]);
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        else{
                          //  NSLog(@" #%ld: object NOT found VOTED Down", count);
                            
                            [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:count] setObject:@"0" forKey:@"currentUserVotedDownThisJob"];
                            // NSLog(@"0: %@", [i objectForKey:@"title"]);
                            // [self.jobTable reloadData];
                            
                           
                            
                            
                        }
                        
                        // NSLog(@"object ID temp: %@",i.objectId);
                        
                        // NSLog(@"UpVote: %@ Title: %@", [i objectForKey:@"currentUserVotedUpThisJob"], [i objectForKey:@"title"]);
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    else{
                        NSLog(@"weeeeeeeeeeeee");
                        
                        
                    }
                    
                   // NSLog(@"refresh cells run");
                    NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:count inSection:0];
                    [self.jobTable beginUpdates];
                    [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                    [self.jobTable endUpdates];
                    
                }];

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                

                count++;
                
                if (count == jobsArray.count) {
                    NSLog(@"LAST ITEM REACHED=%ld",(unsigned long)count);
                }
                
            }
          //  NSLog(@"%@", jobsArray);


            
            
        }
        [self.jobTable reloadData];
    }];
    

    
    
    

    
    NSLog(@"end of parse data reached");
    //[self.jobTable reloadData];

    
    
    
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (id)initWithCoder:(NSCoder *)aCoder
{
 
 

 
 
 
 
 
   // [self getUserLocation];
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Job";
 
        // The key of the PFObject to display in the label of the default cell style
        // self.textKey = @"title";
        
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        self.objectsPerPage = 5;
        
        //[self getUserLocation];

    }
    return self;
}
*/
/*
- (PFQuery *)queryForTable
{
    
    //Get all jobs and include pointers to employer, status tables and sort them
    

    
    
    if (!self.userLocation) {
        return nil;
    }
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
   // [query whereKey:@"geolocation" nearGeoPoint:self.userLocation];
    [query includeKey:@"employer"];
    [query includeKey:@"status"];
    [query whereKey:@"geolocation" nearGeoPoint:self.userLocation withinKilometers:100000000];
   // [query orderByDescending:@"createdAt"];

    
    if (!self.userLocation) {
        NSLog(@"Error: I can't get user location");
    }
    
    else{
        NSLog(@"Success getting location");
            }
    
    

   // query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    


    return query;
}*/


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
    
    

    
    
    
    
   // JobCustomTableViewCell *cell = [[JobCustomTableViewCell alloc] init];
    JobCustomTableViewCell *cell = [_jobTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
   // NSLog(@"All objects: %@", jobsArrayWithUsersVotes);
    
    
    //[testButton addTarget:<#(id)#> action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>]
    
    
    
    
    //cell.accessoryType = UITableViewCellAccessoryNone;
    PFObject *tempObject = [jobsArrayWithUsersVotes objectAtIndex:indexPath.row];
    cell.jobTitleLabel.text = [tempObject objectForKey:@"title"];
   // NSLog(@"%@",[tempObject objectForKey:@"currentUserVotedUpThisJob"]);

    
    
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
  //  NSLog(@"VotingUp= %@ %@", [tempObject objectForKey:@"currentUserVotedUpThisJob"],[tempObject objectForKey:@"title"]);
    
    
    // programattic upvote button
    UIButton *voteUpButtonTest = [[UIButton alloc] initWithFrame:
                            CGRectMake(260, 0, 40, 40)];
    [voteUpButtonTest setTitle:[tempObject objectForKey:@"currentUserVotedUpThisJob"] forState:UIControlStateNormal];
    //voteUpButtonTest.backgroundColor = [UIColor redColor ];
    [voteUpButtonTest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //imageView.image = [UIImage imageNamed:@"Icon.png"];
    [cell addSubview:voteUpButtonTest];
    [voteUpButtonTest setTag:indexPath.row];
    [voteUpButtonTest addTarget:self action:@selector(jobVoteUpPressedV2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //set the image of the upvote button
    //[voteUpButtonTest setImage:[UIImage imageNamed:@"navigate-yup-icon.png"] forState:UIControlStateNormal];

    //set downvoting button icons
    if ([[tempObject objectForKey:@"currentUserVotedUpThisJob"] isEqualToString:@"1"]) {
        [voteUpButtonTest setImage:[UIImage imageNamed:@"JobVoteUp-selected"] forState:UIControlStateNormal];
    } else{
        
        [voteUpButtonTest setImage:[UIImage imageNamed:@"JobVoteUp-no-selected"] forState:UIControlStateNormal];
    }
    
    
    
    
    
    // programattic downvote button
    UIButton *voteDownButtonTest = [[UIButton alloc] initWithFrame:
                                  CGRectMake(260, 50, 40, 40)];
    [voteDownButtonTest setTitle:[tempObject objectForKey:@"currentUserVotedDownThisJob"] forState:UIControlStateNormal];
    //voteDownButtonTest.backgroundColor = [UIColor redColor ];
    [voteDownButtonTest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //imageView.image = [UIImage imageNamed:@"Icon.png"];
    [cell addSubview:voteDownButtonTest];
    [voteDownButtonTest setTag:indexPath.row];

    [voteDownButtonTest addTarget:self action:@selector(jobVoteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    
   
    //set downvoting button icons
    if ([[tempObject objectForKey:@"currentUserVotedDownThisJob"] isEqualToString:@"1"]) {
        [voteDownButtonTest setImage:[UIImage imageNamed:@"JobVoteDwn-selected"] forState:UIControlStateNormal];
    } else{
        
        [voteDownButtonTest setImage:[UIImage imageNamed:@"JobVoteDwn-no-selected"] forState:UIControlStateNormal];
    }
    
    
    
    
    
    cell.jobVoteUpFlag.text =[tempObject objectForKey:@"currentUserVotedUpThisJob"];
    cell.jobVoteDownFlag.text =[tempObject objectForKey:@"currentUserVotedDownThisJob"];
    
    
    cell.jobVoteUpButton.titleLabel.text =[tempObject objectForKey:@"currentUserVotedUpThisJob"];
    cell.jobTitleLabel.text = [tempObject objectForKey:@"title"];
    cell.jobEmployer.text=[tempObject[@"employer"] objectForKey:@"employerName"];
    
    /*
    //set job status color. Remember status is a pointer
    if ([[tempObject objectForKey:@"status"] isEqualToString:@"1"]) {
        [voteDownButtonTest setImage:[UIImage imageNamed:@"JobVoteDwn-selected"] forState:UIControlStateNormal];
    } else{
        
        [voteDownButtonTest setImage:[UIImage imageNamed:@"JobVoteDwn-no-selected"] forState:UIControlStateNormal];
    }*/
    
    cell.jobStatus.text=[tempObject[@"status"] objectForKey:@"description"];
    cell.jobDateAdded.text=[formatter stringFromDate:[tempObject createdAt]];
    // NSNumber *jobDistanceNumber = [NSNumber numberWithDouble:[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]];
    
    
  //  NSString *k=
    
    cell.jobDistanceFromUser.text = [NSString stringWithFormat:@"%@ km",[NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[tempObject objectForKey:@"geolocation"]]] ];
    
    
    
    
    cell.jobVoteLabel.text =[NSString stringWithFormat:@"%@",[tempObject objectForKey:@"voteCount"]];;
    
  
    
    //set job area
    NSLog(@"Area of job = %@", [tempObject objectForKey:@"area"]);
    cell.jobArea.text =[tempObject objectForKey:@"area"];
    
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedUp" equalTo:tempObject.objectId];
   // [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    
    
   // NSLog(@"Current user ID=%@",[[PFUser currentUser] objectId]);
    
    
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        
        if (!error) {
            //jobsArray = [[NSArray alloc] initWithArray:objects];
            //NSLog(@"Users Query Objects: %@", object);
             // [cell.jobVoteUpButton setSelected:YES];
            
            // if a record is found in the user table in the voted up
            
           // NSLog(@"print object =%@",[object objectForKey:@"jobVotedUp"]);
           // NSLog(@"object ID temp: %@",tempObject.objectId);
            
            
            if ([[object objectForKey:@"jobVotedUp"] containsObject:tempObject.objectId]) {
                //NSLog(@"foundddddddddd");
                

                
               // [cell.jobVoteUpButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
              
                //[self.jobTable reloadData];
               // [cell.jobVoteUpButton setSelected:YES];
             //   cell.backgroundColor = [UIColor blueColor];
            }
            
            
            
            
        }
          else{
            NSLog(@"weeeeeeeeeeeeee");
            
            
        }
        
    }];
    
    
   /*
    
    [votedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //jobsArray = [[NSArray alloc] initWithArray:objects];
            NSLog(@"Users Query Objects: %@", objects);
            //  [cell.jobVoteUpButton setSelected:YES];
            
            // if a record is found in the user table in the voted up
            
            if ([objects objectAtIndex:0]) {
                ;
            }
            
            
        }
        
        else{
            
            NSLog(@"weeeeeeeeeeeeee");
        }
        //[self.jobTable reloadData];
    }];
    
    
    */
    
    
    
    
    
    
    
    //  NSLog(@"Temp object: %@", tempObject);
    
    
    
    /*
    
    if (condition) {
        [cell.jobVoteUpButton setSelected:YES];
    }
    
    [query whereKey:@"arrayKey" equalTo:@"individualItem"];

    
    PFQuery *retrieveJobs = [PFQuery queryWithClassName:@"Job"];
    //  [retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation];
    [retrieveJobs includeKey:@"employer"];
    [retrieveJobs includeKey:@"status"];
    //[retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation withinKilometers:100000000];
    [retrieveJobs orderByDescending:@"createdAt"];
    
*/
    
     
     
     
     
     
     
     
     
     
    
    
    
    
    //add a tag to the voting button to indicate the current row index
    [cell.jobVoteUpButton setTag:indexPath.row];
    [cell.jobVoteUpButton addTarget:self action:@selector(jobVoteUpPressedV2:) forControlEvents:UIControlEventTouchUpInside];
    
    ///[cell.jobVoteLabel setTag:indexPath.row];
    
    [cell.jobVoteDownButton setTag:indexPath.row];
    [cell.jobVoteDownButton addTarget:self action:@selector(jobVoteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Configure the cell
    //   PFFile *thumbnail = [object objectForKey:@"image"];
    //  PFImageView *thumbnailImageView = (PFImageView*)cell.thumbnailImageView;
    // thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    //   thumbnailImageView.file = thumbnail;
    //  [thumbnailImageView loadInBackground];
    
   // NSLog(@"Object: %@", object.createdAt);
    
    //set table cell labels with reference to pointers
    /*
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    
    cell.jobTitleLabel.text = [object objectForKey:@"title"];
    cell.jobEmployer.text=[object[@"employer"] objectForKey:@"employerName"];
    cell.jobStatus.text=[object[@"status"] objectForKey:@"description"];
    cell.jobDateAdded.text=[formatter stringFromDate:[object createdAt]];
    // NSNumber *jobDistanceNumber = [NSNumber numberWithDouble:[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]];
    
    
    
    cell.jobDistanceFromUser.text = [NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]];
    
    NSLog(@"Distance = %.2f", [self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]);
    
    //[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]];
    
    
    // NSLog(@"Employer %ld:%@",indexPath.row, [object[@"employer"] objectForKey:@"employerName"]);
    
    // NSString        *dateString;
    
    */
    
    
    
    /// NSLog(@"Date Added:%@",[formatter stringFromDate:[object createdAt]]);
    
    return cell;
    
    
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"jobCell";
    
    JobCustomTableViewCell *cell = (JobCustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
 //   PFFile *thumbnail = [object objectForKey:@"image"];
  //  PFImageView *thumbnailImageView = (PFImageView*)cell.thumbnailImageView;
   // thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
 //   thumbnailImageView.file = thumbnail;
  //  [thumbnailImageView loadInBackground];
    
    NSLog(@"Object: %@", object.createdAt);
    
    //set table cell labels with reference to pointers
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    
    cell.jobTitleLabel.text = [object objectForKey:@"title"];
    cell.jobEmployer.text=[object[@"employer"] objectForKey:@"employerName"];
    cell.jobStatus.text=[object[@"status"] objectForKey:@"description"];
    cell.jobDateAdded.text=[formatter stringFromDate:[object createdAt]];
   // NSNumber *jobDistanceNumber = [NSNumber numberWithDouble:[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]];
    
    
    
    cell.jobDistanceFromUser.text = [NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]];
    
    NSLog(@"Distance = %.2f", [self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]);
    
    //[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]];
    
    
   // NSLog(@"Employer %ld:%@",indexPath.row, [object[@"employer"] objectForKey:@"employerName"]);
    
   // NSString        *dateString;
    

    
    
    
   /// NSLog(@"Date Added:%@",[formatter stringFromDate:[object createdAt]]);
    
    return cell;
}*/

//inactive



- (PFGeoPoint *) getUserLocation{
    
    NSLog(@"running user location");
   //PFGeoPoint *i = [[PFGeoPoint alloc] init];
    //retrieve user location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"LAT: %f, LONG: %f", geoPoint.latitude, geoPoint.longitude);
            
          //  PFQuery *query = [PFQuery queryWithClassName:@"Careers"];
        
            
           // userLocation = geoPoint;
          //  return userLocation;
            self.userLocation= geoPoint;
            
         //   [self queryForTable];
            
        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
        }
    }];
    
    
  //  NSLog(@"LAT: %f, LONG: %f", userLocation.latitude, userLocation.longitude);
    
    
    
    
    return userLocation;

}




- (IBAction)jobVoteDownPressed:(UIButton *)sender {
    
    PFObject *tempObject = [jobsArrayWithUsersVotes objectAtIndex:sender.tag];
    // NSLog(@"%@Jobs array", jobsArray);
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedDown" equalTo:tempObject.objectId];
    [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    
    
   // NSLog(@"V2 Current user ID=%@",[[PFUser currentUser] objectId]);
    
    
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        if (!error) {
            //jobsArray = [[NSArray alloc] initWithArray:objects];
            NSLog(@"Users Query Objects: %@", object);
            // [cell.jobVoteUpButton setSelected:YES];
            
            // if a record is found in the user table in the voted up
            
            // NSLog(@"print object =%@",[object objectForKey:@"jobVotedUp"]);
            // NSLog(@"object ID temp: %@",tempObject.objectId);
            
            
            
            //if the user did not vote down yet
            if (![[object objectForKey:@"jobVotedDown"] containsObject:tempObject.objectId]) {
               /// NSLog(@"foundddddddddd");
                
                //if the user has already pressed vote up before pressing the down
                if ([[object objectForKey:@"jobVotedUp"] containsObject:tempObject.objectId]) {
                    [tempObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:-1]];
                    [[PFUser currentUser] removeObject:tempObject.objectId forKey:@"jobVotedUp"];
                    [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedUpThisJob"];

                }
                
                
                [tempObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:-1]];
                
                [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Career object removed");
                          [[PFUser currentUser] removeObject:tempObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedDown"];
                        
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:sender.tag] setObject:@"1" forKey:@"currentUserVotedDownThisJob"];
                              
                                
                                
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
                                // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
                                // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                                
                                NSLog(@"NO ERRORS: Index Array = %@", cellIndexPath1);
                                
                                // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                                
                                [self.jobTable beginUpdates];
                                [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                [self.jobTable endUpdates];
                            }
                        }];

                        
                        
                        
                        
                    
                    
                    
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
                
                
                // [cell.jobVoteUpButton setSelected:YES];
                //   cell.backgroundColor = [UIColor blueColor];
            }
            
            
            //if the user already voted, decrease count and refresh
            else{
                
                NSLog(@"The user already voted up for this");
                
                [tempObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:1]];
                
                [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        // NSLog(@"Career object removed");
                        //  [[PFUser currentUser] removeObject:tempObject.objectId forKey:forKey:@"jobVotedUp"];
                        // [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] removeObject:tempObject.objectId forKey:@"jobVotedDown"];
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedDownThisJob"];
                                
                                
                                
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
                                // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
                                // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                                
                                NSLog(@"NO ERRORS: Index Array = %@", cellIndexPath1);
                                
                                // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                                
                                [self.jobTable beginUpdates];
                                [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                [self.jobTable endUpdates];
                            }
                        }];
                        
                        //   [ self.jobTable reloadData];
                        
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
                
                
                // [cell.jobVoteUpButton setSelected:YES];
                //   cell.backgroundColor = [UIColor blueColor];
                
                
                
            }
            
            
            
            
        }
        else{
            NSLog(@"weeeeeeeeeeeeee");
            
            
        }
        
    }];
    
    
    
    
    
}




- (IBAction)jobVoteUpPressedV2:(UIButton *)sender {
    
    
    PFObject *tempObject = [jobsArrayWithUsersVotes objectAtIndex:sender.tag];
    // NSLog(@"%@Jobs array", jobsArray);
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedUp" equalTo:tempObject.objectId];
    [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    
    
  //  NSLog(@"V2 Current user ID=%@",[[PFUser currentUser] objectId]);
    
    
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        
        if (!error) {
            //jobsArray = [[NSArray alloc] initWithArray:objects];
            NSLog(@"Users Query Objects: %@", object);
            // [cell.jobVoteUpButton setSelected:YES];
            
            // if a record is found in the user table in the voted up
            
            // NSLog(@"print object =%@",[object objectForKey:@"jobVotedUp"]);
            // NSLog(@"object ID temp: %@",tempObject.objectId);
            
            
            
            //if the user did not vote up yet
            if (![[object objectForKey:@"jobVotedUp"] containsObject:tempObject.objectId]) {
               // NSLog(@"foundddddddddd");
                
                [tempObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:1]];

                
                
                //if the user has already pressed vote down before pressing the up
                if ([[object objectForKey:@"jobVotedDown"] containsObject:tempObject.objectId]) {
                    [tempObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:1]];
                    [[PFUser currentUser] removeObject:tempObject.objectId forKey:@"jobVotedDown"];
                    [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedDownThisJob"];
                    
                }
                
                
                
                [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Career object removed");
                        //  [[PFUser currentUser] removeObject:tempObject.objectId forKey:forKey:@"jobVotedUp"];
                        [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedUp"];
                       // [[PFUser currentUser] saveInBackground];
                        
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:sender.tag] setObject:@"1" forKey:@"currentUserVotedUpThisJob"];
                                
                                
                                
                                
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
                                // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
                                // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                                
                                NSLog(@"NO ERRORS: Index Array = %@", cellIndexPath1);
                                
                                // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                                
                                [self.jobTable beginUpdates];
                                [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                [self.jobTable endUpdates];
                            }
                        }];
                       
                        
                        //[sender reloadInputViews];
                        
                        
                        //[sender setNeedsDisplay];
                        //   [ self.jobTable reloadData];
                        
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
                
                
                // [cell.jobVoteUpButton setSelected:YES];
                //   cell.backgroundColor = [UIColor blueColor];
            }
            
            
            //if the user already voted, decrease count and refresh
            else{

                
                NSLog(@"The user already voted up for this");
                
                [tempObject incrementKey:@"voteCount" byAmount:[NSNumber numberWithInteger:-1]];
                
                [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                       // NSLog(@"Career object removed");
                        //  [[PFUser currentUser] removeObject:tempObject.objectId forKey:forKey:@"jobVotedUp"];
                       // [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] removeObject:tempObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                
                                //don't forget to update the main array.
                                [(PFObject *)[jobsArrayWithUsersVotes objectAtIndex:sender.tag] setObject:@"0" forKey:@"currentUserVotedUpThisJob"];
                                
                                
                                
                                
                                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                                //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
                                // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
                                // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                                
                                NSLog(@"NO ERRORS: Index Array = %@", cellIndexPath1);
                                
                                // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                                
                                [self.jobTable beginUpdates];
                                [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationNone];
                                [self.jobTable endUpdates];
                            }
                        }];

                        
                        //   [ self.jobTable reloadData];
                        
                    } else {
                        NSLog(@"Error saving career object");
                    }
                    
                }];
                
                
                
                // [cell.jobVoteUpButton setSelected:YES];
                //   cell.backgroundColor = [UIColor blueColor];
                
                
                
            }
            
            
            
            
        }
        else{
            NSLog(@"weeeeeeeeeeeeee");
            
            
        }
        
    }];
    
    
    
    
    
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ;
}



- (void)refresh:(id)sender
{
    // do your refresh here and reload the tablview
   // [self.jobTable reloadData];
}

- (IBAction)testButton:(UIButton *)sender {
    
    NSLog(@"test button clicked");
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showJob"]) {
        
        NSIndexPath *indexPath = [self.jobTable indexPathForSelectedRow];
        PFObject *tempObject = [jobsArrayWithUsersVotes objectAtIndex:indexPath.row];
        
        JobDetailsViewController *destViewController = segue.destinationViewController;
       // Recipe *recipe = [recipes objectAtIndex:indexPath.row];
        destViewController.jobTitle = [tempObject objectForKey:@"title"];
        destViewController.jobDescription = [tempObject objectForKey:@"description"];

        
        
        NSLog(@"%@", tempObject);
    }
}







@end
