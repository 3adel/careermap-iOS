//
//  JobDetailsViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobDetailsViewController.h"

@interface JobDetailsViewController ()

@end

@implementation JobDetailsViewController

@synthesize jobTitle;
//@synthesize jobTitleLabel;
@synthesize jobDescription;
@synthesize jobDescriptionLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //set the values of view controller
   // self.jobTitleLabel.text = self.jobTitle;
    self.jobDescriptionLabel.text=self.jobDescription;
    self.jobTitleTextView.text= self.jobTitle;
    self.jobAreaLabel.text = self.jobArea;
    self.jobDateAddedLabel.text = self.jobDateAdded;
    self.jobEmployerLabel.text = self.jobEmployer;
    self.jobVoteLabel.text =self.jobVote;
    self.jobDistanceFromUserLabel.text = self.jobDistanceFromUser;
    
  //  jobTitleLabel.lineBreakMode= NSLineBreakByWordWrapping;
   // jobTitleLabel.numberOfLines = 0;
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

@end
