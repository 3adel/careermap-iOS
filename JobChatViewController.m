//
//  ChatView.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/15/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobChatViewController.h"

@interface JobChatViewController ()

@end

@implementation JobChatViewController 

- (void)viewDidLoad {
    
    NSLog(@"job chat viewdidload called");
    [super viewDidLoad];
    self.jobChatTable.delegate =self;
    self.jobChatTable.dataSource =self;
    
    
    //set self as the delegate to textField
    self.messageTextField.delegate =self;
    
    _messagesArray = [[NSMutableArray alloc] init];
    [self.messagesArray addObject:@"test"];
   //  NSLog(@"Array length = %d", _messagesArray.count);
    // Do any additional setup after loading the view from its nib.
    
    
    //detect when the table view is tapped while the text is being edited
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    [self.jobChatTable addGestureRecognizer:tapGesture];
    
    
    
    //retrieve all message (test)
    [self retrieveMessages];
    
    
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"SimpleTableItem";

    
    // JobCustomTableViewCell *cell = [[JobCustomTableViewCell alloc] init];
    UITableViewCell *cell = [_jobChatTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    
   // NSLog(@"Array length = %d", _messagesArray.count);
    cell.textLabel.text = [_messagesArray objectAtIndex:indexPath.row];

    
    return cell;
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   // return 5;
    return _messagesArray.count;
    
}







- (IBAction)sendButtonPressed:(UIButton *)sender {
    
    //done editing
    [self.messageTextField resignFirstResponder];
    

}

- (IBAction)closeJobChatButtonPressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



//MARK: Textfield delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        _dockViewHightConstraint.constant =350;
        [self.view layoutIfNeeded];
        
        
    } completion:nil];
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        _dockViewHightConstraint.constant =50;
        [self.view layoutIfNeeded];
        
        
    } completion:nil];
    
}

- (void) tableViewTapped{
    
    [self.messageTextField resignFirstResponder];
    NSLog(@"table tapppe");
}


- (void) retrieveMessages{
    
    
    
    //create a new pfquery

    
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:
      //                        @"voteCount >=-4"];
   // PFQuery *retrieveJobs = [PFQuery queryWithClassName:@"Job" predicate:predicate];

    
    //[retrieveJobs whereKey:@"voteCount" <=-5];
   // [retrieveJobs whereKey:@"geolocation" nearGeoPoint:self.userLocation withinKilometers:1000000];
    // [retrieveJobs orderByDescending:@"geolocation"];
  
    
    
    PFQuery *messageQuery = [PFQuery queryWithClassName:@"Messages"];
    [messageQuery includeKey:@"messageFrom"];
    [messageQuery includeKey:@"messageTo"];
   //cell.jobEmployer.text=[tempObject[@"employer"] objectForKey:@"employerName"];
    [messageQuery orderByDescending:@"createdAt"];
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            //clear the message array first
            self.messagesArray = [NSMutableArray new];
            
            
            for (PFObject *message in objects) {
                // NSLog(@"%@", message[@"messageContent"]);
                NSLog(@"From: %@: %@",[message[@"messageFrom"] objectForKey:@"username"], message[@"messageContent"]);
                [self.messagesArray addObject:message[@"messageContent"]];
                
            }
        }
        
        else{
            
            NSLog(@"Error retrieving messages");
        }
        
        //always update ui on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.jobChatTable reloadData];
        });
        
        

        
    }];
    

    
    //call find objects in background
}





@end
