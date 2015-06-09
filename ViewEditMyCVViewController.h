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
#import "AppHorizontalMessage.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"

@interface ViewEditMyCVViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *noCVFoundView;
@property (weak, nonatomic) IBOutlet UIScrollView *CVContentScrollView;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editCVButton;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *aJobSeekerThumb;

@property (weak, nonatomic) IBOutlet UILabel *CVJobSeekerCurrentTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *CVJobSeekerAboutMeTextView;
@property (weak, nonatomic) IBOutlet UILabel *CVJobSeekerEducationLabel;
@property (weak, nonatomic) IBOutlet UILabel *CVJobSeekerDegreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CVJobSeekerYearsOfExperienceLabel;
@property (weak, nonatomic) IBOutlet UIButton *createCVButton;
@property (strong, nonatomic) UIAlertView *registerAlert;


@property (weak, nonatomic) IBOutlet UITextView *jobSkillsTextView;

@property (weak, nonatomic) IBOutlet UILabel *CVJobSeekerSchool;
@property (strong, nonatomic) AppHorizontalMessage *saveCVButtonPressedMessage;
@property (strong, nonatomic) MBProgressHUD *MBProgressHUDSaveButtonPressedIndicator;
@property (strong, nonatomic) MBProgressHUD *MBProgressHUDLoadingCV;

//data
@property (strong, nonatomic) PFObject *jobCandidateObject;
@property (strong, nonatomic) PFObject *jobSeekerObject;
@property (weak, nonatomic) IBOutlet UINavigationBar *CVViewNavigationBar;
@property BOOL cominfFromApplicantsList;
@property (weak, nonatomic) IBOutlet UIButton *messageCandidateButton;


//actions
-(void) CVViewEdit;
-(void) fillCandidateCV;


- (IBAction)createCVButtonPressed:(UIButton *)sender;
- (IBAction)editCVButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)messageCandidateButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *CVNavigationItem;

@end
