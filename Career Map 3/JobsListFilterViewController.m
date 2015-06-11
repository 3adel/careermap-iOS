//
//  JobsListViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/10/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobsListFilterViewController.h"

@interface JobsListFilterViewController ()

@end

@implementation JobsListFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_jobsDistanceFilterSlider setValue:[[[NSUserDefaults standardUserDefaults]objectForKey:@"jobDistanceFilterValue"] doubleValue]/100];
    
    NSLog(@"current slider value = %f", [[[NSUserDefaults standardUserDefaults]objectForKey:@"jobDistanceFilterValue"] doubleValue]/100);
    
    _jobDistanceFilterLabel.text = [NSString stringWithFormat:@"%.0f km",[[[NSUserDefaults standardUserDefaults]objectForKey:@"jobDistanceFilterValue"] doubleValue]];
    

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

- (IBAction)cancelFilterButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)applyFilterButtonPressed:(UIBarButtonItem *)sender {

    
    //prevent filter value from being 0
    if (!_jobsDistanceFilterSlider.value ) {
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:1] forKey:@"jobDistanceFilterValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else{

        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:_jobsDistanceFilterSlider.value*100] forKey:@"jobDistanceFilterValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }

    [_delegate sendFilterDistance:[[[NSUserDefaults standardUserDefaults]
                                       objectForKey:@"jobDistanceFilterValue"] doubleValue]];
    [_delegate reloadDelegateData];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (IBAction)jobsDistanceFilterChanged:(UISlider *)sender {
    
    
  //  alarmLimit = [sender value]*1000;
    
    NSLog(@"slider value = %f", sender.value*100);
    _jobDistanceFilterLabel.text = [NSString stringWithFormat:@"%.0f km",sender.value*100];
    

    //[soundLimitValueLabel setText:[NSString stringWithFormat:@"%.0f", [sender value]*1000]];
    

    
    
    
}
@end
