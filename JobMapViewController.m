//
//  JobMapViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/13/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobMapViewController.h"

@interface JobMapViewController ()

@end

@implementation JobMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.jobMap.delegate =self;
    _selectMapTypeSegmentedControl.selectedSegmentIndex =0;
    
    
    [self zoomToJobLocation];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)closeMapButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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



- (void) zoomToJobLocation{
    
    
    
    /*
     //convert job cllocation to parse point to be used for zooming
     PFGeoPoint *jobLocationPoint = [[PFGeoPoint alloc] init];
     jobLocationPoint.latitude =self.jobLocation.coordinate.latitude;
     jobLocationPoint.longitude =self.jobLocation.coordinate.longitude;
     
     */
    
    //double k = ;
    // NSLog(@"distance is = %f",k);
    
    
    //zoom to job location
    CLLocationCoordinate2D jobZoomLocation;
    jobZoomLocation= self.jobLocation.coordinate;
    //  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(jobZoomLocation, ([self.userLocation distanceInKilometersTo: jobLocationPoint])*250, ([self.userLocation distanceInKilometersTo: jobLocationPoint])*250);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(jobZoomLocation, 800, 800);
    [_jobMap setRegion:viewRegion animated:YES];
    [_jobMap setScrollEnabled:YES];
    
    
    //  NSNumber *jobDistanceNumber = [NSNumber numberWithDouble:[self.userLocation2 distanceInKilometersTo:self.jobLocation]];
    // NSLog(@"user location %@", jobDistanceNumber);
    
    
    //[self.joblocation distanceInKilometersTo
    
    //add job annotation
    // Add an annotation
    MKPointAnnotation *jobPoint = [[MKPointAnnotation alloc] init];
    jobPoint.coordinate = self.jobLocation.coordinate;
   // jobPoint.title = self.jobTitle;
    // jobPoint.subtitle = [self.jobDistanceFromUser stringByAppendingString:[NSString stringWithFormat:@", %@", self.jobAddressLine]];
   // jobPoint.subtitle = self.jobAddressLine;
    [_jobMap addAnnotation:jobPoint];
    
    
    
    
    
}


@end
