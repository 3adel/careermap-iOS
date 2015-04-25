//
//  SkillTextField.h
//  AddingViewsDynamically
//
//  Created by Adel  Shehadeh on 4/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillTextField : UITextField

@property (nonatomic, weak) NSLayoutConstraint* skillTextFieldTop;
@property (nonatomic, weak) NSLayoutConstraint* skillTextFieldBottom;
@property (nonatomic, strong) UIButton *removeSkillButton;

@end
