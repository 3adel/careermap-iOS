//
//  ViewEditMyCVViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/20/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateCVViewController.h"
#import <Parse/Parse.h>
@interface ViewEditMyCVViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *noCVFoundView;
@property (weak, nonatomic) IBOutlet UIScrollView *CVContentScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *CVDataLoadingIndicator;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editCVButton;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;


//data
@property (strong, nonatomic) PFObject *jobSeekerObject;


//actions
-(void) CVViewEdit;
- (IBAction)createCVButtonPressed:(UIButton *)sender;
- (IBAction)editCVButtonPressed:(UIBarButtonItem *)sender;

@end
