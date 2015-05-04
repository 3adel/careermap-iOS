//
//  CreateCVViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/19/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "SkillTextField.h"
#import "GCPlaceholderTextView.h"
#import "JLTStepper.h"


@interface CreateCVViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>


//Outlets

@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (nonatomic, strong) UIView *skillView;
@property (strong, nonatomic) IBOutlet UIButton *addSkillButton;
@property (weak, nonatomic) IBOutlet UIScrollView *skillsScrollView;


@property (weak, nonatomic) IBOutlet UIImageView *CVjobSeekerThumb;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerFirstNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerLastNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerCurrentTitleTextView;
@property (strong, nonatomic) UIActionSheet *photoSourceActionSheet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillViewHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *skillTextFieldHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *skillTextFieldTopConstraint;
@property (strong, nonatomic) SkillTextField *skillTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstAddSkillTextView;
@property (weak, nonatomic) IBOutlet UIButton *firstRemoveSkillButton;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *CVAboutMeTextView;

@property (weak, nonatomic) IBOutlet UITextField *CVEducationTextField;
@property (weak, nonatomic) IBOutlet UITextField *CVDegreeTextField;
@property (strong, nonatomic) UIPickerView *CVDegreePicker;
@property (weak, nonatomic) IBOutlet UILabel *yearsOfExperienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillsSectionLabel;
@property (weak, nonatomic) IBOutlet UITextField *CVSchoolTextField;


//methods
- (void )setupSkillsView;
- (void) setupAddSkillButton;

- (void) addSkillButtonPressed;
- (void) addSkillTextField: (int) withAddDeleteSkillTally;
- (void) removeSkillButtonPressed: (UIButton *) sender;
- (void) clearSkillButtonPressed: (UIButton *) sender;
- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveCVButtonPressed:(UIBarButtonItem *)sender;
- (void) checkFieldsComplete;
- (void) CVthumbTapped;
- (void) selectCVDegree;
- (IBAction)yearsOfExperienceStepperChange:(JLTStepper *)sender;
- (IBAction)clearFirstSkillButtonPressed:(UIButton *)sender;

//data
@property (nonatomic, strong) NSMutableArray *arrayOfSkillTextViews;
@property (nonatomic, strong) NSArray *educationDegreesList;
@property (nonatomic, strong) NSMutableArray *existingSkills;







@end
