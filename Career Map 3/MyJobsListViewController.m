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
    
    
    [self retrieveMyJobsFromParse];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myJobsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MyJobCell";
    
    MyJobTableViewCell *cell = (MyJobTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyJobCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    PFObject *myJobPFObject = [_myJobsArray objectAtIndex:indexPath.row];
    
    cell.jobTitle.text = [myJobPFObject objectForKey:@"title"];
    
    
    
    return cell;
    
    
    
}

- (void) retrieveMyJobsFromParse{
    
    PFQuery *query =[PFQuery queryWithClassName:@"Job"];
    [query includeKey:@"jobIndustry"];
    [query whereKey:@"postedByUser"
             equalTo: [PFUser currentUser]];
    [query orderByAscending:@"createdAt"];
    query.limit =1000;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            ///NSLog(@"objects : %@", objects);
            
            
            
            _myJobsArray = [NSMutableArray new];
            for (id myJob in objects) {
                
                [_myJobsArray addObject:myJob ];
                
                NSLog(@"message: %@", _myJobsArray);
                
            }


        }
        
        else{
            
            NSLog(@"error retrieving my jobs");
        }
        
        
        //reload table
        [_myJobsTable reloadData];
    }];
    
    
    
}



- (IBAction)takeMeToJobEditor:(UIButton *)sender {
    

    JobLocationViewController *jobLocationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"jobLocationViewController"];
    
    
    //here where you pass the job object
    
    //go
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:jobLocationVC];
    [self.navigationController pushViewController:navi animated:YES];


}
@end
