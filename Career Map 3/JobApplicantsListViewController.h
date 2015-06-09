//
//  JobApplicantsListViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/9/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobApplicantTableViewCell.h"
#import <Parse/Parse.h>
#import "ViewEditMyCVViewController.h"

@interface JobApplicantsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *jobApplicantsListTable;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *jobApplicantsArray;
@property (weak, nonatomic) PFObject *jobApplicant;
@property (weak, nonatomic) PFObject *jobPFObject;



//Mark: Actions
- (void) retrieveJobApplicantsFromParse;


@end
