//
//  MyJobsListViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/2/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "MyJobsListViewController.h"

@interface MyJobsListViewController ()

@end

@implementation MyJobsListViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"my jobs list view did load");
    
    //stylec
    _myJobsTable.estimatedRowHeight = 73.0 ;
    self.myJobsTable.rowHeight = UITableViewAutomaticDimension;
    _createJobButton.layer.cornerRadius = 5.0f;
    
    
    //progress spinner initialization
    _myJobsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:_myJobsTable animated:YES];
    _HUDProgressIndicator.labelText = @"Loading your openings ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:220.0/255.0 green:234.0/255 blue:255.0/255.0 alpha:1];
    [self.refreshControl addTarget:self
                            action:@selector(retrieveMyJobsFromParse)
                  forControlEvents:UIControlEventValueChanged];
    [self.myJobsTable addSubview:self.refreshControl];
    
    
    
    [self getUserLocation];
    [self retrieveMyJobsFromParse];
}

- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");

    
}

- (void)viewDidAppear:(BOOL)animated{
    
   // [_myJobsTable reloadData];
    
    NSLog(@"view did appear");
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    
    return _myJobsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MyJobCell";
    
    MyJobTableViewCell *cell = (MyJobTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyJobCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    _myJobPFObject = [_myJobsArray objectAtIndex:indexPath.row];
    cell.jobTitle.text = [_myJobPFObject objectForKey:@"title"];
    
    if ([[_myJobPFObject objectForKey:@"appliedByUsers"] count] ==0) {
            cell.jobAppliedCount.text =@"No applicants yet";
        cell.jobAppliedCount.textColor = [UIColor lightGrayColor];
    }
    else{

        cell.jobAppliedCount.text =[NSString stringWithFormat:@"%lu applied",(unsigned long)[[_myJobPFObject objectForKey:@"appliedByUsers"] count]];
        //green
        cell.jobAppliedCount.textColor =[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    }


    return cell;
    

}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    NSLog(@"index path: %ld", indexPath.row);
    PFObject *jobObject = [_myJobsArray objectAtIndex:indexPath.row];

    
    
    JobDetailsViewController *jobDetailsVC = [[JobDetailsViewController alloc] init];
    jobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"jobDetailsViewController"];
    
    [jobDetailsVC.reportJobBarButton setEnabled:NO];
    
    jobDetailsVC.jobObject = [_myJobsArray objectAtIndex:indexPath.row];
    jobDetailsVC.jobTitle = [jobObject objectForKey:@"title"];
    jobDetailsVC.jobDescription = [jobObject objectForKey:@"description"];
    jobDetailsVC.jobDistanceFromUser = [NSString stringWithFormat:@"%@ km",[NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[jobObject objectForKey:@"geolocation"]]] ];
    jobDetailsVC.jobArea =[jobObject objectForKey:@"addressLine"];
    jobDetailsVC.jobEmployer =[jobObject objectForKey:@"businessName"];
    DateConverter *dateConverter = [[DateConverter alloc]init];
    jobDetailsVC.jobDateAdded = [dateConverter convertDateToLocalTime:[jobObject createdAt]];
    
    
    jobDetailsVC.jobRequiredSkills = [jobObject objectForKey:@"skillsRequired"];
    jobDetailsVC.jobEducation =[jobObject objectForKey:@"degreeRequired"];
    jobDetailsVC.userLocation = self.userLocation;
    
    jobDetailsVC.jobRolesAndResponsibilities =[jobObject objectForKey:@"rolesAndResponsibilities"];
    jobDetailsVC.jobCompensation =[jobObject objectForKey:@"compensation"];
    jobDetailsVC.jobEmploymentType =[jobObject objectForKey:@"employmentType"];
    jobDetailsVC.jobIndustryType =[[jobObject objectForKey:@"jobIndustry"] objectForKey:@"name"];
    
    
    CLLocation  *jobLocation = [[CLLocation alloc] initWithLatitude:[[jobObject objectForKey:@"geolocation"] latitude] longitude:[[jobObject objectForKey:@"geolocation"] longitude]];
    jobDetailsVC.jobLocation = jobLocation;
    
    
    jobDetailsVC.jobAddressLine = [jobObject objectForKey:@"addressLine"];
    
    //this is basically an employer userID from the users table
    jobDetailsVC.jobEmployerUserObjectID= [[jobObject objectForKey:@"postedByUser"] objectId];
    jobDetailsVC.jobPosterPFUser =[jobObject objectForKey:@"postedByUser"];
    
    jobDetailsVC.jobAppliedByUsers =[jobObject objectForKey:@"appliedByUsers"];
    // NSLog(@"Before segue: job applied by = %@",[jobObject objectForKey:@"appliedByUsers"] );
    
    //actually it's better to pass the entire pf object to the destination
    
    
    //set the flag bar menu button according to reporting status
    

    

    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobDetailsVC];
    [self.navigationController pushViewController:navi animated:YES];
    

  
}*/



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showJob"]) {
        
        NSIndexPath *indexPath = [self.myJobsTable indexPathForSelectedRow];
        PFObject *jobObject = [_myJobsArray objectAtIndex:indexPath.row];
        
        JobDetailsViewController *jobDetailsVC = segue.destinationViewController;
        
        
        
        
        [jobDetailsVC.reportJobBarButton setEnabled:NO];
        
        jobDetailsVC.jobObject = [_myJobsArray objectAtIndex:indexPath.row];
        jobDetailsVC.jobTitle = [jobObject objectForKey:@"title"];
        jobDetailsVC.jobDescription = [jobObject objectForKey:@"description"];
        jobDetailsVC.jobDistanceFromUser = [NSString stringWithFormat:@"%@ km",[NSString stringWithFormat:@"%.2f",[self.userLocation distanceInKilometersTo:[jobObject objectForKey:@"geolocation"]]] ];
        jobDetailsVC.jobArea =[jobObject objectForKey:@"addressLine"];
        jobDetailsVC.jobEmployer =[jobObject objectForKey:@"businessName"];
        DateConverter *dateConverter = [[DateConverter alloc]init];
        jobDetailsVC.jobDateAdded = [dateConverter convertDateToLocalTime:[jobObject createdAt]];
        
        
        jobDetailsVC.jobRequiredSkills = [jobObject objectForKey:@"skillsRequired"];
        jobDetailsVC.jobEducation =[jobObject objectForKey:@"degreeRequired"];
        jobDetailsVC.userLocation = self.userLocation;
        
        jobDetailsVC.jobRolesAndResponsibilities =[jobObject objectForKey:@"rolesAndResponsibilities"];
        jobDetailsVC.jobCompensation =[jobObject objectForKey:@"compensation"];
        jobDetailsVC.jobEmploymentType =[jobObject objectForKey:@"employmentType"];
        jobDetailsVC.jobIndustryType =[[jobObject objectForKey:@"jobIndustry"] objectForKey:@"name"];
        
        
        CLLocation  *jobLocation = [[CLLocation alloc] initWithLatitude:[[jobObject objectForKey:@"geolocation"] latitude] longitude:[[jobObject objectForKey:@"geolocation"] longitude]];
        jobDetailsVC.jobLocation = jobLocation;
        
        
        jobDetailsVC.jobAddressLine = [jobObject objectForKey:@"addressLine"];
        
        //this is basically an employer userID from the users table
        jobDetailsVC.jobEmployerUserObjectID= [[jobObject objectForKey:@"postedByUser"] objectId];
        jobDetailsVC.jobPosterPFUser =[jobObject objectForKey:@"postedByUser"];
        
        jobDetailsVC.jobAppliedByUsers =[jobObject objectForKey:@"appliedByUsers"];
        // NSLog(@"Before segue: job applied by = %@",[jobObject objectForKey:@"appliedByUsers"] );
        
        //actually it's better to pass the entire pf object to the destination
        
        
        //set the flag bar menu button according to reporting status
        

        

        
    }
}




