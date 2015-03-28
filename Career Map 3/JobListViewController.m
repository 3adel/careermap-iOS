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
    
    
    self.locationManager = [[CLLocationManager alloc] init];

    //[self.locationManager startUpdatingLocation];
    
    // [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
    // [self.locationManager startUpdatingLocation];
    
  //  self.mapView.delegate =self;
    
    //  self.locationManager.delegate =self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    
  //  NSLog(@"User is here: %@", [self getUserLocation]);
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.userLocation = geoPoint;
            [self loadObjects];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

- (PFQuery *)queryForTable
{
    
    //Get all jobs and include pointers to employer, status tables and sort them
    

   // [self getUserLocation];
    
    
    /*
    
    //dispatch calculating location on another thread
    myQueue = dispatch_queue_create("com.adel.mapsapp", NULL);
    dispatch_async(myQueue, ^{[self getUserLocation];
    
    
    
    
    });*/
    
    
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
}


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
}

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
            
            [self queryForTable];
            
        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
        }
    }];
    
    
  //  NSLog(@"LAT: %f, LONG: %f", userLocation.latitude, userLocation.longitude);
    
    
    
    
    return userLocation;

}


@end
