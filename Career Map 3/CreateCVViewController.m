//
//  CreateCVViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/19/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//



#import "CreateCVViewController.h"
#import "AppHorizontalMessage.h"

@interface CreateCVViewController ()

@end

@implementation CreateCVViewController


//track how many times the user adds or deletes a buton
int addSkillButtonTapCount = 0;


-(void) viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    


    
    // Some outlets style setup.
    _CVjobSeekerFirstNameTextView.layer.cornerRadius=5.0f;
    _CVjobSeekerFirstNameTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _CVjobSeekerFirstNameTextView.layer.borderWidth= .5f;
    
    _CVjobSeekerLastNameTextView.layer.cornerRadius=5.0f;
    _CVjobSeekerLastNameTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _CVjobSeekerLastNameTextView.layer.borderWidth= .5f;
    
    _CVAboutMeTextView.layer.cornerRadius =5.0f;
    _CVAboutMeTextView.layer.borderWidth = .5f;
    _CVAboutMeTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    //detect when theview is tapped while the text is being edited
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
    //add gesture recognizer for the thumb image edit
    UITapGestureRecognizer *CVthumbTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CVthumbTapped)];
    [_CVjobSeekerThumb addGestureRecognizer:CVthumbTapGesture];
    
    
    //setup skill view and addskillbutton
    [self setupSkillsView];
    [self setupAddSkillButton];
    
    _arrayOfSkillTextViews = [[NSMutableArray alloc] init];
    
    _CVAboutMeTextView.placeholderColor = [UIColor lightGrayColor];
    _CVAboutMeTextView.placeholder = NSLocalizedString(@"Tell us about yourself and what you like to accomplish",);
    
    
    //setup cv education degree picker
    _CVDegreeTextField.delegate =self;
    _CVDegreePicker = [[UIPickerView alloc] init];
    [_CVDegreeTextField setInputView:_CVDegreePicker];
    UIToolbar *CVPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [CVPickerToolbar setTintColor:[UIColor colorWithRed:13.0/255.0 green:153.0/255 blue:252.0/255.0 alpha:1]];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectCVDegree)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [CVPickerToolbar setItems:[NSArray arrayWithObjects:space, doneBtn, nil]];
    [_CVDegreeTextField setInputAccessoryView:CVPickerToolbar];
    _CVDegreePicker.delegate =self;
    self.educationDegreesList = @[@"Primary School",@"High/Secondary School", @"Diploma",@"Bachelor's Degree",@"Master's Degree",@"PhD", @"None"];
    
    
    
    
    
    //populate existing fields
    [self addExistingSkillTextField];

}


- (void )setupSkillsView{
    
    
    _skillView = [[UIView alloc] init];
    //_skillView.backgroundColor = [UIColor orangeColor];
    _skillView.translatesAutoresizingMaskIntoConstraints =NO;
    [_skillsScrollView addSubview:_skillView];
    
    
    //skill view initial constraints
    NSLayoutConstraint *skillViewTopConstraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_skillsSectionLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10];
    NSLayoutConstraint *skillViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *skillViewLeftContraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skillsSectionLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *skillViewRightContraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_CVDegreeTextField attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
     NSLayoutConstraint *skillViewBottomContraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_skillsScrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-300];
    
    _skillViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_skillView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    //add constraints
    [self.view addConstraints:@[skillViewCenterXConstraint, skillViewTopConstraint, skillViewLeftContraint, skillViewRightContraint,_skillViewHeightConstraint,skillViewBottomContraint]];
    
}


