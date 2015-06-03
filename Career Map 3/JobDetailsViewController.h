//
//  JobDetailsViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "JobMapViewController.h"
#import "JobChatViewController.h"
#import "CreateCVViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "JobLocationViewController.h"

@interface JobDetailsViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

//outlets

@property (weak, nonatomic) IBOutlet UITextView *jobDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *jobTitleTextView;
@property (weak, nonatomic) IBOutlet UILabel *jobEmployerLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDateAddedLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceFromUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobVoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *jobVoteUpButton;
@property (weak, nonatomic) IBOutlet UIButton *jobVoteDownButton;
@property (weak, nonatomic) IBOutlet UIButton *applyWithCVButton;
@property (weak, nonatomic) IBOutlet UIButton *messageEmployerButton;
;

@property (weak, nonatomic) IBOutlet MKMapView *jobMap;
@property (weak, nonatomic) IBOutlet UIView *jobSkillsView;
@property (weak, nonatomic) IBOutlet UIScrollView *jobDetailsScrollView;
@property (weak, nonatomic) IBOutlet UITextView *jobsSkillsTextView;
@property (weak, nonatomic) IBOutlet UITextView *jobEducationTextView;
@property (weak, nonatomic) IBOutlet UITextView *jobRolesAndResponsibilitiesTextView;
@property (weak, nonatomic) IBOutlet UITextView *jobCompensationTextView;
@property (weak, nonatomic) IBOutlet UITextView *jobEmploymentTypeTextView;
@property (weak, nonatomic) IBOutlet UITextView *jobIndustryTypeTextView;
@property (weak, nonatomic) IBOutlet UIButton *editJobButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteJobButton;
@property (weak, nonatomic) IBOutlet UILabel *jobActionsLabel;




@property (strong, nonatomic) UIAlertView *createCVAlert;
@property (strong, nonatomic) UIAlertView *registerAlert;
@property (strong, nonatomic) UIAlertView *deleteJobAlert;
@property (strong, nonatomic) UIAlertView *reportJobAlert;



@property (weak, nonatomic) IBOutlet UIBarButtonItem *reportJobBarButton;


//data
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *jobDescription;
@property (nonatomic, strong) NSString *jobEmployer;
@property (nonatomic, strong) NSString *jobDateAdded;
@property (nonatomic, strong) NSString *jobDistanceFromUser;
@property (nonatomic, strong) NSString *jobVote;
@property (nonatomic, strong) NSString *jobArea;
@property (nonatomic, strong) NSString *jobStatus;
@property (nonatomic, strong) NSArray *jobRequiredSkills;

@property (nonatomic, strong) NSString *jobRolesAndResponsibilities;
@property (nonatomic, strong) NSString *jobCompensation;
@property (nonatomic, strong) NSString *jobEmploymentType;
@property (nonatomic, strong) NSString *jobIndustryType;


@property (nonatomic, strong) CLLocation *jobLocation;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic,strong) NSString *jobAddressLine;
@property (nonatomic, strong) NSString *jobEducation;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic, strong) NSString *jobEmployerUserObjectID;
@property (nonatomic, strong) PFUser *jobPosterPFUser;
@property (nonatomic, strong) NSArray *jobAppliedByUsers;
@property (nonatomic,strong) PFObject *jobObject;
@property BOOL jobIsReportedByThisUser;
@property (nonatomic, strong) MBProgressHUD *HUDProgressIndicator;


//methods

- (void) showJobDirection;
- (void) deleteJob;
- (void) reportJob;

- (IBAction)chatWithEmployerButtonPressed:(UIButton *)sender;
- (IBAction)applyWithCVButtonPressed:(UIButton *)sender;
- (IBAction)reportJobButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)editJobButtonPressed:(UIButton *)sender;
- (IBAction)deleteJobButtonPressed:(UIButton *)sender;

@end