- (void) retrieveMyJobsFromParse{
    
    PFQuery *query =[PFQuery queryWithClassName:@"Job"];
    [query includeKey:@"jobIndustry"];
    [query whereKey:@"postedByUser"
             equalTo: [PFUser currentUser]];
    [query orderByDescending:@"updatedAt"];
    query.limit =1000;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            ///NSLog(@"objects : %@", objects);
   
            if (objects.count == 0) {
                //show empty view
                //hide refresh control if no users exist
                
                    if (self.refreshControl) {
                        
                        [self.refreshControl endRefreshing];

                        //also show the no messages view
                        [_noJobsView setHidden:NO];
                        
                        
                        [_HUDProgressIndicator hide:YES];
                        
                        _myJobsArray = [[NSMutableArray alloc] init];


                        
                        
                    }


                
            }
            else{
                
                _myJobsArray = [[NSMutableArray alloc] initWithArray:objects];
                
                
                [_noJobsView setHidden:YES];

                
                /*
                NSUInteger count = 0;
                for (PFObject *i in _myJobsArray) {
                    CLLocation  *jobLocation = [[CLLocation alloc] initWithLatitude:[[i objectForKey:@"geolocation"] latitude] longitude:[[i objectForKey:@"geolocation"] longitude]];
                    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                    [geocoder reverseGeocodeLocation:jobLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error == nil && [placemarks count] > 0)
                        {
                            
                            CLPlacemark *placemark = [placemarks lastObject];
                            if ([[placemarks lastObject] locality] != nil ) {
                                [(PFObject *)[_myJobsArray objectAtIndex:count] setObject:[placemark locality] forKey:@"area"];
                                
                                //add the address line as a component
                                NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
                                NSString *addressString = [lines componentsJoinedByString:@", "];
                                
                                [(PFObject *)[_myJobsArray objectAtIndex:count] setObject:addressString forKey:@"addressLine"];
                                
                                
                                
                                
                                
                            }
                            else{
                                [(PFObject *)[_myJobsArray objectAtIndex:count] setObject:@"N/A" forKey:@"area"];
                                
                            }
                            
                            
                        }
                        
                        else{
                            
                            NSLog(@"Error = %@", error);
                            // cell.jobArea.text =@"-";
                        }
                        
                    }];
                    
                    
                    count++;
                    
                    if (count == _myJobsArray.count) {
                        //NSLog(@"LAST ITEM REACHED=%ld",(unsigned long)count);
//                        
//                        //end refreshing
//                        if (self.refreshControl) {
//                            
//                            [self.refreshControl endRefreshing];
//                        }
                        
                        
                    }
                    
                    
                }
*/
                
                
                
                

            }


        }
        
        else{
            
            NSLog(@"error retrieving my jobs");
        }
        
        
        //reload table
        if (self.refreshControl) {
            
            [self.refreshControl endRefreshing];
            
            //also show the no messages view
            //[_noJobsView setHidden:NO];
            
            
            [_HUDProgressIndicator hide:YES];
            
        }
        _myJobsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        [_myJobsTable reloadData];
    }];
    
    
    
}



