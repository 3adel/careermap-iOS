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
    
    NSLog(@" job category view did load called");
    NSLog(@"job object passed from job location view = %@", _jobObject);
    
    //get parse job categories
    [self retrieveJobCategoriesFromParse];


  
}


- (void) viewDidAppear:(BOOL)animated{
    

    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addjobCategoryButton{


    for (int i=0; i<=_jobCategoriesArray.count-1; i++) {
        
        //button styles
        _jobCategoryScrollView.contentSize =CGSizeMake([UIScreen mainScreen].bounds.size.width-32, (i+1)*55);
        _jobCategoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, i*55, _jobCategoryScrollView.contentSize.width, 45)];
        [_jobCategoryButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_jobCategoryButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _jobCategoryButton.layer.cornerRadius=5.0f;
        _jobCategoryButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:255.0/0.0 alpha:1.0];
        [_jobCategoryButton setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [_jobCategoryButton setTitle:
         [[_jobCategoriesArray objectAtIndex:i] objectForKey:@"name"]
                            forState:
         UIControlStateNormal];


        [_jobCategoryButton addTarget:self action:@selector(jobCategoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_jobCategoryButton setTag:i];
        [_jobCategoryScrollView addSubview:_jobCategoryButton];
    }
    
    //hide progress indicator
    _HUDProgressIndicator.hidden =YES;
    
}


- (void)jobCategoryButtonPressed: (UIButton *) sender{

    
    //will run only the first time use taps on category
    if (!_PreviouslySelectedJobCategoryButton) {
        _PreviouslySelectedJobCategoryButton = sender;
        NSLog(@"Job category index selected = %ld", sender.tag);
        sender.backgroundColor = [UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:0.0/0.0 alpha:1.0];
        
        
    }
    
    //will run 2nd time and afterwards
    else{
        _PreviouslySelectedJobCategoryButton.backgroundColor =[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:255.0/0.0 alpha:1.0];

        sender.backgroundColor = [UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:0.0/0.0 alpha:1.0];
        
        
        NSLog(@"Job category index selected = %ld", sender.tag);
        _PreviouslySelectedJobCategoryButton = sender;

    }
    
    
    //save the selected category to jobObject
    [_jobObject setValue:[_jobCategoriesArray objectAtIndex:sender.tag] forKey:@"jobIndustry"];

    NSLog(@"%@", [_jobObject objectForKey:@"jobIndustry"]);


}


- (void) retrieveJobCategoriesFromParse{
    
    
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
            
            //add job category buttons
            [self addjobCategoryButton];
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





@end
