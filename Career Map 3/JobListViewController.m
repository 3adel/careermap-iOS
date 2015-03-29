//
//  JobListViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobListViewController.h"
#import "JobCustomTableViewCell.h"


@implementation JobListViewController{
    
   // NSArray *jobs;
   // PFGeoPoint *userLocation;
   // PFQuery *employerQuery;
    
}

@synthesize userLocation;
@synthesize jobsArray;
//@synthesize locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    PFUser *user = [PFUser user];
    user.username = @"adelshehadehjj";
    user.password = @"passwordjkljjjjk342";
    user.email = @"email@examplfffeu.com";
    
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
    [PFUser logInWithUsernameInBackground:user.username password:user.password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"User logged");
                                        } else {
                                            NSLog(@"error with login");
                                        }
                                    }];
    
    
    
    
    
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
            [self.jobTable reloadData];
            NSLog(@"jobs data reloaded");
        }
        else{
            UIAlertView *needUserLocationAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You need to enable user location for this app to function properly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [needUserLocationAlert show];
            
            NSLog(@"Can't get user location");
        }
    }];
    
    
    
}

- (void) retrieveFromParse {
    
    PFQuery *retrieveJobs = [PFQuery queryWithClassName:@"Job"];
  //  [retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation];
    [retrieveJobs includeKey:@"employer"];
    [retrieveJobs includeKey:@"status"];
    //[retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation withinKilometers:100000000];
     [retrieveJobs orderByDescending:@"createdAt"];
    /*
    
    if (!self.userLocation) {
        NSLog(@"Error: I can't get user location");
    }
    
    else{
        NSLog(@"Success getting location");
    }*/
    
    
    
    // query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    

    
    [retrieveJobs findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            jobsArray = [[NSArray alloc] initWithArray:objects];
         //   NSLog(@"%@", jobsArray);
        }
        [self.jobTable reloadData];
    }];
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    /*
     [votedQuery getObjectInBackgroundWithId:tempObject.objectId block:^(PFObject *object, NSError *error) {
     if (!error) {
     //jobsArray = [[NSArray alloc] initWithArray:objects];
     NSLog(@"jjjjjjjjjj: %@", object);
     [cell.jobVoteUpButton setSelected:YES];
     }
     //[self.jobTable reloadData];
     }];*/
    
    
    
   
    
    
    
    
    
    
    
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
    JobCustomTableViewCell *cell = (JobCustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    //cell.accessoryType = UITableViewCellAccessoryNone;
    PFObject *tempObject = [jobsArray objectAtIndex:indexPath.row];
    cell.jobTitleLabel.text = [tempObject objectForKey:@"title"];
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    
    cell.jobTitleLabel.text = [tempObject objectForKey:@"title"];
    cell.jobEmployer.text=[tempObject[@"employer"] objectForKey:@"employerName"];
    cell.jobStatus.text=[tempObject[@"status"] objectForKey:@"description"];
    cell.jobDateAdded.text=[formatter stringFromDate:[tempObject createdAt]];
    // NSNumber *jobDistanceNumber = [NSNumber numberWithDouble:[self.userLocation distanceInKilometersTo:[object objectForKey:@"geolocation"]]];
    
    
    
    cell.jobDistanceFromUser.text = [NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[tempObject objectForKey:@"geolocation"]]];
    
    
    cell.jobVoteLabel.text =[NSString stringWithFormat:@"%@",[tempObject objectForKey:@"applyCount"]];;
    
  
    
    
    
    
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedUp" equalTo:tempObject.objectId];
   // [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    
    
    NSLog(@"Current user ID=%@",[[PFUser currentUser] objectId]);
    
    
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        
        if (!error) {
            //jobsArray = [[NSArray alloc] initWithArray:objects];
            //NSLog(@"Users Query Objects: %@", object);
             // [cell.jobVoteUpButton setSelected:YES];
            
            // if a record is found in the user table in the voted up
            
           // NSLog(@"print object =%@",[object objectForKey:@"jobVotedUp"]);
           // NSLog(@"object ID temp: %@",tempObject.objectId);
            
            
            if ([[object objectForKey:@"jobVotedUp"] containsObject:tempObject.objectId]) {
                NSLog(@"foundddddddddd");
                
            
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


- (IBAction)jobVoteUpPressed:(UIButton *)sender {
    
    UIButton *tempJobVoteUpButton =  (UIButton *)sender;
    
    NSLog(@"VOTE UP PRESSED");

    if (!tempJobVoteUpButton.isSelected) {
        
        NSLog(@"like:%d",tempJobVoteUpButton.isSelected);
        
        [tempJobVoteUpButton  setSelected:!tempJobVoteUpButton.isSelected];
        NSLog(@"like:%d",tempJobVoteUpButton.isSelected);
        
        
        NSLog(@"job vote up pressed");
        PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];


        [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:1]];


        [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Career object saved");
                
                //Save in the voted up items of the user
                [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedUp"];
                [[PFUser currentUser] saveInBackground];
                
                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
              //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
               // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
               // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                
                NSLog(@"Index Array = %@", cellIndexPath1);
                
               // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                
                [self.jobTable beginUpdates];
                [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationFade];
                [self.jobTable endUpdates];
                
                
                
                
               // [ self.jobTable reloadData];
                
            } else {
                NSLog(@"Error saving career object");
            }
            
            
            
            
            
        }];
        
        

        
    }
    
    //if voted up already, undo the upvoting and substract 1 from parse votes
    else{
        
        NSLog(@"else statement");
        PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];
        [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:-1]];
      
        [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Career object removed");
              //  [[PFUser currentUser] removeObject:tempObject.objectId forKey:forKey:@"jobVotedUp"];
                [[PFUser currentUser] removeObject:tempObject.objectId forKey:@"jobVotedUp"];
                [[PFUser currentUser] saveInBackground];
                
                NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
                // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
                // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                
                NSLog(@"Index Array = %@", cellIndexPath1);
                
                // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                
                [self.jobTable beginUpdates];
                [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationFade];
                [self.jobTable endUpdates];

             //   [ self.jobTable reloadData];
                
            } else {
                NSLog(@"Error saving career object");
            }
            
        }];
        

        [tempJobVoteUpButton  setSelected:!tempJobVoteUpButton.isSelected];
        

    }
    

}

