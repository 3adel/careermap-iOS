//
//  JobDetailsViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface JobDetailsViewController : UIViewController <MKMapViewDelegate>

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

@property (weak, nonatomic) IBOutlet MKMapView *jobMap;
@property (weak, nonatomic) IBOutlet UIView *jobSkillsView;
@property (weak, nonatomic) IBOutlet UIScrollView *jobDetailsScrollView;
@property (weak, nonatomic) IBOutlet UITextView *jobsSkillsTextView;

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
@property (nonatomic, strong) CLLocation *jobLocation;
@property (nonatomic,strong) NSString *jobAddressLine;





@end
