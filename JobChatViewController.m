//
//  ChatView.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/15/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobChatViewController.h"
#import "JobChatMessageCell.h"

@interface JobChatViewController ()

@end

@implementation JobChatViewController 



/*
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.jobChatTable.contentSize.height > self.jobChatTable.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.jobChatTable.contentSize.height -     self.jobChatTable.frame.size.height);
        [self.jobChatTable setContentOffset:offset animated:YES];
    }
}*/

- (void)viewDidLoad {
    
    NSLog(@"Job Employer who posted the job User ID = %@", _jobEmployerUserObjectID);
    NSLog(@"Curernt User  objectID = %@", [[PFUser currentUser] objectId]);
    
    //jobChatScreen.employerID =_jobEmployerUserObjectID;

    
    
    //NSLog(@"job chat viewdidload called");
    [super viewDidLoad];
    self.jobChatTable.delegate =self;
    self.jobChatTable.dataSource =self;
    
    
    //set self as the delegate to textField
    self.messageTextField.delegate =self;
    
    _messagesArray = [[NSMutableArray alloc] init];
    //[self.messagesArray addObject:@"test"];
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
    
    /*
    static NSString *CellIdentifier = @"SimpleTableItem";

    
    // JobCustomTableViewCell *cell = [[JobCustomTableViewCell alloc] init];
    UITableViewCell *cell = [_jobChatTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }*/
    PFObject *chatMessageObject = [self.messagesArray objectAtIndex:indexPath.row];

    
   // PFObject *tempObject = [jobsArrayWithUsersVotesStable objectAtIndex:indexPath.row];
 //   cell.jobTitleLabel.text = [tempObject objectForKey:@"title"];
    // NSLog(@"%@",[tempObject objectForKey:@"currentUserVotedUpThisJob"]);
    
    
  //  NSLog(@"temp object: %@", tempObject);
    
    
    
    
    //NSLog(@"%@",chatMessageObject.createdAt.description);
    
    
    static NSString *simpleTableIdentifier = @"JobChatMessageCell";
    
    JobChatMessageCell *cell = (JobChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobChatMessageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

  //  cell.messageContentLabel.text = [_messagesArray objectAtIndex:indexPath.row];
    
  //  NSLog(@"%@", chatMessageObject);
    
    
   // NSLog(@"Array length = %d", _messagesArray.count);
  //  cell.messageContentLabel.text = [[(PFObject *)[_messagesArray objectAtIndex:indexPath] objectForKey:@"messageContent"];ject
    
    cell.messageContentTextView.text = [chatMessageObject objectForKey:@"messageContent"];
    
   // NSLog(@"Chat object%@")
    cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
    
    if ([[[chatMessageObject objectForKey:@"messageFrom"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        NSLog(@"MAAAAAATCH");
        
        cell.messageAuthorLable.text = @"You (Anonymous)";
    }
    else{
        
        cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
    }
    
    
    //NSLog(@"%@", [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"objectId"]);
    
    
    
   // NSLog(@"Chat messsage object = %@", chatMessageObject);
    cell.messagePostDateLabel.text = chatMessageObject.createdAt.description;
   // NSLog(@"%@", chatMessageObject);
    
  //  NSLog(@"%@", [[_messagesArray objectAtIndex:indexPath.row] objectForKey:@"messageContent"]);
    
   // NSLog(@"%@", _messagesArray);
    //[tempObject[@"employer"] objectForKey:@"employerName"];
                                     
                                     
   // cell.messageContentLabel.text = [(pfobject *)[self.messagesArray ]]
    
  //  [object objectForKey:@"jobVotedUp"]);
    
    
    
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
    
    
    
    //disable send button and text field temporarily as the data is being posted
    [self.messageTextField setEnabled:NO];
    [self.sendButton setEnabled:NO];
    
    //post the message to parse
    PFObject *newMessageObject = [PFObject objectWithClassName:@"Messages" ];
    newMessageObject[@"messageContent"]= _messageTextField.text;
    newMessageObject[@"messageFrom"]= [PFUser currentUser];
    newMessageObject[@"messageTo"]=_jobPosterPFUser;
    
    //PFUser *user = [[PFUser alloc] initWithClassName:@"_User"];
    //user.objectId = _jobEmployerUserObjectID;

   // newMessageObject[@"messageTo"] = user;
    
    
    // destViewController.jobEmployerUserObjectID= [[tempObject objectForKey:@"postedByUser"] objectId];
    
    
    [newMessageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Success saving message object");
            [self retrieveMessages];
            
            //[self.jobChatTable setContentOffset:CGPointMake(0, CGFLOAT_MAX) animated:NO];
            
            
            
        } else {
            NSLog(@"Error saving message object");
        }
        
        //Reenable send button and text field after process is done
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageTextField setEnabled:YES];
            [self.sendButton setEnabled:YES];
            self.messageTextField.text = @"";
            /*
            if (self.jobChatTable.contentSize.height > self.jobChatTable.frame.size.height)
            {
                CGPoint offset = CGPointMake(0, self.jobChatTable.contentSize.height -     self.jobChatTable.frame.size.height);
                [self.jobChatTable setContentOffset:offset animated:YES];
            }*/

            
            
            
        });
        
        
        
    }];
    

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
  
    
  //  _jobEmployerUserObjectID
    //
   // [[PFUser currentUser] objectId]
    
   // [mesageFrom.objectId] = [[PFUser currentUser] objectId]
    NSString *content = @"3. I want to apply.";
    
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageContent = content"];

   // [[messageFrom objectForKey:@"postedByUser"] objectId];
    
    
  //  PFQuery *messageQuery = [PFQuery queryWithClassName:@"Messages"];
    
  //  [mess whereKey:@"playerEmail" equalTo:@"dstemkoski@example.com"];
   // [messageQuery includeKey:@"messageFrom"];
   // [messageQuery includeKey:@"messageTo"];
    //[messageQuery whereKey:@"messageContent" equalTo:@"Q5md5dlEYL"];
   // [messageQuery whereKey:<#(NSString *)#> equalTo:<#(id)#>]
    
    // Assume PFObject *myPost was previously created.
   // PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    //[messageQuery whereKey:@"messageFrom" equalTo:myPost];
    
    /*
    [messageQuery whereKey:@"messageTo"
            equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    */
    //[messageQuery whereKey:@"messageFrom"
     //        equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    
    
    //[messageQuery where]
    
    //we need to include the messagge between those two users only. The current user and the job poster
     // where (messageFrom is from current user && messageTo is of job poster
    
    PFQuery *query1 =[PFQuery queryWithClassName:@"Messages"];

    [query1 whereKey:@"messageTo"
                   equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
   
    PFQuery *query2 =[query1 whereKey:@"messageFrom"
equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];

   // [query1 whereKey:@"messageTo"
       //      equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    
    
    PFQuery *query3 =[PFQuery queryWithClassName:@"Messages"];
    
    [query3 whereKey:@"messageTo"
             equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    
    PFQuery *query4 =[query3 whereKey:@"messageFrom"
                              equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    
    // [query1 whereKey:@"messageTo"
    //      equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    
    
    
    
    PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:@[query2,query4]];
    
   // [PFQuery orQueryWithSubqueries:@[fewWins,lotsOfWins]];
    
    
  //  [messageQuery whereKey:@"messageFrom"
  //                 equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    
    
    //|| (messageFrom is job poster and message to is current user )
    
    
    
   //cell.jobEmployer.text=[tempObject[@"employer"] objectForKey:@"employerName"];
    [messageQuery includeKey:@"messageFrom"];
    [messageQuery includeKey:@"messageTo"];
    [messageQuery orderByAscending:@"createdAt"];
    
    
    
    
    
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            //clear the message array first
            self.messagesArray = [NSMutableArray new];
            
            
            for (id message in objects) {
                // NSLog(@"%@", message[@"messageContent"]);
               // NSLog(@"%@ %@: %@",message.createdAt,[message[@"messageFrom"] objectForKey:@"username"], message[@"messageContent"]);
           //  NSLog(@"%@", message);
             [self.messagesArray addObject:message ];
                
            }
        }
        
        else{
            
            NSLog(@"Error retrieving messages");
        }
        
        //always update ui on main thread
        
      //  [self.jobChatTable reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.jobChatTable reloadData];
        });
        
        

        
    }];
    

    
    //call find objects in background
}





@end
