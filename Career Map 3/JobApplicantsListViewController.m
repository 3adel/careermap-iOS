//
//  JobApplicantsListViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/9/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobApplicantsListViewController.h"

@interface JobApplicantsListViewController ()

@end

@implementation JobApplicantsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"my jobs list view did load");
    
    //style
    //_myJobsTable.estimatedRowHeight = 73.0 ;
    //self.myJobsTable.rowHeight = UITableViewAutomaticDimension;
    
    //progress spinner initialization
    _jobApplicantsListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:_jobApplicantsListTable animated:YES];
    _HUDProgressIndicator.labelText = @"Loading applicants ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    
   // NSLog(@"job object = %@", _jobPFObject);
    
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:220.0/255.0 green:234.0/255 blue:255.0/255.0 alpha:1];
    [self.refreshControl addTarget:self
                            action:@selector(retrieveJobApplicantsFromParse)
                  forControlEvents:UIControlEventValueChanged];
    [self.jobApplicantsListTable addSubview:self.refreshControl];
    
    
    
   [self retrieveJobApplicantsFromParse];
}

- (void)viewDidAppear:(BOOL)animated{
    
    // [_myJobsTable reloadData];
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
    //return _jobApplicantsArray.count;
    return _jobApplicantsArray.count;
   // return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"JobApplicantCell";
    
    JobApplicantTableViewCell *cell = (JobApplicantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobApplicantCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    _jobApplicant = [_jobApplicantsArray objectAtIndex:indexPath.row];
    cell.jobApplicantNameLabel.text =[NSString stringWithFormat:@"%@ %@",[[_jobApplicant objectForKey:@"aJobSeekerID"] objectForKey:@"firstName"],[[_jobApplicant objectForKey:@"aJobSeekerID"] objectForKey:@"lastName"]];


    
    //update cv image thumb
    PFFile *CVThumbImageFile = [[_jobApplicant objectForKey:@"aJobSeekerID"] objectForKey:@"jobSeekerThumb"];
    
    
    
    [CVThumbImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            
            if (imageData) {
                cell.jobCandidateThumb.image = [UIImage imageWithData:imageData];
            }
            else{
                
                cell.jobCandidateThumb.image = [UIImage imageNamed:@"Default_Profile_Picture@3x.png"];

            }

        }
        else{
            
            NSLog(@"Error updating seeker cv image");
        }

    }];
    
    
    
    
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //NSLog(@"index path: %ld", indexPath.row);
    
    ViewEditMyCVViewController *jobApplicantVC =[[ViewEditMyCVViewController alloc] init];
    jobApplicantVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewEditMyCVViewController"];
    
    jobApplicantVC.cominfFromApplicantsList = YES;
    jobApplicantVC.jobCandidateObject = [_jobApplicantsArray objectAtIndex:indexPath.row];
   // UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobApplicantVC];
    //navi.navigationBarHidden = YES;
    [self presentViewController:jobApplicantVC animated:YES completion:nil];
    
    
    
    /*
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
    
    
*/
    
    
    
}

- (void) retrieveJobApplicantsFromParse{
    
    
    PFQuery *query =[PFQuery queryWithClassName:@"_User"];
    [query includeKey:@"aJobSeekerID"];
    [query whereKey:@"objectId" containedIn:[_jobPFObject objectForKey:@"appliedByUsers"]];
    [query orderByDescending:@"createdAt"];
    query.limit =1000;
     
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if (!error){
            
           // NSLog(@"users = %@", objects);
            
            
            
            if (objects.count == 0) {
                //show empty view
                
                
                
                
                //hide refresh control if no users exist
                
                if (self.refreshControl) {
                    
                    [self.refreshControl endRefreshing];
                    
                    //also show the no messages view
                    //[_noMessagesYetView setHidden:NO];
                    
                    
                    //[_HUDProgressIndicator hide:YES];
                    
                }
                
                
                
            }
            
            else{
                
                _jobApplicantsArray = [[NSMutableArray alloc] initWithArray:objects];
                
                
                
                
            }
            
            
        }
        
        else{
            
            NSLog(@"error retrieving applicants data");
            
        }
         
         //reload table
         if (self.refreshControl) {
             
             [self.refreshControl endRefreshing];
             
             //also show the no messages view
             //[_noMessagesYetView setHidden:NO];
             

             
         }
         _jobApplicantsListTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
         [_HUDProgressIndicator hide:YES];
         [_jobApplicantsListTable reloadData];
         
         
         
    }];
    
    

    
}




/*
- (PFGeoPoint *) getUserLocation{
    
    //retrieve user location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            _userLocation= geoPoint;
            
            [self getUserCity:self.userLocation];
            
            [_myJobsTable reloadData];
            
        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
        }
    }];
    
    return _userLocation;
    
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
