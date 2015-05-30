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
#import "JobCategoryViewController.h"
#import "AddressLineConverter.h"

@interface JobLocationViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>


//MARK: Properties
@property (nonatomic, strong) PFObject *jobObject;
@property (weak, nonatomic) IBOutlet MKMapView *jobMap;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic, strong) PFGeoPoint *userLocationPoint;
@property (nonatomic, strong) PFGeoPoint *jobLocationPoint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectMapTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *resetToMyLocationButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *jobLocationAddressFetchActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *jobLocationAddressTextView;



//MARK: Actions
- (void) zoomToUserLocationPoint;
- (void) getJobLocationPoint;
- (IBAction)selectMapTypePressed:(UISegmentedControl *)sender;
- (IBAction)restetToMyLocationButtonPressed:(UIButton *)sender;


@end
