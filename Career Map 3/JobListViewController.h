//
//  JobListViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Job.h"
//#import "WelcomeAppChoiceViewController.h"
#import "WelcomeAppChoiceViewController.h"
#import "JobDetailsViewController.h"
#import "MBProgressHUD.h"
#import "LoadingJobListEmptyView.h"

@interface JobListViewController : UITableViewController <CLLocationManagerDelegate,MBProgressHUDDelegate>

{
    
  //  dispatch_queue_t myQueue;

    
    
}

- (PFGeoPoint *) getUserLocation;
- (void) retrieveFromParse;

@property (strong, nonatomic) IBOutlet UITableView *jobTable;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic, strong) PFGeoPoint *userLocation;




@property (nonatomic, strong) NSMutableArray *jobsArray;
@property (nonatomic, strong) NSMutableArray *jobsArrayWithUsersVotesVolatile;
@property (nonatomic, strong) NSMutableArray *jobsArrayWithUsersVotesStable;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSArray *jobRequireSkills;
@property (nonatomic, strong) NSString *jobEmployerUserObjectID;
@property (nonatomic, strong) PFUser *jobPosterPFUser;
@property (nonatomic, strong) MBProgressHUD *HUDProgressIndicator;


- (IBAction)jobVoteUpPressed:(UIButton *)sender;
- (IBAction)jobVoteDownPressed:(UIButton *)sender;
- (void) getUserCity: (PFGeoPoint *) userGeoPoint;


@end