//Reload existing skills
- (void) addExistingSkillTextField{
   //reset counter
    addSkillButtonTapCount = 0;
    
    //setup skills fields and their buttons
    
    
    if ([_existingSkills count]>0) {
        
        
        for (NSString *skill in _existingSkills) {
            
            self.skillTextField = [[SkillTextField alloc] init];
            
            //setup the constraints for the skills textFields
            //self.skillTextField.backgroundColor = [UIColor yellowColor];
            self.skillTextField.translatesAutoresizingMaskIntoConstraints =NO;
            [self.skillTextField setTextColor:[UIColor blackColor]];
            [self.skillTextField setTag:addSkillButtonTapCount];
            
            

            

            
            
            [self.skillTextField setText:skill];
            
            //skill text field style
            self.skillTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            self.skillTextField.layer.borderWidth= .5f;
            self.skillTextField.layer.cornerRadius=5.0f;
            UIView *skillTextViewLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
            self.skillTextField.leftView = skillTextViewLeftPaddingView;
            self.skillTextField.leftViewMode = UITextFieldViewModeAlways;
            [self.skillTextField setFont:[UIFont systemFontOfSize:18]];
            
            
            
            self.skillTextField.skillTextFieldTop= [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeTop multiplier:1.0 constant:50*(addSkillButtonTapCount)];
            
            //store skill in in the skills array
            [_arrayOfSkillTextViews addObject:self.skillTextField];
            
            //add the text and its button to the view
            [_skillView addSubview:[_arrayOfSkillTextViews objectAtIndex:addSkillButtonTapCount]];
            
            [self.view layoutIfNeeded];
            
            //skill text field constraints
            NSLayoutConstraint *skillTextFieldLeftConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skillView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            _skillTextFieldHeightConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
            
            NSLayoutConstraint *skillTextFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:self.skillTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
            
            [self.view addConstraints:@[self.skillTextField.skillTextFieldTop,skillTextFieldLeftConstraint,skillTextFieldWidthConstraint,_skillTextFieldHeightConstraint]];
            [self.view layoutIfNeeded];
            
            
            if ([self.skillTextField.text isEqualToString:@""]) {
                [self. skillTextField setPlaceholder:[NSString stringWithFormat:@"Add skilluuu #%d",addSkillButtonTapCount+1]];
            }
            

            
            
            
            //setup the remove skill button
            [self.view layoutIfNeeded];
            self.skillTextField.removeSkillButton = [[UIButton alloc] init];
            
            //remove skill button style
            self.skillTextField.removeSkillButton.backgroundColor = [UIColor redColor];
            [self.skillTextField.removeSkillButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            

            

            
            //remove skill button constraints and targets
            self.skillTextField.removeSkillButton.translatesAutoresizingMaskIntoConstraints =NO;
            [self.skillTextField.removeSkillButton setTag:addSkillButtonTapCount];
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
            
            _skillViewHeightConstraint.constant = 50*(addSkillButtonTapCount+1);
            
            
            addSkillButtonTapCount++;
            
            
            
        }
        
    } else
    
    {
        //add one empty skill field instead if there are no previous skills

        self.skillTextField = [[SkillTextField alloc] init];
        
        //setup the constraints for the skills textFields
        //self.skillTextField.backgroundColor = [UIColor yellowColor];
        self.skillTextField.translatesAutoresizingMaskIntoConstraints =NO;
        [self.skillTextField setTextColor:[UIColor blackColor]];
        [self.skillTextField setTag:addSkillButtonTapCount];
        

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
        addSkillButtonTapCount++;

        
     
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
    NSLayoutConstraint *AddSkillButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:_addSkillButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [self.view addConstraints:@[AddSkillButtonTopConstraint,AddSkillButtonLeftConstraint , AddSkillButtonRightConstraint,AddSkillButtonHeightConstraint]];
    [_addSkillButton addTarget:self action:@selector(addSkillButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}




//user adds a skill

- (void)addSkillButtonPressed{
    [self addSkillTextField:addSkillButtonTapCount];

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
    [_skillView addSubview:[_arrayOfSkillTextViews objectAtIndex:addSkillButtonTapCount]];
    
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
    
    _skillViewHeightConstraint.constant = 50*(addSkillButtonTapCount+1);


    
    addSkillButtonTapCount++;
    
}

//will be called only for the first skill
- (void) clearSkillButtonPressed:(UIButton *)sender{
    
    
    [(UITextField *)[_arrayOfSkillTextViews objectAtIndex:sender.tag] setText:@""];
    [(UITextField *)[_arrayOfSkillTextViews objectAtIndex:sender.tag] setPlaceholder:[NSString stringWithFormat:@"Add skill #%ld", sender.tag+1]];
    
}

- (void) removeSkillButtonPressed: (UIButton *)sender
{
    
    //shrink skills_view
    _skillViewHeightConstraint.constant = 50*(addSkillButtonTapCount-1);
    
    addSkillButtonTapCount--;
    // NSLog(@"Remove skill countTally= %d and Tag= %ld", addSkillButtonTapCount, sender.tag);
    //remove the button and text field with corresponding tag
    [sender removeFromSuperview];
    [(SkillTextField *)[_arrayOfSkillTextViews objectAtIndex:sender.tag] removeFromSuperview];
    
    
    
    
    [sender setBackgroundColor:[UIColor orangeColor]];
    
    
    NSInteger removalCounter = addSkillButtonTapCount -sender.tag;
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

- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender {
    
    //reinitialize add skill count
    addSkillButtonTapCount = 0;

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveCVButtonPressed:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"saveCVButtonPressed" object:nil];
    [self.view endEditing:YES];
    [self checkFieldsComplete];
    
}


- (void) checkFieldsComplete{
    
    //validate mandatory fields only
    if ([_CVjobSeekerFirstNameTextView.text isEqualToString:@""] || [_CVjobSeekerLastNameTextView.text isEqualToString:@""]) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:@"You need to complete all madnatory fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
    else{
        
        
        NSLog(@"Save cv to backend");
        [self saveCVToParse];
        
    }
    
    
    
}


//dismiss keyboard when view is tapped
-(void) viewTapped{
    
    //dismiss keyboard from all text entry fields
    [self.view endEditing:YES];
    
    
}

//this should resolve the add


- (void) saveCVToParse{
    
    //dismiss the save view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    //start animating activity indicator while saving
    UIActivityIndicatorView *saveCVActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //[saveCVActivityIndicator setColor:[UIColor colorWithRed:13.0/255.0 green:153.0/255 blue:252.0/255.0 alpha:1]];
    

    
    saveCVActivityIndicator.center = self.view.center;
    [self.view addSubview:saveCVActivityIndicator];
    [saveCVActivityIndicator startAnimating];
    
    // Code to get data from database
    
    
    
    
    // if the user have a cv, it should be an update and not create
    
    //If the user don't have a CV, take them to the CV creation flow.
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query includeKey:@"aJobSeekerID"];
    [query getObjectInBackgroundWithId: [[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        if (!error) {
            
            if ([object objectForKey:@"aJobSeekerID"]) {
                //user does have CV
                NSLog(@"job seeker ID found = %@", [[object objectForKey:@"aJobSeekerID"] objectId]);
                
                
                //now update the cv in the jobSeeker table
                 //get the record in jobSeekerID
                 ///update the record
                
                PFQuery *jobSeekerQuery = [PFQuery queryWithClassName:@"jobSeeker"];
                
                // Retrieve the object by id
                [jobSeekerQuery getObjectInBackgroundWithId:[[object objectForKey:@"aJobSeekerID"] objectId] block:^(PFObject *jobSeekerObject, NSError *error) {
                    
                    // Now let's update it with some new data. In this case, only cheatMode and score
                    // will get sent to the cloud. playerName hasn't changed.
                    jobSeekerObject[@"firstName"] = _CVjobSeekerFirstNameTextView.text;
                    jobSeekerObject[@"lastName"] = _CVjobSeekerLastNameTextView.text;
                    jobSeekerObject[@"currentTitle"] =_CVjobSeekerCurrentTitleTextView.text;
                    jobSeekerObject[@"jobSeekerAbout"] =_CVAboutMeTextView.text;
                    jobSeekerObject[@"jobSeekerEducation"] =_CVEducationTextField.text;
                    jobSeekerObject[@"jobSeekerEducationDegree"] =_CVDegreeTextField.text;
                    jobSeekerObject[@"jobSeekerYearsOfExperience"] =[NSNumber numberWithInteger:[_yearsOfExperienceLabel.text intValue]] ;


                    
                    //save skills to parse
                    NSMutableArray *existingSkillsArray = [[NSMutableArray alloc] init];
                    
                    for (UITextField *skillTextField in _arrayOfSkillTextViews) {
                        //prevent empty skills
                        if (![skillTextField.text isEqualToString:@""]) {
                            [existingSkillsArray addObject:skillTextField.text];

                        }
                        
 
                    }
                    
                    jobSeekerObject [@"skills"] = existingSkillsArray;
                    
                    
                   // jobSeekerObject[@"skills"] =
                    
                    
                    
                   // NSData *imageData = UIImagePNGRepresentation(_CVjobSeekerThumb.image);
                    NSData *imageData = UIImageJPEGRepresentation(_CVjobSeekerThumb.image, 0.3f);
                    PFFile *imageFile = [PFFile fileWithName:@"CVThumbnail.png" data:imageData];
                    jobSeekerObject[@"jobSeekerThumb"] = imageFile;
                    
                    
                    
                    
                    
                    //**************
                    //jobSeekerObject[@"score"] = @1338;
                    [jobSeekerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            //[appMessage hideMessage];
                            NSLog(@"Success: CV edited");
                            
                            [saveCVActivityIndicator stopAnimating];
                            [saveCVActivityIndicator setHidesWhenStopped:YES];
                            
                            //notify the system that the edit is successful
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVEditedSuccessNotification" object:nil];

                            
                            
                            
                            
                            
                        } else{
                            
                            NSLog(@"Fail: CV edited: %@", error);
                        }
                    }];
                    
                }];
                
                
                
                
              //  NSLog(@"People who applied to this job = %@", [_jobObject objectForKey:@"appliedByUsers"]);
                
            
                
                
                
            }
            
            else{
                
                
                //create a new CV block
                //else, just add the cv
                //create an object for the cv
                //save the object in the jobSeeker table linking it to the current user
                
                PFObject *cvObject = [PFObject objectWithClassName:@"jobSeeker"];
                cvObject[@"firstName"] = _CVjobSeekerFirstNameTextView.text;
                cvObject[@"lastName"] = _CVjobSeekerLastNameTextView.text;
                cvObject[@"currentTitle"] = _CVjobSeekerCurrentTitleTextView.text;
                cvObject[@"jobSeekerAbout"] = _CVAboutMeTextView.text;
                cvObject[@"jobSeekerEducation"] = _CVEducationTextField.text;
                cvObject[@"jobSeekerEducationDegree"] = _CVDegreeTextField.text;
                cvObject[@"jobSeekerYearsOfExperience"] = [NSNumber numberWithInteger:[_yearsOfExperienceLabel.text intValue]] ;
                
                
                
                //save skills to parse
                NSMutableArray *existingSkillsArray = [[NSMutableArray alloc] init];
                
                for (UITextField *skillTextField in _arrayOfSkillTextViews) {
                    //prevent empty skills
                    if (![skillTextField.text isEqualToString:@""]) {
                        [existingSkillsArray addObject:skillTextField.text];
                        
                    }
                    
                    
                }
                
                cvObject [@"skills"] = existingSkillsArray;
                
                
                
                NSData *imageData = UIImageJPEGRepresentation(_CVjobSeekerThumb.image, 0.3f);//(_CVjobSeekerThumb.image);
                
               // UIImageJPEGRepresentation(image, 0.9f)
                PFFile *imageFile = [PFFile fileWithName:@"CVThumbnail.png" data:imageData];
                cvObject[@"jobSeekerThumb"] = imageFile;
                
     
                

                
                [cvObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"success saving new cv");
                       // [appMessage hideMessage];
                        
                        

                        
                        
                        //now update the user table accordingly
                        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                        [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *userObject, NSError *error) {
                            userObject[@"aJobSeekerID"] = cvObject;
                            [userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    NSLog(@"user table updated successfully with a new cv reference");
                                    //notify the system that the edit is successful
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CVEditedSuccessNotification" object:nil];
                                    

                                } else{
                                    
                                    NSLog(@"Error: user table update with cv reference: %@", error);
                                    
                                }
                            }];
                        }];
                        
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                    else{
                        
                        NSLog(@"error saving cv");
                    }
                }];
            }
            
            
        }
        
        else{
            
            NSLog(@"Error retrieving job seekerID: %@", error);
        }
    }];
    
    
    
    
    
    
    
    

    
    
    

    
    
    
    

    
    
}



