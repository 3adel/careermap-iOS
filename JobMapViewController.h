//
//  JobMapViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/13/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface JobMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *jobMap;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectMapTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet UITextView *jobAddressTextView;




@property (nonatomic, strong) CLLocation *jobLocation;

- (IBAction)closeMapButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)selectMapTypePressed:(UISegmentedControl *)sender;


@end
