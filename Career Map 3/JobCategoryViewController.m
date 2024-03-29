//
//  JobCategoryViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/26/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobCategoryViewController.h"

@interface JobCategoryViewController ()

@end

@implementation JobCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // NSLog(@" job category view did load called");
   // NSLog(@"job object passed from job location view = %@", _jobObject);
    
    //get parse job categories
    [self retrieveJobCategoriesFromParse];
    
    



  
}


- (void) viewDidAppear:(BOOL)animated{
    

    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addjobCategoryButtonWithArray:(NSMutableArray *)array{


    
    //refresh scroll view
    [_jobCategoryScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    for (int i=0; i<=array.count-1; i++) {
        
        //button styles
        _jobCategoryScrollView.contentSize =CGSizeMake([UIScreen mainScreen].bounds.size.width-32, (i+1)*55);
        _jobCategoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, i*55, _jobCategoryScrollView.contentSize.width, 45)];
        
        
        [_jobCategoryButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_jobCategoryButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _jobCategoryButton.layer.cornerRadius=5.0f;
        //blue
       // _jobCategoryButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
        _jobCategoryButton.backgroundColor =[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        [_jobCategoryButton setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [_jobCategoryButton setTitle:
         [[array objectAtIndex:i] objectForKey:@"name"]
                            forState:
         UIControlStateNormal];


        [_jobCategoryButton addTarget:self action:@selector(jobCategoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_jobCategoryButton setTag:i];
        [_jobCategoryScrollView addSubview:_jobCategoryButton];
        
        //if the job categeory is passed from the previous VC, highlight
        if ([[[_jobObject objectForKey:@"jobIndustry"] objectId] isEqualToString:        [[array objectAtIndex:i] objectId]
             ]) {
            //highlight button and set it as selected
            _jobCategoryButton.backgroundColor =[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
            ;
            _PreviouslySelectedJobCategoryButton = _jobCategoryButton;

        }
        
        
    }
    
    //hide progress indicator
    _HUDProgressIndicator.hidden =YES;
    _nextButton.enabled = YES;
    
}


- (void)jobCategoryButtonPressed: (UIButton *) sender{

    
    //will run only the first time use taps on category
    if (!_PreviouslySelectedJobCategoryButton) {
        _PreviouslySelectedJobCategoryButton = sender;
        NSLog(@"First time chose a category = %ld", (long)sender.tag);
        
        
        //green
        sender.backgroundColor =[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];

    }
    
    //will run 2nd time and afterwards
    else{
        //blue
        _PreviouslySelectedJobCategoryButton.backgroundColor =[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        //green
        sender.backgroundColor =[UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
        NSLog(@"Job category index selected = %ld", (long)sender.tag);
        
        _PreviouslySelectedJobCategoryButton = sender;

    }
    
    
    //save the selected category to jobObject
    [_jobObject setValue:[_filteredJobCategoriesArray objectAtIndex:sender.tag] forKey:@"jobIndustry"];
    NSLog(@"%@", [_jobObject objectForKey:@"jobIndustry"]);

}


- (void) retrieveJobCategoriesFromParse{
    
    //disable next button until categories are fetched
    _nextButton.enabled = NO;
    
    
    //start animating progress indicator
    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUDProgressIndicator.labelText = @"Loading industries ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    
    
    
    PFQuery *jobsCategoriesQuery = [PFQuery queryWithClassName:@"JobIndustry"];
    [jobsCategoriesQuery setLimit:1000];
    [jobsCategoriesQuery orderByAscending:@"name"];
    [jobsCategoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //NSLog(@"object = %@", objects);
            
            _jobCategoriesArray = [[NSMutableArray alloc] initWithArray:
                                   objects];
            _filteredJobCategoriesArray = [[NSMutableArray alloc] initWithArray:_jobCategoriesArray];

            
            

            
            //add job category buttons
            [self addjobCategoryButtonWithArray:_jobCategoriesArray];
        }
        
        else{
            NSLog(@"error finding jobs category objects");
            
            
        }
    }];
    
    
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    
    //must select a category or navigation won't proceed
    if (!_PreviouslySelectedJobCategoryButton){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please select a job Industry" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    else{
        
        [self performSegueWithIdentifier:@"addJobDetailsSegue" sender:self];
    }
    

    
    //validate that there's a category selected
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

        if ([segue.identifier isEqualToString:@"addJobDetailsSegue"]) {
            
            AddJobDetailsViewController *destViewController = segue.destinationViewController;
            destViewController.jobObject = _jobObject;
            
        }

}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    /*
    if (searchText.length>=3 && _jobCategoriesArray) {
        NSLog(@"user is typing=%@", [self filterJobCategoriesArrayByContains:searchText inputArray:_jobCategoriesNamesFilteredArray]);
        

    }*/
    
    [self filterJobCategoriesArrayByContains:searchText];
    
}

-(void)filterJobCategoriesArrayByContains:(NSString *)containsString

{
    //take the string
    
    
    _filteredJobCategoriesArray = [[NSMutableArray alloc] initWithArray:_jobCategoriesArray];
    
    //iterat over job categories array,
        //when object at @name is a match //save to the new array
    
    for (PFObject *category in _jobCategoriesArray) {
        
        /*
        if (![[category objectForKey:@"name"] containsString:containsString]) {
            [_filteredJobCategoriesArray removeObject:category];
        }*/

        //[category objectForKey:@"name"] rangeOfString:<#(NSString *)#>
        
        //case insinsitive search
        if (([[category objectForKey:@"name"] rangeOfString:containsString options:NSCaseInsensitiveSearch].location == NSNotFound)) {
            [_filteredJobCategoriesArray removeObject:category];
        }
        
       //  "if ([string rangeOfString:@"bla" options:NSCaseInsensitiveSearch].location != NSNotFound)"
        
        
    }
    
    
    
    /*
    
    NSString *filter=[NSString stringWithFormat:@"SELF contains '%@'",containsString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
    NSMutableArray *filteredJobCategoriesArray = [[inputArray filteredArrayUsingPredicate:predicate] mutableCopy];*/
    
    NSLog(@"filtered = %@", _filteredJobCategoriesArray);
    
    if (_filteredJobCategoriesArray.count) {
        [self addjobCategoryButtonWithArray:_filteredJobCategoriesArray];

    }

    else{
        
        
        if (![containsString isEqualToString:@""]) {
            //clear views
            
            [_jobCategoryScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            //show that there are no results.
            UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
            [noResultsLabel setFont:[UIFont systemFontOfSize:14]];
            noResultsLabel.text = @"No results found";
            noResultsLabel.textColor = [UIColor lightGrayColor];
            [_jobCategoryScrollView addSubview:noResultsLabel];
            


        }
        
        else{
            
            [self addjobCategoryButtonWithArray:_jobCategoriesArray];

        }
        
        
        
    }
    


}





@end
