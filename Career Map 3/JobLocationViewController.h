//
//  JobLocationViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/25/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface JobLocationViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *jobMap;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectMapTypeSegmentedControl;


- (void) zoomToUserLocation;
- (IBAction)selectMapTypePressed:(UISegmentedControl *)sender;
- (IBAction)resteToMyLocationButtonPressed:(UIButton *)sender;


@end
