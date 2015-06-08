//
//  MyJobsListViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/2/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobLocationViewController.h"
#import "MyJobTableViewCell.h"
#import "JobDetailsViewController.h"

@interface MyJobsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myJobsTable;
@property (weak, nonatomic) PFObject *myJobPFObject;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


//data
@property (strong, nonatomic) NSMutableArray *myJobsArray;


- (IBAction)takeMeToJobEditor:(UIButton *)sender;
- (void) retrieveMyJobsFromParse;
- (PFGeoPoint *) getUserLocation;
- (void) getUserCity:(PFGeoPoint *)userGeoPoint;

@end
