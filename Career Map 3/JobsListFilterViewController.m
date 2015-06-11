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
    
    
    NSLog(@"%lu Array of default categories %@",(unsigned long)[[[NSUserDefaults standardUserDefaults] objectForKey:@"jobsCategoriesArray"] count], [[NSUserDefaults standardUserDefaults] objectForKey:@"jobsCategoriesArray"]);
    

    //_jobCategoriesArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"jobsCategoriesArray"];
   // NSLog(@"%@", _jobCategoriesArray);
    
    [self retrieveJobCategoriesFromParse];

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
    
    //this array "testArray" will be replaced by what you have from categories
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:@"segXAhy6JS"];
    [[NSUserDefaults standardUserDefaults] setObject:testArray forKey:@"jobsCategorySelectedArrayForFilter"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    
    
    [_delegate sendFilterCategoriesSelected:testArray];
    
    [_delegate reloadDelegateData];

    //- (void) sendFilterCategoriesSelected: (NSMutableArray *) categoriesSelected;

    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (IBAction)jobsDistanceFilterChanged:(UISlider *)sender {
    
    
  //  alarmLimit = [sender value]*1000;
    
    NSLog(@"slider value = %f", sender.value*100);
    _jobDistanceFilterLabel.text = [NSString stringWithFormat:@"%.0f km",sender.value*100];
    

    //[soundLimitValueLabel setText:[NSString stringWithFormat:@"%.0f", [sender value]*1000]];
    

    
    
    
}



- (void) retrieveJobCategoriesFromParse{
    
    NSLog(@"rerieve jobs categories from parse called");
    
    PFQuery *jobsCategoriesQuery = [PFQuery queryWithClassName:@"JobIndustry"];
    [jobsCategoriesQuery setLimit:1000];
    [jobsCategoriesQuery orderByAscending:@"name"];
    [jobsCategoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //NSLog(@"object = %@", objects);
            
            _jobCategoriesArray = [[NSMutableArray alloc] initWithArray:objects];
            
            
        
            }

        
        else{
            NSLog(@"error finding jobs category objects");
            
            
        }
        
        [_jobCategoriesTable reloadData];
    }];
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _jobCategoriesArray.count;
    
    
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *jobCategoryObject = [_jobCategoriesArray objectAtIndex:indexPath.row];
    
    static NSString *simpleTableIdentifier = @"JobChatMessageCell";
    
    JobCategoryTableViewCell *cell = (JobCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobCategoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.categoryNameLabel.text = [jobCategoryObject objectForKey:@"name"];
    
 
    return cell;
    
}




@end
