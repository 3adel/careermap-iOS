//
//  JobListViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Job.h"

@interface JobListViewController : UITableViewController <CLLocationManagerDelegate>{
    
  //  dispatch_queue_t myQueue;

    
    
}

- (PFGeoPoint *) getUserLocation;
- (void) retrieveFromParse;

@property (strong, nonatomic) IBOutlet UITableView *jobTable;


@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, strong) NSArray *jobsArray;
- (IBAction)jobVoteUpPressed:(UIButton *)sender;

- (IBAction)jobVoteDownPressed:(UIButton *)sender;


@end
