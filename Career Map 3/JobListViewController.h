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
#import "AppDelegate.h"
#import "JobsListFilterViewController.h"
#import <Google/Analytics.h>
@interface JobListViewController : UITableViewController <CLLocationManagerDelegate,MBProgressHUDDelegate, sendFilterData>

{
    
  //  dispatch_queue_t myQueue;

    
    
}

- (PFGeoPoint *) getUserLocation;
- (void) retrieveFromParse;

@property (strong, nonatomic) IBOutlet UITableView *jobTable;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, strong) LoadingJobListEmptyView *noJobsView;

@property (nonatomic, strong) NSMutableArray *jobsArray;

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSArray *jobRequireSkills;
@property (nonatomic, strong) NSString *jobEmployerUserObjectID;
@property (nonatomic, strong) PFUser *jobPosterPFUser;
@property (nonatomic, strong) MBProgressHUD *HUDProgressIndicator;





//data
@property (nonatomic, strong) NSNumber *jobsFilterDistance;
@property (weak, nonatomic) IBOutlet UINavigationItem *jobListNavigationItem;
@property (nonatomic, strong) NSMutableArray *jobCategoriesArray;
@property (nonatomic, strong) NSMutableArray *jobCategoriesSelectedArray;
@property (nonatomic, strong) NSMutableDictionary *jobCategoriesSelectedDictionary;
@property (nonatomic, strong) PFFile *userProfileThumbFile;




//track if the user received a message push notif

- (void) getUserCity: (PFGeoPoint *) userGeoPoint;
- (void) changeMessageIsReceivedValue;

- (IBAction)filterJobsButtonPressed:(UIBarButtonItem *)sender;
- (void) retrieveJobCategoriesFromParse;

@end
