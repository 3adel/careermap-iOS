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
    
    
    //add job skills view
   // [self.jobDetailsScrollView addSubview:self.jobSkillsView];
    [self.jobSkillsView setBackgroundColor:[UIColor grayColor]];
    
    
    int count =0;
    for (NSString *skill in self.jobRequiredSkills) {
        NSLog(@"Job skills array =%@", skill);
        
        //add skills to the skills view
        /*
        UILabel *skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40*count, 100, 30)];
        [skillLabel setBackgroundColor:[UIColor grayColor]];
        [skillLabel setFont:[UIFont systemFontOfSize:14]];
        skillLabel.text = skill;
        [self.jobSkillsView addSubview:skillLabel];
        */
        //_jobsSkillsTextView.text = @"test jkjkl jkl  jklj klj klj klj kl jkl jkl jkl jkl jkl jkl jkl jkl jkl kl k l jkl jkl jkl jkl jkl jkl jkl jk l";
        //UITextView *skillTextview =
       // NSString *string1, *string2, *result;
        
       // string1 = @"This is ";
       // string2 = @"my string.";
        
        _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:skill];
        
        if (!(count == ([self.jobRequiredSkills count])-1)) {
            _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:@", "];
        }
        
    
    
        
        
        
       // result = [result stringByAppendingString:string1];
        //result = [result stringByAppendingString:string2];
        
        
        count++;
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

@end
