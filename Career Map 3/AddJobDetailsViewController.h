//
//  AddJobDetailsViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/27/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddJobDetailsViewController : UIViewController



//MARK: Outlets
@property (weak, nonatomic) IBOutlet UIView *jobSkillsView;
@property (weak, nonatomic) IBOutlet UIScrollView *jobDetailsScrollView;

@property (weak, nonatomic) IBOutlet UITextField *firstAddSkillTextView;
@property (weak, nonatomic) IBOutlet UITextField *addSkillTextView;

@property (weak, nonatomic) IBOutlet UIButton *firstRemoveSkillButton;
@property (weak, nonatomic) IBOutlet UIButton *removeSkillButton;

@property (strong, nonatomic) IBOutlet UIButton *addSkillButton;



//MARK: UI constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobSkillsViewHeightConstraint;



//MARK: Data
@property (nonatomic, strong) PFObject *jobObject;
@property (nonatomic, strong) NSMutableArray *jobSkillsArray;


//MARK: Methods



@end
