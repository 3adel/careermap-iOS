//
//  CreateCVViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/19/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "CreateCVViewController.h"

@interface CreateCVViewController ()

@end

@implementation CreateCVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //set the border color of mandatory fields to red
 //   _CVjobSeekerFirstNameTextView.layer.borderColor = [[UIColor redColor] CGColor];
    _CVjobSeekerFirstNameTextView.layer.cornerRadius=5.0f;
    //_CVjobSeekerFirstNameTextView.layer.masksToBounds=YES;
    _CVjobSeekerFirstNameTextView.layer.borderColor=[[UIColor redColor]CGColor];
    _CVjobSeekerFirstNameTextView.layer.borderWidth= .5f;
    
    _CVjobSeekerLastNameTextView.layer.cornerRadius=5.0f;
    //_CVjobSeekerFirstNameTextView.layer.masksToBounds=YES;
    _CVjobSeekerLastNameTextView.layer.borderColor=[[UIColor redColor]CGColor];
    _CVjobSeekerLastNameTextView.layer.borderWidth= .5f;
    
    
    
    
    //detect when theview is tapped while the text is being edited
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
    //add gesture recognizer for the thumb image edit
    UITapGestureRecognizer *CVthumbTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CVthumbTapped)];
    [_CVjobSeekerThumb addGestureRecognizer:CVthumbTapGesture];
    
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

- (IBAction)closeCreateCVButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveCVButtonPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"Save cv button pressed");
    
    
    //dismiss keyboard
    [_CVjobSeekerFirstNameTextView resignFirstResponder];
    [_CVjobSeekerLastNameTextView resignFirstResponder];
    [_CVjobSeekerCurrentTitleTextView resignFirstResponder];
    

    [self checkFieldsComplete];
    
    //validate fields, mandatory fields should not be empty
    
    
}


