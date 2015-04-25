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
@interface CreateCVViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


//Outlets

@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (nonatomic, strong) UIView *skillView;
@property (strong, nonatomic) IBOutlet UIButton *addSkillButton;


@property (weak, nonatomic) IBOutlet UIImageView *CVjobSeekerThumb;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerFirstNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerLastNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerCurrentTitleTextView;
@property (strong, nonatomic) UIActionSheet *photoSourceActionSheet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillViewHeightConstraint;

//@property (strong, nonatomic) NSLayoutConstraint *skillViewHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *skillTextFieldHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *skillTextFieldTopConstraint;
@property (strong, nonatomic) SkillTextField *skillTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstAddSkillTextView;
@property (weak, nonatomic) IBOutlet UIButton *firstRemoveSkillButton;



//methods
- (void )setupSkillsView;
- (void) setupAddSkillButton;

- (IBAction)addSkillButtonPressed:(UIButton *)sender;
- (void) addSkillTextField: (int) withAddDeleteSkillTally;
- (void) removeSkillButtonPressed: (UIButton *)sender;
- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveCVButtonPressed:(UIBarButtonItem *)sender;
- (void) checkFieldsComplete;
- (void) CVthumbTapped;


//data
@property (nonatomic, strong) NSMutableArray *arrayOfSkillTextViews;
















@end
