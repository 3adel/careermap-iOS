//
//  AddJobDetailsViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/27/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "AddJobDetailsViewController.h"

@interface AddJobDetailsViewController ()

@end

@implementation AddJobDetailsViewController

//track how many times the user adds or deletes a buton
int addSkillButtonTapCountJobCreation = 0;


-(void) viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //    // Some outlets style setup.
    //    _CVjobSeekerFirstNameTextView.layer.cornerRadius=5.0f;
    //    _CVjobSeekerFirstNameTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    //    _CVjobSeekerFirstNameTextView.layer.borderWidth= .5f;
    
    //    _CVjobSeekerLastNameTextView.layer.cornerRadius=5.0f;
    //    _CVjobSeekerLastNameTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    //    _CVjobSeekerLastNameTextView.layer.borderWidth= .5f;
    
    _jobJobDescription.layer.cornerRadius =5.0f;
    _jobJobDescription.layer.borderWidth = .5f;
    _jobJobDescription.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _jobRolesAndResponsibilities.layer.cornerRadius =5.0f;
    _jobRolesAndResponsibilities.layer.borderWidth = .5f;
    _jobRolesAndResponsibilities.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    //    //detect when theview is tapped while the text is being edited
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    //    [self.view addGestureRecognizer:tapGesture];
    
    
    //
    //    //add gesture recognizer for the thumb image edit
    //    UITapGestureRecognizer *CVthumbTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CVthumbTapped)];
    //    [_CVjobSeekerThumb addGestureRecognizer:CVthumbTapGesture];
    //
    
    //setup skill view and addskillbutton
    [self setupSkillsView];
    [self setupAddSkillButton];
    
    _arrayOfSkillTextViews = [[NSMutableArray alloc] init];
    //Ultra light gray
    _jobJobDescription.placeholderColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    _jobJobDescription.placeholder = NSLocalizedString(@"* Job Description",nil);
    //Ultra light gray
    _jobRolesAndResponsibilities.placeholderColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    _jobRolesAndResponsibilities.placeholder = NSLocalizedString(@"Roles and Responsibilities",nil);
    
    //setup employment type picker
        _employmentTypeTextField.delegate =self;
        _employmentTypePicker = [[UIPickerView alloc] init];
        [_employmentTypeTextField setInputView:_employmentTypePicker];
        UIToolbar *employmentPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [employmentPickerToolbar setTintColor:[UIColor colorWithRed:13.0/255.0 green:153.0/255 blue:252.0/255.0 alpha:1]];
    
        UIBarButtonItem *empTypeDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectEmploymentType)];
        UIBarButtonItem *empTypespace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [employmentPickerToolbar setItems:[NSArray arrayWithObjects:empTypespace, empTypeDoneBtn, nil]];
        [_employmentTypeTextField setInputAccessoryView:employmentPickerToolbar];
        _employmentTypePicker.delegate =self;
        self.employmentTypeList = @[@"Full Time",@"Part Time", @"Contract",@"Internship",@"Temporary", @"Other"];
    
    
    //setup degree required picker
    _degreeRequiredTextField.delegate =self;
    _degreeRequiredPicker = [[UIPickerView alloc] init];
    [_degreeRequiredTextField setInputView:_degreeRequiredPicker];
    UIToolbar *degreeRequiredPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [degreeRequiredPickerToolbar setTintColor:[UIColor colorWithRed:13.0/255.0 green:153.0/255 blue:252.0/255.0 alpha:1]];
    
    UIBarButtonItem *degreeRequiredDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectDegreeRequiredType)];
    UIBarButtonItem *degreeRequiredspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [degreeRequiredPickerToolbar setItems:[NSArray arrayWithObjects:degreeRequiredspace, degreeRequiredDoneBtn, nil]];
    [_degreeRequiredTextField setInputAccessoryView:degreeRequiredPickerToolbar];
    _degreeRequiredPicker.delegate =self;
    self.degreeRequiredList = @[@"Primary School",@"High/Secondary School", @"Associate's Degree (Diploma)",@"Bachelor's Degree",@"Master's Degree",@"PhD", @"None"];

    //setup job level picker
    _jobLevelTextField.delegate =self;
    _jobLevelPicker = [[UIPickerView alloc] init];
    [_jobLevelTextField setInputView:_jobLevelPicker];
    UIToolbar *jobLevelPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [jobLevelPickerToolbar setTintColor:[UIColor colorWithRed:13.0/255.0 green:153.0/255 blue:252.0/255.0 alpha:1]];
    
    UIBarButtonItem *jobLevelDoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectJobLevel)];
    UIBarButtonItem *jobLevelSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [jobLevelPickerToolbar setItems:[NSArray arrayWithObjects:jobLevelSpace, jobLevelDoneBtn, nil]];
    [_jobLevelTextField setInputAccessoryView:jobLevelPickerToolbar];
    _jobLevelPicker.delegate =self;
    self.jobLevelList = @[@"Student/Intern",@"Entry level", @"Mid-level",@"Senior-level",@"Director", @"Executive", @"Other", @"None"];
    
    
    

    //populate existing fields
    [self addExistingSkillTextField];
    
}