- (void)CVthumbTapped{
    
    
    NSLog(@"cv thumb tapped");
    
    
    //present photo source action sheet
    _photoSourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select photo from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Library",
                            nil];
    
    _photoSourceActionSheet.tag = 1;
    [_photoSourceActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
 
    
    
    /*
    //instantiate the cv thumb editor
    CVThumbEditViewController *CVThumbEditView = [[CVThumbEditViewController alloc] initWithNibName:@"CVThumbEditView" bundle:nil];
    [self presentViewController:CVThumbEditView animated:YES completion:nil];*/
    
}








- (void)actionSheet:(UIActionSheet *)_photSourceoActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //handle multiple action sheet if necesssary
    switch (_photoSourceActionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:{
                    NSLog(@"Take photo from camera");
                    //get photo from camera
                    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                    cameraPicker.delegate = self;
                    cameraPicker.allowsEditing = YES;
                    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:cameraPicker animated:YES completion:NULL];
                }
                    break;
                case 1:{
                    NSLog(@"Take photo from photo library");
                    //get photo from camera
                    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                    cameraPicker.delegate = self;
                    cameraPicker.allowsEditing = YES;
                    cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:cameraPicker animated:YES completion:NULL];
                }
            
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

//update the thumb image view with picked image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.CVjobSeekerThumb.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) selectCVDegree{
    
    NSLog(@"Select cv degrees");
    
   // _CVDegreeTextField.text = @"Sample degree";
   _CVDegreeTextField.text = [self.educationDegreesList objectAtIndex:[self.CVDegreePicker selectedRowInComponent:0]];
    
    [_CVDegreeTextField resignFirstResponder];
}