- (IBAction)takeMeToJobEditor:(UIButton *)sender {
    

    JobLocationViewController *jobLocationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"jobLocationViewController"];
    
    
    
    
    
    
    
    //here where you pass the job object
    
    //go
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobLocationVC];
    [self.navigationController pushViewController:navi animated:YES];


}


- (PFGeoPoint *) getUserLocation{
    
    //retrieve user location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            _userLocation= geoPoint;

          //  [self getUserCity:self.userLocation];
            
            [_myJobsTable reloadData];
            
        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
        }
    }];
    
    return _userLocation;
    
}

/*
- (void) getUserCity:(PFGeoPoint *)userGeoPoint{
    
    
    CLLocation  *myLocation = [[CLLocation alloc] initWithLatitude:userGeoPoint.latitude longitude:userGeoPoint.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            
            CLPlacemark *placemark = [placemarks lastObject];
            if ([[placemarks lastObject] locality] != nil ) {
                
               // _HUDProgressIndicator.detailsLabelText = placemark.locality;
                
            }
            else{
                NSLog(@"error getting the city");
                
            }
            
        }
        
        else{
            
            NSLog(@"Error = %@", error);
        }
        
    }];
    
    
    
}

*/



- (IBAction)createJobsButtonPressed:(UIButton *)sender {
    
    [self.tabBarController setSelectedIndex:2];

    
    
}
@end
