//
//  JobLocationViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/25/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobLocationViewController.h"

@interface JobLocationViewController ()

@end

@implementation JobLocationViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.jobMap.delegate =self;
    self.jobMap.showsUserLocation = YES;
    _selectMapTypeSegmentedControl.selectedSegmentIndex =0;

    
    
    // Some style setup.
    _resetToMyLocationButton.layer.cornerRadius=5.0f;
    
    
    //initialize location manager
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
}


- (void) viewDidAppear:(BOOL)animated{
    
    [self getUserLocationPoint];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) zoomToUserLocationPoint{
    //zoom to job location
    
    CLLocationCoordinate2D userZoomLocation;
    userZoomLocation.latitude = _userLocationPoint.latitude;
    userZoomLocation.longitude =_userLocationPoint.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userZoomLocation, 400, 400);
    [_jobMap setRegion:viewRegion animated:YES];
    [_jobMap setScrollEnabled:YES];
    MKPointAnnotation *userPoint = [[MKPointAnnotation alloc] init];
    [_jobMap addAnnotation:userPoint];
}



- (PFGeoPoint *) getUserLocationPoint{
    
    //retrieve user location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            _userLocationPoint=geoPoint;
            _jobLocationPoint =geoPoint;
            
            [self zoomToUserLocationPoint];
            
            
            _jobObject = [[PFObject alloc] initWithClassName:@"Job"];
            [_jobObject setValue:_userLocationPoint forKey:@"userLocation"];
            [_jobObject setValue:_jobLocationPoint forKey:@"geolocation"];
            NSLog(@"Job Object = %@", _jobObject );
            

        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
        }
    }];
    
    return _userLocationPoint;
    
}


- (void) getJobLocationPoint{
    
    _jobLocationPoint = [[PFGeoPoint alloc] init];
    _jobLocationPoint.latitude =_jobMap.centerCoordinate.latitude;
    _jobLocationPoint.longitude =_jobMap.centerCoordinate.longitude;

    
    //update job object with new job location
    [_jobObject setValue:_jobLocationPoint forKey:@"geolocation"];
    NSLog(@"Job object after pan = %@", _jobObject );

    
}

- (IBAction)selectMapTypePressed:(UISegmentedControl *)sender {
    
    
    switch (self.selectMapTypeSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            [_jobMap setMapType:MKMapTypeStandard];
            break;
        case 1:
            [_jobMap setMapType:MKMapTypeHybrid];
            break;
            
        case 2:
            [_jobMap setMapType:MKMapTypeSatellite];
        default:
            break;
    }
    
    
    
}

- (IBAction)restetToMyLocationButtonPressed:(UIButton *)sender {
    
    [self zoomToUserLocationPoint];
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    NSLog(@"started dragging the map ...");
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"finished dragging the map ...");
    [self getJobLocationPoint];

    //get the center location of the map
    
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"jobCategorySegue"]) {
        
        JobCategoryViewController *destViewController = segue.destinationViewController;
        destViewController.jobObject = _jobObject;
        
    }
}





@end
