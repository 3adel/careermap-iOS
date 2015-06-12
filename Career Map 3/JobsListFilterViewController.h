//
//  JobsListViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/10/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JobCategoryTableViewCell.h"

@protocol sendFilterData <NSObject>

- (void) sendFilterDistance: (double) distance;
- (void) sendFilterCategoriesSelected: (NSMutableArray *) categoriesSelected;

- (void) reloadDelegateData;
- (void) retrieveJobCategoriesFromParse;

@end



@interface JobsListFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property(nonatomic,assign)id delegate;
- (IBAction)cancelFilterButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)applyFilterButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceFilterLabel;
@property (weak, nonatomic) IBOutlet UISlider *jobsDistanceFilterSlider;
@property (nonatomic, strong) NSMutableArray *jobCategoriesArray;
@property (nonatomic, strong) NSMutableArray *jobCategoriesSelectedArray;
@property (nonatomic, strong) NSMutableArray *updatedJobCategoriesSelectedArray;
@property (nonatomic, strong) NSMutableArray *removeCategoriesArray;




@property (weak, nonatomic) IBOutlet UITableView *jobCategoriesTable;
@property (weak, nonatomic) IBOutlet JobCategoryTableViewCell *jobCategoryCellOutlet;


- (IBAction)jobsDistanceFilterChanged:(UISlider *)sender;

@end
