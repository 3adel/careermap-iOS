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
    user.username = @"adelshehadeh";
    user.password = @"passwordjkljk";
    user.email = @"email@example.com";
    
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
    
    JobCustomTableViewCell *cell = (JobCustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    
    //add a tag to the voting button to indicate the current row index
    [cell.jobVoteUpButton setTag:indexPath.row];
    [cell.jobVoteUpButton addTarget:self action:@selector(jobVoteUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    NSLog(@"vote button pressed");

    if (!tempJobVoteUpButton.isSelected) {
        
        NSLog(@"like:%d",tempJobVoteUpButton.isSelected);
        
        [tempJobVoteUpButton  setSelected:!tempJobVoteUpButton.isSelected];
        NSLog(@"like:%d",tempJobVoteUpButton.isSelected);
        
        
        NSLog(@"job vote up pressed");
        PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];
      //  NSLog(@"Tag=%ld", (long)sender.tag);
        //  NSLog(@"%@", tempObject);
        
        
        // NSLog(@"insert reocord");
        
        //  PFObject *jobRecord = [PFObject objectWithClassName:@"Job"];
        // PFGeoPoint *jobLocationPoint = [PFGeoPoint geoPointWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
        //   tempObject[@"description"]=@"Description jkljkl jkl jk";   // [jobRecord incrementKey:@"applyCount"];
        [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:1]];
        // jobRecord[@"jobCountry"]=@"JO";
        // jobRecord[@"jobStatus"]=[NSNumber numberWithInt:1];
        // jobRecord[@"postedDate"]=[NSDate date];
        // jobRecord[@"jobTitle"] = @"This is a job title";
        // jobRecord[@"jobCity"] = placemark.locality;
        // jobRecord[@"jobStreet"] = placemark.thoroughfare;
        // jobRecord[@"jobLocation"] =jobLocationPoint;
        
        
        
        //jobRecord[@"playerName"] = @"Sean Plott";
        //jobRecord[@"cheatMode"] = @NO;
        [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Career object saved");
                // NSLog(@"%@", tempObject);
                
                //Save in the voted up items of the user
                [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedUp"];
                [[PFUser currentUser] saveInBackground];
                
                
                
                [ self.jobTable reloadData];
                
                // cell.jobVoteUpButton.text =tempObject[@"applyCount"];
            } else {
                NSLog(@"Error saving career object");
            }
            
            
            
            
            
        }];
        
        

        
    }
    
    else{
        
        NSLog(@"else statement");
        PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];
        [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:-1]];
        [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Career object saved");
                // NSLog(@"%@", tempObject);
                
                //Save in the voted up items of the user
              //  [[PFUser currentUser] addUniqueObject:tempObject.objectId forKey:@"jobVotedDown"];
              //  [[PFUser currentUser] saveInBackground];
                [ self.jobTable reloadData];
                
                // cell.jobVoteUpButton.text =tempObject[@"applyCount"];
            } else {
                NSLog(@"Error saving career object");
            }
            
        }];
        

        [tempJobVoteUpButton  setSelected:!tempJobVoteUpButton.isSelected];
        

    }
    
    
    
    /*
    if (tempJobVoteUpButton.isSelected) {
        [tempJobVoteUpButton  setImage:[UIImage imageNamed:@"like-default.png"] forState:UIControlStateNormal];
    }else {
        [tempJobVoteUpButton  setImage:[UIImage imageNamed:@"like-active.png"] forState:UIControlStateSelected];
    }*/
    
    
}

- (IBAction)jobVoteDownPressed:(UIButton *)sender {
    
    
    NSLog(@"job vote down pressed");
    PFObject *tempObject = [jobsArray objectAtIndex:sender.tag];
    NSLog(@"Tag=%ld", (long)sender.tag);
    //  NSLog(@"%@", tempObject);
    
    
    // NSLog(@"insert reocord");
    
    //  PFObject *jobRecord = [PFObject objectWithClassName:@"Job"];
    // PFGeoPoint *jobLocationPoint = [PFGeoPoint geoPointWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
    //   tempObject[@"description"]=@"Description jkljkl jkl jk";   // [jobRecord incrementKey:@"applyCount"];
    [tempObject incrementKey:@"applyCount" byAmount:[NSNumber numberWithInteger:-1]];
    // jobRecord[@"jobCountry"]=@"JO";
    // jobRecord[@"jobStatus"]=[NSNumber numberWithInt:1];
    // jobRecord[@"postedDate"]=[NSDate date];
    // jobRecord[@"jobTitle"] = @"This is a job title";
    // jobRecord[@"jobCity"] = placemark.locality;
    // jobRecord[@"jobStreet"] = placemark.thoroughfare;
    // jobRecord[@"jobLocation"] =jobLocationPoint;
    
    
    
    //jobRecord[@"playerName"] = @"Sean Plott";
    //jobRecord[@"cheatMode"] = @NO;
    [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Career object saved");
            NSLog(@"%@", tempObject);
            //JobCustomTableViewCell *cell = [[JobCustomTableViewCell alloc] init];
           // [cell.jobVoteUpButton setHidden:YES];
            [ self.jobTable reloadData];
            
           
        } else {
            NSLog(@"Error saving career object");
        }
    }];
    
    
    

    
    
    
}
@end