- (IBAction)yearsOfExperienceStepperChange:(JLTStepper *)sender {
    

    //
    if (([_yearsOfExperienceLabel.text intValue] >0) && ([_yearsOfExperienceLabel.text intValue] <=100)) {
        
        if (sender.plusMinusState == JLTStepperPlus) {
            // Plus button pressed
            _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]+1];
        }
        else if (sender.plusMinusState == JLTStepperMinus) {
            // Minus button pressed
            _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]-1];
        } else {
            // Shouldn't happen unless value is set programmatically.
            

        }
        
        
    }
    
    //This will guarantee the counter doesn't go beyond maximum or minimum.
    else{
        
        if (sender.plusMinusState == JLTStepperPlus) {
            // Plus button pressed
            _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]+1];
        }
        
        else{
            
            if ([_yearsOfExperienceLabel.text intValue] >=100){
            _yearsOfExperienceLabel.text = [NSString stringWithFormat:@"%d",[_yearsOfExperienceLabel.text intValue]-1];
            }
        }
        
        
        
    }
    
    
}

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
    return [_educationDegreesList objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_educationDegreesList count];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   
    NSString *selectedCVDegree = _CVDegreeTextField.text;
    
    for (NSString *testString in _educationDegreesList) {
        if ([testString  isEqualToString:selectedCVDegree]) {
            _CVDegreeTextField.text =testString;
            [_CVDegreeTextField setTextColor:[UIColor blackColor]];
            break;
            ;
        }
        
        else{
            _CVDegreeTextField.text =@"Please select a valid degree";
            [_CVDegreeTextField setTextColor:[UIColor redColor]];
           
            
        }
    }
    

    

    
}


@end
