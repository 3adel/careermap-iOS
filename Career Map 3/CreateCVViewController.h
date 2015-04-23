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
@interface CreateCVViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


//Outlets

@property (weak, nonatomic) IBOutlet UIImageView *CVjobSeekerThumb;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerFirstNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerLastNameTextView;
@property (weak, nonatomic) IBOutlet UITextField *CVjobSeekerCurrentTitleTextView;
@property (strong, nonatomic) UIActionSheet *photoSourceActionSheet;
@property (weak, nonatomic) IBOutlet UIView *jobSkillsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobSkillsViewHeightConstraint;

//Skill fields and remove skills buttons
@property (weak, nonatomic) IBOutlet UITextField *skillTextView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillTextField1HeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *removeSkillButton1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeSkillButton1HeightConstraint;




@property (weak, nonatomic) IBOutlet UITextField *skillTextView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillTextField2HeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *removeSkillButton2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeSkillButton2HeightConstraint;

//@property (strong,nonatomic) UITextField *skillTextField;
//@property (weak, nonatomic) IBOutlet nslayout


//Data
@property (strong, nonatomic) NSArray *jobSeekerSkills;




//actions
- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveCVButtonPressed:(UIBarButtonItem *)sender;
- (void) checkFieldsComplete;
- (void) CVthumbTapped;
- (IBAction)addSkillTestButton:(UIButton *)sender;
- (IBAction)assSkillButtonPressed:(UIButton *)sender;
- (void) removeSkillButtonPressed:(UIButton *)sender;
- (IBAction)addSkillViewTestingOnly:(UIButton *)sender;

@end
