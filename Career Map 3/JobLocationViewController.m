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
    
    //style
    _registerButton.layer.cornerRadius = 5.0f;
    
    //check if user is registered
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        _userIsAnonymousView.hidden =NO;
        _nextButton.enabled = NO;
    }
    
    else{
        _userIsAnonymousView.hidden =YES;
        _nextButton.enabled = YES;
        self.jobMap.delegate =self;
        self.jobMap.showsUserLocation = YES;
        _selectMapTypeSegmentedControl.selectedSegmentIndex =0;
        
        
        
        // Some style setup.
        _resetToMyLocationButton.layer.cornerRadius=5.0f;
        _jobLocationAddressTextView.layer.cornerRadius=5.0f;
        
        
        
        //initialize location manager
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        
    }
    
    
    //zoom job job location if the job location is already there
    NSLog(@"this is the job object passed = %@", _jobObject);
    if ([_jobObject objectForKey:@"geolocation"]) {
        //zoom to the job location only and keep the job object as it is
        [self zoomToLocationPoint:(PFGeoPoint *)[_jobObject objectForKey:@"geolocation"]];
        NSLog(@"this is the point  %@",[_jobObject objectForKey:@"geolocation"]);
        
        
    }
    
    
    [self getUserLocationPoint];

    
    
}


- (void) viewDidAppear:(BOOL)animated{
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) zoomToLocationPoint:(PFGeoPoint *)point{
    //zoom to job location
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = point.latitude;
    zoomLocation.longitude =point.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 400, 400);
    [_jobMap setRegion:viewRegion animated:YES];
    [_jobMap setScrollEnabled:YES];
    MKPointAnnotation *annotPoint = [[MKPointAnnotation alloc] init];
    [_jobMap addAnnotation:annotPoint];
}



- (PFGeoPoint *) getUserLocationPoint{
    
    //start animating getting user location address
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_jobLocationAddressFetchActivityIndicator startAnimating];
        _jobLocationAddressTextView.text = @"Getting user location ...";
        
    });
    
    
    //retrieve user location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            _userLocationPoint=geoPoint;
            
            //set job object location only when it's missing
            if (!_jobObject) {
                _jobLocationPoint =geoPoint;
                _jobObject = [[PFObject alloc] initWithClassName:@"Job"];
                [_jobObject setValue:_jobLocationPoint forKey:@"geolocation"];
                [_jobObject setValue:_userLocationPoint forKey:@"userLocation"];
               // NSLog(@"Job Object = %@", _jobObject );
                [self zoomToLocationPoint:_userLocationPoint];
                
                
                //update ui with found user location
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _jobLocationAddressTextView.text = @"Location found";
                    
                    //get the address of the location
                    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:_userLocationPoint.latitude longitude:_userLocationPoint.longitude];
                    [self convertLocationToAddress:userLocation];
                    
                });

                
            }

            

        }
        
        else{
            NSLog(@"Error getting user location: %@", error);
        }
    }];
    
    return _userLocationPoint;
    
}


- (void) getJobLocationPoint{
    
    //_jobLocationAddressTextView.text =@"Loading location ...";
    _jobLocationPoint = [[PFGeoPoint alloc] init];
    _jobLocationPoint.latitude =_jobMap.centerCoordinate.latitude;
    _jobLocationPoint.longitude =_jobMap.centerCoordinate.longitude;

    
    //update job object with new job location
    [_jobObject setValue:_jobLocationPoint forKey:@"geolocation"];
   // NSLog(@"Job object after pan = %@", _jobObject );
    
    
    //get the address of the job location
   // AddressLineConverter *addressConverter = [[AddressLineConverter alloc] init];
    CLLocation *jobLocation = [[CLLocation alloc] initWithLatitude:_jobLocationPoint.latitude longitude:_jobLocationPoint.longitude];
    [self convertLocationToAddress:jobLocation];
    

    
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
    
    [self zoomToLocationPoint:_userLocationPoint];
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    
    
    LoginViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"registrationViewController"];
    //  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    //[self.navigationController pushViewController:navi animated:YES];
    [self presentViewController:registerViewController animated:YES completion:nil];

    NSLog(@"Register");

    
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    NSLog(@"started dragging the map ...");
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"finished dragging the map ...");
    [self getJobLocationPoint];
    
    
    NSLog(@"job location = %@", [_jobObject objectForKey:@"geolocation"]);
    NSLog(@"user location = %@", _userLocationPoint);

    

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


- (NSString *) convertLocationToAddress: (CLLocation *) location{
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            
            CLPlacemark *placemark = [placemarks lastObject];
            if ([[placemarks lastObject] locality] != nil ) {
                
                //add the address line as a component
                NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
                NSString *addressString = [lines componentsJoinedByString:@", "];
               // NSLog(@"Address: %@", addressString);
                //NSLog(@"Addressline: %@", placemark.addressDictionary);

                _jobLocationAddressTextView.text =addressString;
                
            }
            else{
                //NSLog(@"no address found");
                _jobLocationAddressTextView.text = @"No address found";
                
                
                
            }
            
            
        }
        
        else{
            
            NSLog(@"Error = %@", error);
            // cell.jobArea.text =@"-";
        }
        
    }];
    
    return @"";
}





@end
