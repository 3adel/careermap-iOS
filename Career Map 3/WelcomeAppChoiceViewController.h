//
//  WelcomeAppChoiceViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeAppChoiceViewController : UIViewController
- (IBAction)jobSeekerButtonPressed:(UIButton *)sender;
- (IBAction)employerButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *startNowButton;

@end
