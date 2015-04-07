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
@synthesize jobTitleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //set the values of view controller
    self.jobTitleLabel.text = self.jobTitle;
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
