//
//  JobDetailsViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobDetailsViewController.h"
#import "JobChatViewController.h"

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
    self.jobEducationTextView.text = self.jobEducation;
    
    self.jobMap.delegate = self;
    self.jobMap.mapType = MKMapTypeStandard;
  //  jobTitleLabel.lineBreakMode= NSLineBreakByWordWrapping;
   // jobTitleLabel.numberOfLines = 0;
    
    
    //add job skills view
   // [self.jobDetailsScrollView addSubview:self.jobSkillsView];
    [self.jobSkillsView setBackgroundColor:[UIColor grayColor]];
    
    
    int count =0;
    for (NSString *skill in self.jobRequiredSkills) {
       // NSLog(@"Job skills array =%@", skill);
        
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
        
        
        
        _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:[NSString stringWithFormat:@"- %@",skill]];
        
        if (!(count == ([self.jobRequiredSkills count])-1)) {
            _jobsSkillsTextView.text = [_jobsSkillsTextView.text stringByAppendingString:@"\n"];
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
    
    
    
    /*
    //convert job cllocation to parse point to be used for zooming
    PFGeoPoint *jobLocationPoint = [[PFGeoPoint alloc] init];
    jobLocationPoint.latitude =self.jobLocation.coordinate.latitude;
    jobLocationPoint.longitude =self.jobLocation.coordinate.longitude;
    
*/
    
    //double k = ;
   // NSLog(@"distance is = %f",k);
    
    
    //zoom to job location
    CLLocationCoordinate2D jobZoomLocation;
    jobZoomLocation= self.jobLocation.coordinate;
  //  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(jobZoomLocation, ([self.userLocation distanceInKilometersTo: jobLocationPoint])*250, ([self.userLocation distanceInKilometersTo: jobLocationPoint])*250);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(jobZoomLocation, 50, 50);
    [_jobMap setRegion:viewRegion animated:YES];
    [_jobMap setScrollEnabled:NO];
    
   
  //  NSNumber *jobDistanceNumber = [NSNumber numberWithDouble:[self.userLocation2 distanceInKilometersTo:self.jobLocation]];
   // NSLog(@"user location %@", jobDistanceNumber);

    
    //[self.joblocation distanceInKilometersTo
    
    //add job annotation
    // Add an annotation
    MKPointAnnotation *jobPoint = [[MKPointAnnotation alloc] init];
    jobPoint.coordinate = self.jobLocation.coordinate;
    jobPoint.title = self.jobTitle;
   // jobPoint.subtitle = [self.jobDistanceFromUser stringByAppendingString:[NSString stringWithFormat:@", %@", self.jobAddressLine]];
    jobPoint.subtitle = self.jobAddressLine;
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
    jobAnnView.image = [ UIImage imageNamed:@"job-annotation-icon3.png" ];
    
    UIButton *showDirectionsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [showDirectionsButton addTarget:self action:@selector(showJobDirection) forControlEvents:UIControlEventTouchUpInside];
    
    jobAnnView.rightCalloutAccessoryView = showDirectionsButton;
    jobAnnView.canShowCallout = YES;
    return jobAnnView;
}

- (void) showJobDirection{
    
    NSLog(@"show me job directions please");
        [self performSegueWithIdentifier:@"jobMap" sender:self];
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"jobMap"]) {
        

        JobMapViewController *destViewController = segue.destinationViewController;
        destViewController.jobLocation = self.jobLocation;
        
        NSLog(@"go to map");
    }
}


//start chat with employer
- (IBAction)chatWithEmployerButtonPressed:(UIButton *)sender {
    
    
    
  //  JobChatViewController *jobChatViewController = [[JobChatViewController alloc] initWithNib:@"JobChatView" bundle:nil];
   // [self pushViewController:viewControllerB animated:YES];
    
    
    NSLog(@"Chat with employer button pressed");
    
    JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
    /*
    [self.tabBarController presentViewController:appChoice
                                        animated:YES
                                      completion:nil];*/
    
    //pass the user id of the job poster to the destination chat screen.
    jobChatScreen.jobEmployerUserObjectID =_jobEmployerUserObjectID;

    
    
    [self presentViewController:jobChatScreen animated:YES completion:nil];
}





@end