- (void )setupSkillsView{
    _skillView = [[UIView alloc] init];
    _skillView.translatesAutoresizingMaskIntoConstraints =NO;
    [_skillsScrollView addSubview:_skillView];
    
    
    //skill view initial constraints
    NSLayoutConstraint *skillViewTopConstraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_skillsSectionLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    NSLayoutConstraint *skillViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *skillViewLeftContraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skillsSectionLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *skillViewRightContraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skillsSectionLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *skillViewBottomContraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_skillsScrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-300];
    _skillViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    //add constraints
    [self.view addConstraints:@[skillViewCenterXConstraint, skillViewTopConstraint, skillViewLeftContraint, skillViewRightContraint,_skillViewHeightConstraint,skillViewBottomContraint]];
    
}


//Reload existing skills
- (void) addExistingSkillTextField{
    //reset counter
    addSkillButtonTapCountJobCreation = 0;
    
    //setup skills fields and their buttons
    
    
    //this should be set by the previous VC. This init is temporary
    _existingSkills =[[NSMutableArray alloc] init];
    if ([_existingSkills count]>0) {
        
        
        for (NSString *skill in _existingSkills) {
            
            self.skillTextField = [[SkillTextField alloc] init];
            
            //setup the constraints for the skills textFields
            //self.skillTextField.backgroundColor = [UIColor yellowColor];
            self.skillTextField.translatesAutoresizingMaskIntoConstraints =NO;
            [self.skillTextField setTextColor:[UIColor blackColor]];
            [self.skillTextField setTag:addSkillButtonTapCountJobCreation];
            [self.skillTextField setText:skill];
            
            //skill text field style
            self.skillTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            self.skillTextField.layer.borderWidth= .5f;
            self.skillTextField.layer.cornerRadius=5.0f;
            UIView *skillTextViewLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
            self.skillTextField.leftView = skillTextViewLeftPaddingView;
            self.skillTextField.leftViewMode = UITextFieldViewModeAlways;
            [self.skillTextField setFont:[UIFont systemFontOfSize:18]];
            
            self.skillTextField.skillTextFieldTop= [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeTop multiplier:1.0 constant:50*(addSkillButtonTapCountJobCreation)];
            
            //store skill in in the skills array
            [_arrayOfSkillTextViews addObject:self.skillTextField];
            
            //add the text and its button to the view
            [_skillView addSubview:[_arrayOfSkillTextViews objectAtIndex:addSkillButtonTapCountJobCreation]];
            
            [self.view layoutIfNeeded];
            
            //skill text field constraints
            NSLayoutConstraint *skillTextFieldLeftConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            _skillTextFieldHeightConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
            
            NSLayoutConstraint *skillTextFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
            
            [self.view addConstraints:@[self.skillTextField.skillTextFieldTop,skillTextFieldLeftConstraint,skillTextFieldWidthConstraint,_skillTextFieldHeightConstraint]];
            [self.view layoutIfNeeded];
            
            
            if ([self.skillTextField.text isEqualToString:@""]) {
                [self. skillTextField setPlaceholder:[NSString stringWithFormat:@"Add skilluuu #%d",addSkillButtonTapCountJobCreation+1]];
            }

            //setup the remove skill button
            [self.view layoutIfNeeded];
            self.skillTextField.removeSkillButton = [[UIButton alloc] init];
            
            //remove skill button style
            self.skillTextField.removeSkillButton.backgroundColor = [UIColor redColor];
            [self.skillTextField.removeSkillButton.titleLabel setFont:[UIFont systemFontOfSize:15]];

            //remove skill button constraints and targets
            self.skillTextField.removeSkillButton.translatesAutoresizingMaskIntoConstraints =NO;
            [self.skillTextField.removeSkillButton setTag:addSkillButtonTapCountJobCreation];
            [_skillView addSubview:self.skillTextField.removeSkillButton];
            
            //first delete button title should be "clear" and connect to its own clear action
            if ([_existingSkills indexOfObject:skill] ==0) {
                
                [self.skillTextField.removeSkillButton setTitle:@"Clear" forState:UIControlStateNormal];
                [self.skillTextField.removeSkillButton addTarget:self action:@selector(clearSkillButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            } else{
                
                [self.skillTextField.removeSkillButton setTitle:@"Delete" forState:UIControlStateNormal];
                [self.skillTextField.removeSkillButton addTarget:self action:@selector(removeSkillButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }

            NSLayoutConstraint *removeSkillButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            NSLayoutConstraint *removeSkillButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            NSLayoutConstraint *removeSkillButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
            NSLayoutConstraint *removeSkillButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
            
            [self.view addConstraints:@[removeSkillButtonBottomConstraint,removeSkillButtonTopConstraint,removeSkillButtonLeftConstraint,removeSkillButtonRightConstraint]];
            [self.view layoutIfNeeded];
            
            _skillViewHeightConstraint.constant = 50*(addSkillButtonTapCountJobCreation+1);
            
            
            addSkillButtonTapCountJobCreation++;
            
            
            
        }
        
    }
    
    else
        
    {
        //add one empty skill field instead if there are no previous skills
        
        self.skillTextField = [[SkillTextField alloc] init];
        
        //setup the constraints for the skills textFields
        //self.skillTextField.backgroundColor = [UIColor yellowColor];
        self.skillTextField.translatesAutoresizingMaskIntoConstraints =NO;
        [self.skillTextField setTextColor:[UIColor blackColor]];
        [self.skillTextField setTag:addSkillButtonTapCountJobCreation];
        
        
        [self.skillTextField setText:@""];
        [self. skillTextField setPlaceholder:@"Add skill #1"];
        
        //skill text field style
        self.skillTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        self.skillTextField.layer.borderWidth= .5f;
        self.skillTextField.layer.cornerRadius=5.0f;
        UIView *skillTextViewLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
        self.skillTextField.leftView = skillTextViewLeftPaddingView;
        self.skillTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.skillTextField setFont:[UIFont systemFontOfSize:18]];
        
        
        
        self.skillTextField.skillTextFieldTop= [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeTop multiplier:1.0 constant:50*(0)];
        
        //store skill in in the skills array
        [_arrayOfSkillTextViews addObject:self.skillTextField];
        
        //add the text and its button to the view
        [_skillView addSubview:[_arrayOfSkillTextViews objectAtIndex:0]];
        
        [self.view layoutIfNeeded];
        
        //skill text field constraints
        NSLayoutConstraint *skillTextFieldLeftConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        _skillTextFieldHeightConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
        
        NSLayoutConstraint *skillTextFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        
        [self.view addConstraints:@[self.skillTextField.skillTextFieldTop,skillTextFieldLeftConstraint,skillTextFieldWidthConstraint,_skillTextFieldHeightConstraint]];
        [self.view layoutIfNeeded];
        
        
        
        //setup the remove skill button
        [self.view layoutIfNeeded];
        self.skillTextField.removeSkillButton = [[UIButton alloc] init];
        
        //remove skill button style
        self.skillTextField.removeSkillButton.backgroundColor = [UIColor redColor];
        [self.skillTextField.removeSkillButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        
        
        
        
        //remove skill button constraints and targets
        self.skillTextField.removeSkillButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self.skillTextField.removeSkillButton setTag:0];
        [_skillView addSubview:self.skillTextField.removeSkillButton];
        
        //first delete button title should be "clear" and connect to its own clear action
        
        [self.skillTextField.removeSkillButton setTitle:@"Clear" forState:UIControlStateNormal];
        [self.skillTextField.removeSkillButton addTarget:self action:@selector(clearSkillButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        NSLayoutConstraint *removeSkillButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *removeSkillButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *removeSkillButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
        NSLayoutConstraint *removeSkillButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        [self.view addConstraints:@[removeSkillButtonBottomConstraint,removeSkillButtonTopConstraint,removeSkillButtonLeftConstraint,removeSkillButtonRightConstraint]];
        [self.view layoutIfNeeded];
        
        _skillViewHeightConstraint.constant = 50*(0+1);
        addSkillButtonTapCountJobCreation++;

        
    }
  
}


//setup add skill button
- (void) setupAddSkillButton{
    _addSkillButton = [[UIButton alloc] init];
    _addSkillButton.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:153.0/255 blue:252.0/255.0 alpha:1];
    [_addSkillButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addSkillButton.translatesAutoresizingMaskIntoConstraints =NO;
    [_addSkillButton setTitle:@"+ Add another skill" forState:UIControlStateNormal];
    [_skillsScrollView addSubview:_addSkillButton];
    
    //add skill button initial constraints
    NSLayoutConstraint *AddSkillButtonTopConstraint = [NSLayoutConstraint constraintWithItem:_addSkillButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    NSLayoutConstraint *AddSkillButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:_addSkillButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *AddSkillButtonRightConstraint = [NSLayoutConstraint constraintWithItem:_addSkillButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    //height of add skill button
    NSLayoutConstraint *AddSkillButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:_addSkillButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:45];
    [self.view addConstraints:@[AddSkillButtonTopConstraint,AddSkillButtonLeftConstraint , AddSkillButtonRightConstraint,AddSkillButtonHeightConstraint]];
    [_addSkillButton addTarget:self action:@selector(addSkillButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}




//user adds a skill

- (void)addSkillButtonPressed{
    [self addSkillTextField:addSkillButtonTapCountJobCreation];
    
}



//add a textField to the skill view based on the value of the add/delete skill tally
- (void) addSkillTextField: (int) withAddDeleteSkillTally{

    self.skillTextField = [[SkillTextField alloc] init];
    //setup the constraints for the skills textFields
    self.skillTextField.backgroundColor = [UIColor whiteColor];
    self.skillTextField.translatesAutoresizingMaskIntoConstraints =NO;
    [self.skillTextField setTextColor:[UIColor blackColor]];
    [self.skillTextField setTag:withAddDeleteSkillTally];
    [self.skillTextField setPlaceholder:[NSString stringWithFormat:@"Add skill #%ld",self.skillTextField.tag+1]];
    
    //skill text field style
    self.skillTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.skillTextField.layer.borderWidth= .5f;
    self.skillTextField.layer.cornerRadius=5.0f;
    UIView *skillTextViewLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.skillTextField.leftView = skillTextViewLeftPaddingView;
    self.skillTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.skillTextField setFont:[UIFont systemFontOfSize:18]];
    self.skillTextField.skillTextFieldTop= [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeTop multiplier:1.0 constant:50*(withAddDeleteSkillTally)];
    
    //store skill in in the skills array
    [_arrayOfSkillTextViews addObject:self.skillTextField];
    
    //add the text and its button to the view
    [_skillView addSubview:[_arrayOfSkillTextViews objectAtIndex:addSkillButtonTapCountJobCreation]];
    
    [self.view layoutIfNeeded];
    
    //skill text field constraints
    NSLayoutConstraint *skillTextFieldLeftConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    _skillTextFieldHeightConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    
    NSLayoutConstraint *skillTextFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
    
    [self.view addConstraints:@[self.skillTextField.skillTextFieldTop,skillTextFieldLeftConstraint,skillTextFieldWidthConstraint,_skillTextFieldHeightConstraint]];
    [self.view layoutIfNeeded];
    
    
    
    //setup the remove skill button
    
    [self.view layoutIfNeeded];
    self.skillTextField.removeSkillButton = [[UIButton alloc] init];
    
    //remove skill button style
    self.skillTextField.removeSkillButton.backgroundColor = [UIColor redColor];
    [self.skillTextField.removeSkillButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.skillTextField.removeSkillButton setTitle:@"Delete" forState:UIControlStateNormal];
    
    //remove skill button constraints
    self.skillTextField.removeSkillButton.translatesAutoresizingMaskIntoConstraints =NO;
    [self.skillTextField.removeSkillButton setTag:withAddDeleteSkillTally];
    [_skillView addSubview:self.skillTextField.removeSkillButton];
    [self.skillTextField.removeSkillButton addTarget:self action:@selector(removeSkillButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    NSLayoutConstraint *removeSkillButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *removeSkillButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *removeSkillButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.skillTextField attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    NSLayoutConstraint *removeSkillButtonRightConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField.removeSkillButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[removeSkillButtonBottomConstraint,removeSkillButtonTopConstraint,removeSkillButtonLeftConstraint,removeSkillButtonRightConstraint]];
    [self.view layoutIfNeeded];
    
    _skillViewHeightConstraint.constant = 50*(addSkillButtonTapCountJobCreation+1);
    
    
    
    addSkillButtonTapCountJobCreation++;
    
}

//will be called only for the first skill
- (void) clearSkillButtonPressed:(UIButton *)sender{
    
    
    [(UITextField *)[_arrayOfSkillTextViews objectAtIndex:sender.tag] setText:@""];
    [(UITextField *)[_arrayOfSkillTextViews objectAtIndex:sender.tag] setPlaceholder:[NSString stringWithFormat:@"Add skill #%ld", sender.tag+1]];
    
}

- (void) removeSkillButtonPressed: (UIButton *)sender
{
    
    //shrink skills_view
    _skillViewHeightConstraint.constant = 50*(addSkillButtonTapCountJobCreation-1);
    
    addSkillButtonTapCountJobCreation--;
    // NSLog(@"Remove skill countTally= %d and Tag= %ld", addSkillButtonTapCountJobCreation, sender.tag);
    //remove the button and text field with corresponding tag
    [sender removeFromSuperview];
    [(SkillTextField *)[_arrayOfSkillTextViews objectAtIndex:sender.tag] removeFromSuperview];
    
    
    
    
    [sender setBackgroundColor:[UIColor orangeColor]];
    
    
    NSInteger removalCounter = addSkillButtonTapCountJobCreation -sender.tag;
    // NSLog(@"Remove Items Count = %ld", removalCounter);
    
    
    
    //adjust the remaining texfield and buttons and shift them up
    for (NSInteger i = 1; i<=removalCounter; i++) {
        // [ (SkillTextField *)[_arrayOfSkillTextViews objectAtIndex:sender.tag+i]  setBackgroundColor:[UIColor greenColor]];
        [[(SkillTextField *)[_arrayOfSkillTextViews objectAtIndex:(sender.tag+i)] skillTextFieldTop] setConstant:(50*(sender.tag+i-1))];
        
        
    }
    
    
    
    //now remove deleted row from the data array
    [_arrayOfSkillTextViews removeObjectAtIndex:sender.tag];
    
    
    //then refresh the entire array index
    NSUInteger indexCounter=0;
    for (SkillTextField *textField in _arrayOfSkillTextViews) {
        
        
        
        [textField setTag:indexCounter];
        [textField.removeSkillButton setTag:indexCounter];
        NSLog(@"Index Counter = %ld", (unsigned long)indexCounter);
        
        //  [self.skillTextField setPlaceholder:[NSString stringWithFormat:@"Add skill #%ld",self.skillTextField.tag+2]];
        
        if ([textField.text isEqual:@""]) {
            // [textField setText:[NSString stringWithFormat:@"Tag: %ld",indexCounter-2]];
            [textField setPlaceholder:[NSString stringWithFormat:@"Add skill #%lu",indexCounter+1]];
            
        }
        
        
        //[textField setText:[NSString stringWithFormat:@"Tag: %ld",indexCounter]];
        indexCounter ++;
        //update the tag of text fields
        
    }
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender {
//
//    //reinitialize add skill count
//    addSkillButtonTapCountJobCreation = 0;
//
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)saveJobButtonPressed:(UIBarButtonItem *)sender {
    
    
    
    
    //    [self.view endEditing:YES];
    //
    //    [self checkFieldsComplete];
    
    
    
    
    [self saveCVToParse];
    
}


//- (void) checkFieldsComplete{
//
//    //validate mandatory fields only
//    if ([_CVjobSeekerFirstNameTextView.text isEqualToString:@""] || [_CVjobSeekerLastNameTextView.text isEqualToString:@""]) {
//        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:@"You need to complete all madnatory fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//
//        [alert show];
//    }
//
//
//    else{
//
//
//        NSLog(@"Save cv to backend");
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveCVButtonPressed" object:nil];
//        [self saveCVToParse];
//
//    }
//
//
//
//}


//dismiss keyboard when view is tapped
//-(void) viewTapped{
//
//    //dismiss keyboard from all text entry fields
//    [self.view endEditing:YES];
//
//
//}

//this should resolve the add


- (void) saveCVToParse{
    
    if ([_jobObject objectId]) {
        NSLog(@"object has object id");
        //update the job object

    }else{
        
        NSLog(@"object has no object id");
        //create and save job object to parse
        
        NSLog(@"Array of text views %@",[_arrayOfSkillTextViews objectAtIndex:0]);
        //
        
        
        //save skills to parse
        NSMutableArray *existingSkillsArray = [[NSMutableArray alloc] init];
        for (UITextField *skillTextField in _arrayOfSkillTextViews) {
            //prevent empty skills
            if (![skillTextField.text isEqualToString:@""]) {
                [existingSkillsArray addObject:skillTextField.text];
                
            }
            
            
        }
        _jobObject[@"postedByUser"] = [PFUser currentUser];
        _jobObject[@"reportCount"] = [NSNumber numberWithInteger:0];
        _jobObject[@"skillsRequired"] = existingSkillsArray;
        _jobObject[@"title"] = _jobJobTitle.text;
        _jobObject[@"businessName"] = _jobBusinessName.text;
        _jobObject[@"description"] = _jobJobDescription.text;
        _jobObject[@"rolesAndResponsibilities"] = _jobRolesAndResponsibilities.text;
        _jobObject[@"compensation"] = _jobCompensation.text;
        _jobObject[@"employmentType"] = _employmentTypeTextField.text;
        _jobObject[@"degreeRequired"] = _degreeRequiredTextField.text;
        _jobObject[@"jobLevel"] = _jobLevelTextField.text;

        
        
        [_jobObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"saved skills to parse successfully");
                
                
            }
            
            else{
                
                NSLog(@"error saving skills successfully to parse");
            }
        }];
        
        
        
        // NSLog(@"%@", [_jobObject objectForKey:@"jobIndustry"]);
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}



//- (void)CVthumbTapped{
//
//
//    NSLog(@"cv thumb tapped");
//
//
//    //present photo source action sheet
//    _photoSourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select photo from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
//                               @"Camera",
//                               @"Library",
//                               nil];
//
//    _photoSourceActionSheet.tag = 1;
//    [_photoSourceActionSheet showInView:[UIApplication sharedApplication].keyWindow];
//
//
//
//
//    /*
//     //instantiate the cv thumb editor
//     CVThumbEditViewController *CVThumbEditView = [[CVThumbEditViewController alloc] initWithNibName:@"CVThumbEditView" bundle:nil];
//     [self presentViewController:CVThumbEditView animated:YES completion:nil];*/
//
//}








//- (void)actionSheet:(UIActionSheet *)_photSourceoActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    //handle multiple action sheet if necesssary
//    switch (_photoSourceActionSheet.tag) {
//        case 1: {
//            switch (buttonIndex) {
//                case 0:{
//                    NSLog(@"Take photo from camera");
//                    //get photo from camera
//                    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
//                    cameraPicker.delegate = self;
//                    cameraPicker.allowsEditing = YES;
//                    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                    [self presentViewController:cameraPicker animated:YES completion:NULL];
//                }
//                    break;
//                case 1:{
//                    NSLog(@"Take photo from photo library");
//                    //get photo from camera
//                    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
//                    cameraPicker.delegate = self;
//                    cameraPicker.allowsEditing = YES;
//                    cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    [self presentViewController:cameraPicker animated:YES completion:NULL];
//                }
//
//                    break;
//                default:
//                    break;
//            }
//            break;
//        }
//        default:
//            break;
//    }
//}

////update the thumb image view with picked image
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.CVjobSeekerThumb.image = chosenImage;
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//
//}

-(void) selectEmploymentType{

    NSLog(@"Select cv degrees");

    // _employmentTypeTextField.text = @"Sample degree";
    _employmentTypeTextField.text = [self.employmentTypeList objectAtIndex:[self.employmentTypePicker selectedRowInComponent:0]];

    [_employmentTypeTextField resignFirstResponder];
}

-(void) selectDegreeRequiredType{
    
    NSLog(@"Select degree required");
    
    _degreeRequiredTextField.text = [self.degreeRequiredList objectAtIndex:[self.degreeRequiredPicker selectedRowInComponent:0]];
    
    [_degreeRequiredTextField resignFirstResponder];
}

-(void) selectJobLevel{
    
    NSLog(@"Select job level required");
    
    _jobLevelTextField.text = [self.jobLevelList objectAtIndex:[self.jobLevelPicker selectedRowInComponent:0]];
    
    [_jobLevelTextField resignFirstResponder];
}

//- (IBAction)yearsOfExperienceStepperChange:(JLTStepper *)sender {
//
//
//    //
//    if (([_yearsOfExperienceLabel.text intValue] >0) && ([_yearsOfExperienceLabel.text intValue] <=100)) {
//
//        if (sender.plusMinusState == JLTStepperPlus) {
//            // Plus button pressed
//            _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]+1];
//        }
//        else if (sender.plusMinusState == JLTStepperMinus) {
//            // Minus button pressed
//            _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]-1];
//        } else {
//            // Shouldn't happen unless value is set programmatically.
//
//
//        }
//
//
//    }
//
//    //This will guarantee the counter doesn't go beyond maximum or minimum.
//    else{
//
//        if (sender.plusMinusState == JLTStepperPlus) {
//            // Plus button pressed
//            _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]+1];
//        }
//
//        else{
//
//            if ([_yearsOfExperienceLabel.text intValue] >=100){
//                _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]-1];
//            }
//        }
//
//
//
//    }
//
//
//}

- (IBAction)clearFirstSkillButtonPressed:(UIButton *)sender {
    _firstAddSkillTextView.text = @""
    ;
}


//CV degree picker and textfield delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ([pickerView isEqual:_employmentTypePicker]) {
        return [_employmentTypeList objectAtIndex:row];

    }
    
    else if ([pickerView isEqual:_degreeRequiredPicker]){
        return [_degreeRequiredList objectAtIndex:row];
    }
    
    else if ([pickerView isEqual:_jobLevelPicker]){
        return [_jobLevelList objectAtIndex:row];
    }
    
    
    
    return @"";
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    if ([pickerView isEqual:_employmentTypePicker]) {
        return [_employmentTypeList count];
        
    }
    
    else if ([pickerView isEqual:_degreeRequiredPicker]){
        
        return [_degreeRequiredList count];

    }
    else if ([pickerView isEqual:_jobLevelPicker]){
        
        return [_jobLevelList count];
        
    }
    
    return 0;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{

    //refactor: needs to include all picker views

    
    
    if ([textField isEqual:_employmentTypeTextField]) {
        NSString *selectedEmploymentType = _employmentTypeTextField.text;
        
        for (NSString *empTypeString in _employmentTypeList) {
            if ([empTypeString  isEqualToString:selectedEmploymentType]) {
                _employmentTypeTextField.text =empTypeString;
                [_employmentTypeTextField setTextColor:[UIColor blackColor]];
                break;
                ;
            }
            
            else{
                _employmentTypeTextField.text =@"Please select a valid employment type";
                [_employmentTypeTextField setTextColor:[UIColor redColor]];
                
                
            }
        }
    }
    
    else if ([textField isEqual:_degreeRequiredTextField]){
        NSString *selectedDegree = _degreeRequiredTextField.text;
        
        for (NSString *degreeString in _degreeRequiredList) {
            if ([degreeString  isEqualToString:selectedDegree]) {
                _degreeRequiredTextField.text =degreeString;
                [_degreeRequiredTextField setTextColor:[UIColor blackColor]];
                break;
                ;
            }
            
            else{
                _degreeRequiredTextField.text =@"Please select a valid degree";
                [_degreeRequiredTextField setTextColor:[UIColor redColor]];
                
                
            }
        }
        
        
    }
    
    else if ([textField isEqual:_jobLevelTextField]){
        NSString *selectedJobLevel = _jobLevelTextField.text;
        
        for (NSString *jobLevelString in _jobLevelList) {
            if ([jobLevelString  isEqualToString:selectedJobLevel]) {
                _jobLevelTextField.text =jobLevelString;
                [_jobLevelTextField setTextColor:[UIColor blackColor]];
                break;
                ;
            }
            
            else{
                _jobLevelTextField.text =@"Please select a valid job level";
                [_jobLevelTextField setTextColor:[UIColor redColor]];
                
                
            }
        }
        
        
    }

    
    



}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
