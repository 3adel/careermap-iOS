//
//  SkillTextField.m
//  AddingViewsDynamically
//
//  Created by Adel  Shehadeh on 4/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "SkillTextField.h"

@implementation SkillTextField

@synthesize skillTextFieldTop;
@synthesize removeSkillButton;
//@synthesize skillTextFieldBottom;

- (void)drawRect:(CGRect)rect {
    removeSkillButton.layer.cornerRadius = 5.0f;

}


@end
