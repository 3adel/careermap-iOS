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

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"job object = %@", _jobObject);

    

    //change the constraint of skills view height
    _jobSkillsViewHeightConstraint.constant = 700;
    
    //add first skill text field and
    
    
    
    
}


- (void) viewDidAppear:(BOOL)animated{
    
    
    

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
