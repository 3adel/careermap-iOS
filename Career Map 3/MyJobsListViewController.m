//
//  MyJobsListViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/2/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "MyJobsListViewController.h"

@interface MyJobsListViewController ()

@end

@implementation MyJobsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"my jobs list view did load");
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

- (IBAction)takeMeToJobEditor:(UIButton *)sender {
    

    JobLocationViewController *jobLocationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"jobLocationViewController"];
    
    
    //here where you pass the job object
    
    //go
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobLocationVC];
    [self.navigationController pushViewController:navi animated:YES];


}
@end
