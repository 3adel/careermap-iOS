//
//  WelcomeAppChoiceViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "WelcomeAppChoiceViewController.h"

@interface WelcomeAppChoiceViewController ()

@end

@implementation WelcomeAppChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //style
    _startNowButton.layer.cornerRadius = 5.0f;
    
    //set images tint to white
    UIImage* jobListOriginalImage = [UIImage imageNamed:@"TabBar-JobList.png"];
    UIImage* jobListImageForRendering = [jobListOriginalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _jobListImage.image = jobListImageForRendering;
    _jobListImage.tintColor = [UIColor whiteColor];
    
    UIImage* addJobOriginalImage = [UIImage imageNamed:@"TabBar-AddJob.png"];
    UIImage* addJobImageForRendering = [addJobOriginalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _addJobImage.image = addJobImageForRendering;
    _addJobImage.tintColor = [UIColor whiteColor];
    
    UIImage* messageOriginalImage = [UIImage imageNamed:@"TabBar-Messages.png"];
    UIImage* messageImageForRendering = [messageOriginalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _messagesImage.image = messageImageForRendering;
    _messagesImage.tintColor = [UIColor whiteColor];
    
    UIImage* privacyOriginalImage = [UIImage imageNamed:@"TabBar-Privacy.png"];
    UIImage* privacyImageForRendering = [privacyOriginalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _privacyImage.image = privacyImageForRendering;
    _privacyImage.tintColor = [UIColor whiteColor];

    
    UIImage* myCVOriginalImage = [UIImage imageNamed:@"TabBar-MyCV.png"];
    UIImage* myCVImageForRendering = [myCVOriginalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _myCVImage.image = myCVImageForRendering;
    _myCVImage.tintColor = [UIColor whiteColor];
    
    
    
    
    
    
    
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

- (IBAction)jobSeekerButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)employerButtonPressed:(UIButton *)sender {
    
    NSLog(@"Install employer app");
}
@end