- (IBAction)jobVoteDownPressed:(UIButton *)sender {
    
    UIButton *tempJobVoteDownButton =  (UIButton *)sender;
    
    NSLog(@"Vote Down button pressed");
    
    if (!tempJobVoteDownButton.isSelected) {
        
        NSLog(@"like:%d",tempJobVoteDownButton.isSelected);
        
        [tempJobVoteDownButton  setSelected:!tempJobVoteDownButton.isSelected];
        NSLog(@"like:%d",tempJobVoteDownButton.isSelected);
        
        
        NSLog(@"job vote up pressed");
        PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];
        
        
        [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:-1]];
        
        
        [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Career object saved");
                
                //Save in the voted up items of the user
                [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedDown"];
                [[PFUser currentUser] saveInBackground];
                
                
                
                [ self.jobTable reloadData];
                
            } else {
                NSLog(@"Error saving career object");
            }
            
            
            
            
            
        }];
        
        
        
        
    }
    
    //if voted up already, undo the upvoting and substract 1 from parse votes
    else{
        
        NSLog(@"else statement");
        PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];
        [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:1]];
        [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Career object saved");
                
                [ self.jobTable reloadData];
                
            } else {
                NSLog(@"Error saving career object");
            }
            
        }];
        
        
        [tempJobVoteDownButton  setSelected:!tempJobVoteDownButton.isSelected];
        
        
    }
    
    
    
}




- (IBAction)jobVoteUpPressedV2:(UIButton *)sender {
    
    
    PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];
    // NSLog(@"%@Jobs array", jobsArray);
    //if the user already voted up, mark upvote button as selected
    PFQuery *votedQuery = [PFQuery queryWithClassName:@"_User"];
    [votedQuery whereKey:@"jobVotedUp" equalTo:tempObject.objectId];
    [votedQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId] ];
    
    
    NSLog(@"V2 Current user ID=%@",[[PFUser currentUser] objectId]);
    
    
    [votedQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        
        if (!error) {
            //jobsArray = [[NSArray alloc] initWithArray:objects];
            NSLog(@"Users Query Objects: %@", object);
            // [cell.jobVoteUpButton setSelected:YES];
            
            // if a record is found in the user table in the voted up
            
            // NSLog(@"print object =%@",[object objectForKey:@"jobVotedUp"]);
            // NSLog(@"object ID temp: %@",tempObject.objectId);
            
            
            
            //if the user did not vote yet
            if (![[object objectForKey:@"jobVotedUp"] containsObject:tempObject.objectId]) {
                NSLog(@"foundddddddddd");
                
                [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:1]];
                
                [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Career object removed");
                        //  [[PFUser currentUser] removeObject:tempObject.objectId forKey:forKey:@"jobVotedUp"];
                        [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] saveInBackground];
                        NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                        //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
                        // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
                        // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                        
                        NSLog(@"Index Array = %@", cellIndexPath1);
                        
                        // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                        
                        [self.jobTable beginUpdates];
                        [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationFade];
                        [self.jobTable endUpdates];
                        
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
                
                [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:-1]];
                
                [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                       // NSLog(@"Career object removed");
                        //  [[PFUser currentUser] removeObject:tempObject.objectId forKey:forKey:@"jobVotedUp"];
                       // [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] removeObject:tempObject.objectId forKey:@"jobVotedUp"];
                        [[PFUser currentUser] saveInBackground];
                        NSIndexPath* cellIndexPath1= [NSIndexPath indexPathForRow:sender.tag inSection:0];
                        //  NSIndexPath* cellIndexPath2= [NSIndexPath indexPathForRow:4 inSection:1];
                        // SIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:2];
                        // NSArray* indexArray = [NSArray arrayWithObjects:cellIndexPath1,cellIndexPath2,nil];
                        
                        NSLog(@"Index Array = %@", cellIndexPath1);
                        
                        // [self.jobTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                        
                        [self.jobTable beginUpdates];
                        [self.jobTable reloadRowsAtIndexPaths:@[cellIndexPath1] withRowAnimation:UITableViewRowAnimationFade];
                        [self.jobTable endUpdates];
                        
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






@end
