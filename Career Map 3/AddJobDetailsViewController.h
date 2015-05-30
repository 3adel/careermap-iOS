//
//  AddJobDetailsViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/27/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "SkillTextField.h"
#import "GCPlaceholderTextView.h"
#import "JLTStepper.h"


@interface AddJobDetailsViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>


//Outlets

@property (nonatomic, strong) UIView *skillView;
@property (strong, nonatomic) IBOutlet UIButton *addSkillButton;
@property (weak, nonatomic) IBOutlet UIScrollView *skillsScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillViewHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *skillTextFieldHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *skillTextFieldTopConstraint;
@property (strong, nonatomic) SkillTextField *skillTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstAddSkillTextView;
@property (weak, nonatomic) IBOutlet UIButton *firstRemoveSkillButton;
@property (weak, nonatomic) IBOutlet UILabel *yearsOfExperienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillsSectionLabel;

@property (weak, nonatomic) IBOutlet UITextField *jobJobTitle;
@property (weak, nonatomic) IBOutlet UITextField *jobBusinessName;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *jobJobDescription;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *jobRolesAndResponsibilities;
@property (weak, nonatomic) IBOutlet UITextField *jobCompensation;

@property (weak, nonatomic) IBOutlet UITextField *employmentTypeTextField;
@property (strong, nonatomic) UIPickerView *employmentTypePicker;





//methods
- (void )setupSkillsView;
- (void) setupAddSkillButton;
- (void) addSkillButtonPressed;
- (void) addSkillTextField: (int) withAddDeleteSkillTally;
- (void) removeSkillButtonPressed: (UIButton *) sender;
- (void) clearSkillButtonPressed: (UIButton *) sender;
- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveJobButtonPressed:(UIBarButtonItem *)sender;
- (void) checkFieldsComplete;
- (void) CVthumbTapped;
- (void) selectEmploymentType;
//- (IBAction)yearsOfExperienceStepperChange:(JLTStepper *)sender;
- (IBAction)clearFirstSkillButtonPressed:(UIButton *)sender;

//data
@property (nonatomic, strong) NSMutableArray *arrayOfSkillTextViews;
@property (nonatomic, strong) NSArray *employmentTypeList;
@property (nonatomic, strong) NSMutableArray *existingSkills;
@property (nonatomic, strong) PFObject *jobObject;




@end
