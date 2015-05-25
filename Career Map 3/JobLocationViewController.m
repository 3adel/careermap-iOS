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
    
    [self getUserLocation];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) zoomToUserLocation{
    //zoom to job location
    
    CLLocationCoordinate2D userZoomLocation;
    userZoomLocation.latitude = _userLocation.latitude;
    userZoomLocation.longitude =_userLocation.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userZoomLocation, 400, 400);
    [_jobMap setRegion:viewRegion animated:YES];
    [_jobMap setScrollEnabled:YES];
    MKPointAnnotation *userPoint = [[MKPointAnnotation alloc] init];
    [_jobMap addAnnotation:userPoint];
}



- (PFGeoPoint *) getUserLocation{
    
    //retrieve user location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            _userLocation= geoPoint;
            [self zoomToUserLocation];

        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
        }
    }];
    
    return _userLocation;
    
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
    
    [self zoomToUserLocation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
