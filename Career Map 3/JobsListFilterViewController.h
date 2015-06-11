//
//  JobsListViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/10/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendFilterData <NSObject>

- (void) sendFilterDistance: (double) distance;
- (void) reloadDelegateData;


@end



@interface JobsListFilterViewController : UIViewController


@property(nonatomic,assign)id delegate;
- (IBAction)cancelFilterButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)applyFilterButtonPressed:(UIBarButtonItem *)sender;

@end
