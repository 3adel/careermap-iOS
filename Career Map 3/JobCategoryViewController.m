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
    
    


  
}


- (void) viewDidAppear:(BOOL)animated{
    
    //get parse job categories
    
    
    //add job category buttons
    [self addjobCategoryButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addjobCategoryButton{


    

    
    
    for (int i=0; i<1000; i++) {
        
        //button styles
        
        //set ui constraints for the button
        _jobCategoryScrollView.contentSize =CGSizeMake([UIScreen mainScreen].bounds.size.width, (i+1)*55);
        _jobCategoryButton = [[UIButton alloc] initWithFrame:CGRectMake(10, i*55, [UIScreen mainScreen].bounds.size.width-20, 45)];
        _jobCategoryButton.layer.cornerRadius=5.0f;
        _jobCategoryButton.backgroundColor = [UIColor blueColor];
        [_jobCategoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _jobCategoryButton.backgroundColor = [UIColor blueColor];
        [_jobCategoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_jobCategoryButton setTitle:[NSString stringWithFormat:@"button %d",i] forState:UIControlStateNormal];
        [_jobCategoryButton addTarget:self action:@selector(jobCategoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_jobCategoryButton setTag:i];

        [_jobCategoryScrollView addSubview:_jobCategoryButton];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)jobCategoryButtonPressed: (UIButton *) sender{

    
    //will run only the first time use taps on category
    if (!_PreviouslySelectedJobCategoryButton) {
        _PreviouslySelectedJobCategoryButton = sender;
        NSLog(@"Job category index selected = %ld", sender.tag);
        sender.backgroundColor = [UIColor grayColor];
        
    }
    
    //will run 2nd time and afterwards
    else{
        _PreviouslySelectedJobCategoryButton.backgroundColor =[UIColor blueColor];
        sender.backgroundColor = [UIColor grayColor];
        NSLog(@"Job category index selected = %ld", sender.tag);
        _PreviouslySelectedJobCategoryButton = sender;

    }
    
    
    //save the selected category to jobObject
    


}






@end
