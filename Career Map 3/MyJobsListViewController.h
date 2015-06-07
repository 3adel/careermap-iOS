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

@interface MyJobsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myJobsTable;



//data
@property (strong, nonatomic) NSMutableArray *myJobsArray;


- (IBAction)takeMeToJobEditor:(UIButton *)sender;
- (void) retrieveMyJobsFromParse;
@end
