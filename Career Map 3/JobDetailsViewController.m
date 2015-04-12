//
//  JobDetailsViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobDetailsViewController.h"

@interface JobDetailsViewController ()

@end

@implementation JobDetailsViewController

@synthesize jobTitle;
//@synthesize jobTitleLabel;
@synthesize jobDescription;
@synthesize jobDescriptionLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //zoom to job location
    [self zoomToJobLocation];
    
    //set the values of view controller
   // self.jobTitleLabel.text = self.jobTitle;
    self.jobDescriptionLabel.text=self.jobDescription;
    self.jobTitleTextView.text= self.jobTitle;
    self.jobAreaLabel.text = self.jobArea;
    self.jobDateAddedLabel.text = self.jobDateAdded;
    self.jobEmployerLabel.text = self.jobEmployer;
    self.jobVoteLabel.text =self.jobVote;
    self.jobDistanceFromUserLabel.text = self.jobDistanceFromUser;
    
    
    self.jobMap.delegate = self;
    
  //  jobTitleLabel.lineBreakMode= NSLineBreakByWordWrapping;
   // jobTitleLabel.numberOfLines = 0;
    
    
    //add job skills view
   // [self.jobDetailsScrollView addSubview:self.jobSkillsView];
    [self.jobSkillsView setBackgroundColor:[UIColor grayColor]];
    
    
    int count =0;
    for (NSString *skill in self.jobRequiredSkills) {
        NSLog(@"Job skills array =%@", skill);
        
        //add skills to the skills view
        /*
        UILabel *skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40*count, 100, 30)];
        [skillLabel setBackgroundColor:[UIColor grayColor]];
        [skillLabel setFont:[UIFont systemFontOfSize:14]];
        skillLabel.text = skill;
        [self.jobSkillsView addSubview:skillLabel];
        */
        //_jobsSkillsTextView.text = @"test jkjkl jkl  jklj klj klj klj kl jkl jkl jkl jkl jkl jkl jkl jkl jkl kl k l jkl jkl jkl jkl jkl jkl jkl jk l";
        //UITextView *skillTextview =
       // NSString *string1, *string2, *result;
        
       // string1 = @"This is ";
       // string2 = @"my string.";
        
        _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:skill];
        
        if (!(count == ([self.jobRequiredSkills count])-1)) {
            _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:@", "];
        }
        
        
        
        count++;
    }
    
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



- (void) zoomToJobLocation{
    
    
    //zoom to job location
    CLLocationCoordinate2D jobZoomLocation;
    jobZoomLocation= self.jobLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(jobZoomLocation, 2000, 2000);
    [_jobMap setRegion:viewRegion animated:YES];
    
    
    //add job annotation
    // Add an annotation
    MKPointAnnotation *jobPoint = [[MKPointAnnotation alloc] init];
    jobPoint.coordinate = self.jobLocation.coordinate;
    jobPoint.title = self.jobTitle;
    jobPoint.subtitle = [self.jobDistanceFromUser stringByAppendingString:[NSString stringWithFormat:@", %@", self.jobAddressLine]];
    [_jobMap addAnnotation:jobPoint];
    
    
    
    
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   // [mapView deselectAnnotation:view.annotation animated:YES];
    
 //   DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
  //  controller.annotation = view.annotation;
   // self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
   // self.popover.delegate = self;
   // [self.popover presentPopoverFromRect:view.frame
          //                        inView:view.superview
           //     permittedArrowDirections:UIPopoverArrowDirectionAny
                      //          animated:YES];
    
    NSLog(@"map annotation selected selected");
}


//custom annotation view
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    
    MKAnnotationView *jobAnnView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"jobLocation"];
    jobAnnView.image = [ UIImage imageNamed:@"job-annotation-icon.png" ];
    
    UIButton *showDirectionsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [showDirectionsButton addTarget:self action:@selector(showJobDirection) forControlEvents:UIControlEventTouchUpInside];
    
    jobAnnView.rightCalloutAccessoryView = showDirectionsButton;
    jobAnnView.canShowCallout = YES;
    return jobAnnView;
}

- (void) showJobDirection{
    
    NSLog(@"show me job directions please");
}



@end
