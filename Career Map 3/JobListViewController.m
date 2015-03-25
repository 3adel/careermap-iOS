//
//  JobListViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobListViewController.h"
#import "JobCustomTableViewCell.h"


@implementation JobListViewController{
    
     NSArray *jobs;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Job";
        
        // The key of the PFObject to display in the label of the default cell style
       // self.textKey = @"title";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"jobCell";
    
    JobCustomTableViewCell *cell = (JobCustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
 //   PFFile *thumbnail = [object objectForKey:@"image"];
  //  PFImageView *thumbnailImageView = (PFImageView*)cell.thumbnailImageView;
   // thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
 //   thumbnailImageView.file = thumbnail;
  //  [thumbnailImageView loadInBackground];
    
    cell.jobTitleLabel.text = [object objectForKey:@"title"];
    
   // NSLog(@"Job Object:%@", object);
    
    
    
    
    
    //create an object for the employer
    PFObject *employer = [object objectForKey:@"employer"];
    [employer fetchInBackgroundWithBlock:^(PFObject *object, NSError *error){cell.jobEmployer.text=[object objectForKey:@"employerName"];}];
    
    
    
    
    
   // NSLog(@"Employer:%@", employer);
    
    
    
    
    
  //  cell.jobEmployer.text=[object objectForKey:@"employer"];
    
    
    
    
   // cell.prepTimeLabel.text = [object objectForKey:@"prepTime"];
    
    return cell;
}







@end