- (void) checkFieldsComplete{
    
    //validate mandatory fields only
    if ([_CVjobSeekerFirstNameTextView.text isEqualToString:@""] || [_CVjobSeekerLastNameTextView.text isEqualToString:@""]) {
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error!" message:@"You need to complete all madnatory fields" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
    else{
        
        
        NSLog(@"Save cv to backend");
        [self saveCVToParse];
        
    }
    
    
    
}


//dismiss keyboard when view is tapped
-(void) viewTapped{
    
    [_CVjobSeekerLastNameTextView resignFirstResponder];
    [_CVjobSeekerFirstNameTextView resignFirstResponder];
    [_CVjobSeekerCurrentTitleTextView resignFirstResponder];
    NSLog(@"view is tapped");
    
}

//this should resolve the add


- (void) saveCVToParse{
    

    //start animating activity indicator while saving
    UIActivityIndicatorView *saveCVActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [saveCVActivityIndicator setColor:[UIColor colorWithRed:13.0/255.0 green:153.0/255 blue:252.0/255.0 alpha:1]];

    
    //UIColor colorWithRed:13 green:153 blue:252 alpha:1
    saveCVActivityIndicator.center = self.view.center;
    [self.view addSubview:saveCVActivityIndicator];
    [saveCVActivityIndicator startAnimating];
    
    // Code to get data from database
    
    
    
    
    // if the user have a cv, it should be an update and not create
    
    //If the user don't have a CV, take them to the CV creation flow.
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query includeKey:@"aJobSeekerID"];
    [query getObjectInBackgroundWithId: [[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        if (!error) {
            
            if ([object objectForKey:@"aJobSeekerID"]) {
                //user does have CV
                NSLog(@"job seeker ID found = %@", [[object objectForKey:@"aJobSeekerID"] objectId]);
                
                
                //now update the cv in the jobSeeker table
                 //get the record in jobSeekerID
                 ///update the record
                
                PFQuery *jobSeekerQuery = [PFQuery queryWithClassName:@"jobSeeker"];
                
                // Retrieve the object by id
                [jobSeekerQuery getObjectInBackgroundWithId:[[object objectForKey:@"aJobSeekerID"] objectId] block:^(PFObject *jobSeekerObject, NSError *error) {
                    
                    // Now let's update it with some new data. In this case, only cheatMode and score
                    // will get sent to the cloud. playerName hasn't changed.
                    jobSeekerObject[@"firstName"] = _CVjobSeekerFirstNameTextView.text;
                    jobSeekerObject[@"lastName"] = _CVjobSeekerLastNameTextView.text;
                    jobSeekerObject[@"currentTitle"] =_CVjobSeekerCurrentTitleTextView.text;
                    NSData *imageData = UIImagePNGRepresentation(_CVjobSeekerThumb.image);
                    PFFile *imageFile = [PFFile fileWithName:@"CVThumbnail.png" data:imageData];
                    jobSeekerObject[@"jobSeekerThumb"] = imageFile;
                    
                    
                    
                    
                    
                    //**************
                    //jobSeekerObject[@"score"] = @1338;
                    [jobSeekerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Success: CV edited");
                            
                            [saveCVActivityIndicator stopAnimating];
                            [saveCVActivityIndicator setHidesWhenStopped:YES];
                            
                            //notify the system that the edit is successful
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"CVEditedSuccessNotification" object:nil];

                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else{
                            
                            NSLog(@"Fail: CV edited");
                        }
                    }];
                    
                }];
                
                
                
                
              //  NSLog(@"People who applied to this job = %@", [_jobObject objectForKey:@"appliedByUsers"]);
                
            
                
                
                
            }
            
            else{
                
                
                //create a new CV block
                //else, just add the cv
                //create an object for the cv
                //save the object in the jobSeeker table linking it to the current user
                
                PFObject *cvObject = [PFObject objectWithClassName:@"jobSeeker"];
                cvObject[@"firstName"] = _CVjobSeekerFirstNameTextView.text;
                cvObject[@"lastName"] = _CVjobSeekerLastNameTextView.text;
                cvObject[@"currentTitle"] = _CVjobSeekerCurrentTitleTextView.text;
                NSData *imageData = UIImagePNGRepresentation(_CVjobSeekerThumb.image);
                PFFile *imageFile = [PFFile fileWithName:@"CVThumbnail.png" data:imageData];
                cvObject[@"jobSeekerThumb"] = imageFile;
                
     
                

                
                [cvObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"success saving new cv");
                        
                        
                        //now update the user table accordingly
                        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                        [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *userObject, NSError *error) {
                            userObject[@"aJobSeekerID"] = cvObject;
                            [userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    NSLog(@"user table updated successfully with a new cv reference");
                                    //notify the system that the edit is successful
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CVEditedSuccessNotification" object:nil];
                                    

                                } else{
                                    
                                    NSLog(@"Error: user table update with cv reference: %@", error);
                                    
                                }
                            }];
                        }];
                        
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                    else{
                        
                        NSLog(@"error saving cv");
                    }
                }];
            }
            
            
        }
        
        else{
            
            NSLog(@"Error retrieving job seekerID: %@", error);
        }
    }];
    
    
    
    
    
    
    
    

    
    
    

    
    
    
    

    
    
}



- (void)CVthumbTapped{
    
    
    NSLog(@"cv thumb tapped");
    
    
    //present photo source action sheet
    _photoSourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select photo from:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Library",
                            nil];
    
    _photoSourceActionSheet.tag = 1;
    [_photoSourceActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
 
    
    
    /*
    //instantiate the cv thumb editor
    CVThumbEditViewController *CVThumbEditView = [[CVThumbEditViewController alloc] initWithNibName:@"CVThumbEditView" bundle:nil];
    [self presentViewController:CVThumbEditView animated:YES completion:nil];*/
    
}


- (void)actionSheet:(UIActionSheet *)_photSourceoActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //handle multiple action sheet if necesssary
    switch (_photoSourceActionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:{
                    NSLog(@"Take photo from camera");
                    //get photo from camera
                    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                    cameraPicker.delegate = self;
                    cameraPicker.allowsEditing = YES;
                    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:cameraPicker animated:YES completion:NULL];
                }
                    break;
                case 1:{
                    NSLog(@"Take photo from photo library");
                    //get photo from camera
                    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                    cameraPicker.delegate = self;
                    cameraPicker.allowsEditing = YES;
                    cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:cameraPicker animated:YES completion:NULL];
                }
            
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

//update the thumb image view with picked image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.CVjobSeekerThumb.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}






@end
