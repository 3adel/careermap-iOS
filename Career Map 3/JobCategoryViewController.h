//
//  JobCategoryViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/26/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddJobDetailsViewController.h"


@interface JobCategoryViewController : UIViewController




//MARK: Outlets
@property (strong, nonatomic) IBOutlet UIButton *jobCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *PreviouslySelectedJobCategoryButton;
@property (weak, nonatomic) IBOutlet UIScrollView *jobCategoryScrollView;


//MARK: Data
@property (nonatomic, strong) PFObject *jobObject;
@property (nonatomic, strong) NSMutableArray *jobCategoriesArray;

//MARK: Methods
- (void) jobCategoryButtonPressed: (UIButton *) sender;
- (void) retrieveJobCategoriesFromParse;

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender;


@end
