//
//  ChatView.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/15/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobChatViewController.h"
#import "JobChatMessageCell.h"

//adapt user behaviur
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface JobChatViewController ()

@end

@implementation JobChatViewController


- (void)viewDidLoad {
    
    
    //start animating progress indicator
    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUDProgressIndicator.labelText = @"Loading thread ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    

    
    
    
    //style
    _sendButton.layer.cornerRadius = 5.0f;

    _jobChatTable.estimatedRowHeight = 80.0;
    self.jobChatTable.rowHeight = UITableViewAutomaticDimension;
    [_jobChatTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //other user's name in the title
    if ([_jobPosterPFUser objectForKey:@"username"]) {
        _jobChatNavigationItem.title = [_jobPosterPFUser objectForKey:@"username"];
    }


    //NSLog(@"Job Employer who posted the job User ID = %@", _jobEmployerUserObjectID);
    //NSLog(@"Curernt User  objectID = %@", [[PFUser currentUser] objectId]);
    
    
    [super viewDidLoad];
    self.jobChatTable.delegate =self;
    self.jobChatTable.dataSource =self;
    
    
    //set self as the delegate to textField
    self.messageTextField.delegate =self;
    _messagesArray = [[NSMutableArray alloc] init];
    
    
    //detect when the table view is tapped while the text is being edited
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    [self.jobChatTable addGestureRecognizer:tapGesture];
    
    
    //add an ovserver to monitor upcoming message through push notifications while the message conversation window is visible to the user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"getLatestMessage" object:nil];
    
    
    
    
    [self retrieveMessages];
    
    
    //get blocked users array
    _blockUserButton.title = @"";
    PFQuery *blockedUsersQuery = [PFQuery queryWithClassName:@"_User"];
    [blockedUsersQuery includeKey:@"blockedUsers"];
    [blockedUsersQuery whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId]];
    [blockedUsersQuery whereKey:@"blockedUsers" equalTo:_jobEmployerUserObjectID];
    [blockedUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        //no blocked users found
        if (!objects.count) {
            _blockUserButton.title = @"Block";
        }
        
        
        if (!error) {
            //NSLog(@"users: %@",[objects objectAtIndex:0]);
            
        //turn block button to unblock and disable chat
            if (objects.count>0) {
                _blockUserButton.title = @"Unblock";
                _messageTextField.enabled = NO;
                _messageTextField.text = @"You blocked this user";
               // _messageTextField.placeholder = @"User is blocked";
                _messageTextField.backgroundColor = [UIColor redColor];
                _messageTextField.textColor = [UIColor whiteColor];
                _sendButton.enabled = NO;
                _sendButton.backgroundColor = [UIColor lightGrayColor];
            }
            
            else{
                _blockUserButton.title = @"Block";
                _messageTextField.enabled = YES;
                _messageTextField.text = @"";
                _messageTextField.placeholder = @"Type a message ...";
                _messageTextField.backgroundColor = [UIColor whiteColor];
                _messageTextField.textColor = [UIColor blackColor];
                _sendButton.enabled = NO;
                _sendButton.backgroundColor = [UIColor lightGrayColor];


            }
            
        }
        
        else{
            
            NSLog(@"error retrieving blocked users %@", error);
        }
        
       
    }];
    
    
}


-(void) viewDidAppear:(BOOL)animated{
    
    //scroll to the last message in the array
    

    
    
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
    
    PFObject *chatMessageObject = [self.messagesArray objectAtIndex:indexPath.row];
    
    static NSString *simpleTableIdentifier = @"JobChatMessageCell";
    
    JobChatMessageCell *cell = (JobChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobChatMessageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    
    cell.messageContentTextView.text = [chatMessageObject objectForKey:@"messageContent"];
    
    // cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
    
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        //NSLog(@"userID: %@", [[chatMessageObject objectForKey:@"messageFrom"] objectId]);
        
        
        if ([[[PFUser currentUser] objectId] isEqualToString:[[chatMessageObject objectForKey:@"messageFrom"] objectId]] ) {
            cell.messageAuthorLable.text = @"You (Anonymous)";
            // [cell.messageContentTextView setBackgroundColor:[UIColor redColor]];
            //light blue
            [cell.messageContentTextView setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:234.0/255.0 blue:254.0/255.0 alpha:1]];
            
        }
        
        else{
            
            //light gray
            [cell.messageContentTextView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
            
            //if that user is registered, show their username. Otherwise show anonymous
            
            
            
            //if that user is registered, show their username. Otherwise show anonymous
            
            if ([[[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"signedUp"]   isEqual:@YES] ) {
                //NSLog(@"other user is registered");
                cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
            }
            
            else{
                //NSLog(@"other user is not registered");
                cell.messageAuthorLable.text = @"Anonymous";
                
            }
            
            
            
            
        }
        
        
        
    } else {
        
        //change the color of chat cell background
        
        if ([[[chatMessageObject objectForKey:@"messageFrom"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            
            //light blue
            [cell.messageContentTextView setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:234.0/255.0 blue:254.0/255.0 alpha:1]];

            //[cell.messageAuthorLable ]
            
            //cell.messageAuthorLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
            
            //NSLog(@"user = %@", [[chatMessageObject objectForKey:@"messageFrom"] objectId]);
            
        }
        
        else{
            //light gray
            [cell.messageContentTextView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
            
        }
        
        
        if ([[[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"signedUp"]   isEqual:@YES] ) {
            cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
        }
        
        else{
            cell.messageAuthorLable.text = @"Anonymous";
            
        }
        
        
        
        // cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
        // NSLog(@"you are NOT anonymous");
        
    }
    
    //convert createdAt to local time
    DateConverter *dateConverter = [[DateConverter alloc] init];
    cell.messagePostDateLabel.text = [dateConverter convertDateToLocalTime:chatMessageObject.createdAt];
    
    return cell;
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _messagesArray.count;
    
    
}







- (IBAction)blockUserButtonPressed:(UIBarButtonItem *)sender {

    
    
    if ([_blockUserButton.title  isEqual: @"Block"]) {
        
        //NSLog(@"title is blck");
        //block user
        
        //progress spinner initialization
        MBProgressHUD *HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUDProgressIndicator.labelText = @"Blocking user ...";
        HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
        
        
        PFQuery *blockQuery = [PFQuery queryWithClassName:@"_User"];

        
        
        
        
        [blockQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
            
            if (!error) {
                
                
                
                [object addObject:_jobEmployerUserObjectID forKey:@"blockedUsers"];
                
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //NSLog(@"user blocked now");
                        _blockUserButton.title = @"Unblock";
                        _messageTextField.enabled = NO;
                        _messageTextField.text = @"You blocked this user";
                        _messageTextField.backgroundColor = [UIColor redColor];
                        _messageTextField.textColor = [UIColor whiteColor];
                        _sendButton.enabled = NO;
                        _sendButton.backgroundColor = [UIColor lightGrayColor];
                        
                        
                        [HUDProgressIndicator setHidden:YES];

                        
                    }
                    
                    else{
                        
                        NSLog(@"failed blocked saving ");
                    }
                }];
                
            }
            
            
        }];
        
        
        
        
        
        
    }
    
    
    
    
    else if ([_blockUserButton.title  isEqual: @"Unblock"]) {
        
        //NSLog(@"title is unblck");
        //block user
        
        //progress spinner initialization
        MBProgressHUD *HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUDProgressIndicator.labelText = @"Unblocking user ...";
        HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
        
        PFQuery *blockQuery = [PFQuery queryWithClassName:@"_User"];
        
        
        [blockQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
            
            if (!error) {
                
                
                
                [object removeObject:_jobEmployerUserObjectID forKey:@"blockedUsers"];
                
                
                
                
                
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //NSLog(@"user unblocked now");
                        _blockUserButton.title = @"Block";
                        _messageTextField.enabled = YES;
                        _messageTextField.text = @"";
                        _messageTextField.placeholder = @"Type a message ...";
                        _messageTextField.backgroundColor = [UIColor whiteColor];
                        _messageTextField.textColor = [UIColor blackColor];
                       // _sendButton.enabled = YES;
                       // _sendButton.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:126.0/255.0 blue:251.0/255 alpha:1.0];
                        
                        [HUDProgressIndicator setHidden:YES];
                    }
                    
                    else{
                        
                        NSLog(@"failed unblocked saving ");
                    }
                }];
                
            }
            
            
        }];
        
        
        
        
        
        
    }
    
    else {
        ;
    }
    
    
    
}

- (IBAction)sendButtonPressed:(UIButton *)sender {
    

    dispatch_async(dispatch_get_main_queue(), ^{
        _sendButton.enabled = NO;
        _sendButton.backgroundColor = [UIColor lightGrayColor];
        
        
    });
    


    if (![_messageTextField.text isEqualToString:@""]) {
        
        //now add the message typed statically to the table view. Will not be saved on parse.
        PFObject *messageToAdd = [[PFObject alloc] initWithClassName:@"Conversation"];
        [messageToAdd setObject:_messageTextField.text forKey:@"messageContent"];
        [messageToAdd setObject:[PFUser currentUser] forKey:@"messageFrom"];
        [messageToAdd setObject:_jobPosterPFUser forKey:@"messageTo"];
        [_messagesArray addObject:messageToAdd];

        NSIndexPath* cellIndexPathToAdd= [NSIndexPath indexPathForRow:([_messagesArray count]-1) inSection:0];

        [_jobChatTable beginUpdates];
        NSArray *rowIndexPathsToInsert = [[NSArray alloc] initWithObjects:cellIndexPathToAdd, nil];
        [_jobChatTable insertRowsAtIndexPaths:rowIndexPathsToInsert withRowAnimation:UITableViewRowAnimationBottom];
        [_jobChatTable endUpdates];
        
        [ self scrollToLastMessage];
        
        
        
        
        
        //done editing
        //[self.messageTextField resignFirstResponder];
        //disable send button and text field temporarily as the data is being posted
        //[self.messageTextField setEnabled:NO];
        
        //post the message to parse
        PFObject *newMessageObject = [PFObject objectWithClassName:@"Messages" ];
        newMessageObject[@"messageContent"]= _messageTextField.text;
        newMessageObject[@"messageFrom"]= [PFUser currentUser];
        newMessageObject[@"messageTo"]=_jobPosterPFUser;
        [newMessageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
               // NSLog(@"Success saving message object");
               // [self retrieveMessages];
                
               // NSLog(@"The other user is %@", [_jobPosterPFUser objectId]);
                
                
                
                
                
                //send push notification to the other user
                PFQuery *uQuery = [PFUser query];
                [uQuery whereKey:@"objectId" equalTo:[_jobPosterPFUser objectId]];
                
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"user" matchesQuery:uQuery];
                
                
                
                // PFPush *push = [[PFPush alloc] init];
                
                NSString *pushMessage = [[NSString alloc] init];
                
                
                
                
                PFPush *push = [PFPush new];
                NSTimeInterval pushExpiryInterval = 60.*60.*24*2; //2 days expiry
                [push expireAfterTimeInterval:pushExpiryInterval];
                
                
                [push setQuery:pushQuery];
                // [push setData:<#(NSDictionary *)#>]
                
                
                if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
                    
                    pushMessage =  @"Anonymous user sent you a message";
                    
                }else{
                    // [push setData:pushData];
                    
                    pushMessage =  [NSString stringWithFormat:@"%@ sent you a message", [[PFUser currentUser] objectForKey:@"username"]];
                }
                
                
                NSDictionary *pushData = @{@"message": newMessageObject[@"messageContent"],
                                           @"alert" : pushMessage,
                                           @"sound": @"complete.m4r",
                                           @"otherPFUser": [PFUser currentUser]
                                           };
                [push setData:pushData];
                
                
                
                
                
                
                
                
                
                [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                       // NSLog(@"sending push notification succeedd");
                        ;
                    }
                    else{
                        
                        NSLog(@"sending push notification failed: %@", error.localizedDescription);
                    }
                }];
                
                
                
                
                //************
                //now set the respective readbyUser flag to false
                //check if there's already an existing 1 conversation
                PFQuery *query1 =[PFQuery queryWithClassName:@"Conversation"];
                [query1 whereKey:@"userA"
                         equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
                PFQuery *query2 =[query1 whereKey:@"userB"
                                          equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
                
                PFQuery *query3 =[PFQuery queryWithClassName:@"Conversation"];
                [query3 whereKey:@"userA"
                         equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
                PFQuery *query4 =[query3 whereKey:@"userB"
                                          equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
                
                //combin the two queries in an OR operation
                PFQuery *conversationQuery = [PFQuery orQueryWithSubqueries:@[query2,query4]];
                [conversationQuery includeKey:@"userA"];
                [conversationQuery includeKey:@"userB"];
                conversationQuery.limit =10;
                
                [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (!error) {
                       // NSLog(@"Conversation objects %@", objects);
                        
                        //if one conversation found, change the readBy to NO to the respective user in the TO column
                        if (objects.count ==1) {
                           // NSLog(@"found 1 conversation object");
                            
                            
                            //NSLog(@"userA: %@", [[objects objectAtIndex:0] objectForKey:@"userA"]);
                            
                            
                            if ([[[[objects objectAtIndex:0] objectForKey:@"userA"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                
                                //set readByUserB to False
                                
                                PFObject *conversationObject =[objects objectAtIndex:0];
                                conversationObject[@"readByUserB"] = @NO;
                                
                                
                                //NSLog(@"current user is userA");
                                
                                [conversationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        //NSLog(@"saving conversation unnread status to userB success");
                                        ;
                                    }
                                    
                                    else{
                                        
                                        NSLog(@"saving conversation unread status to userB FAILED");
                                        
                                        
                                        
                                    }
                                }];
                                
                                
                                
                            }
                            
                            else{
                                
                               // NSLog(@"current user NOT  userA");
                                //set readByUserA to False
                                
                                
                                PFObject *conversationObject =[objects objectAtIndex:0];
                                conversationObject[@"readByUserA"] = @NO;
                                
                                
                             //   NSLog(@"current user is userB");
                                
                                [conversationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        //NSLog(@"saving conversation unnread status to userA success");
                                        ;
                                    }
                                    
                                    else{
                                        
                                        NSLog(@"saving conversation unread status to userA FAILED");
                                        
                                        
                                        
                                    }
                                }];
                                
                                
                            }
                            
                            
                        }
                        
                        else{
                            //no conversation found
                            //create a conversation object and update the readByValues
                            PFObject *conversationObject =[PFObject objectWithClassName:@"Conversation"];
                            conversationObject[@"readByUserB"] = @NO;
                            conversationObject[@"readByUserA"] = @NO;
                            conversationObject[@"userA"] = [PFUser currentUser];
                            conversationObject[@"userB"] = _jobPosterPFUser;
                            
                            
                            
                            [conversationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                   // NSLog(@"saving conversation unread status for two users success");
                                    ;
                                }
                                
                                else{
                                    
                                    NSLog(@"saving conversation unread status for two users FAILED");
                                    
                                    
                                    
                                }
                            }];
                        }
                        
                        
                    }
                    
                    else{
                        
                        NSLog(@"error retrieving conversation objects");
                    }
                    
                }];
                
                
                //************
                
                
                
                
                
                
            } else {
                NSLog(@"Error saving message object");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            
            //Reenable send button and text field after process is done
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messageTextField setEnabled:YES];
                //[self.sendButton setEnabled:YES];
                self.messageTextField.text = @"";
                
                
            });
            
            
            
        }];

        
        
    }
    
    
    
    
}

- (IBAction)closeJobChatButtonPressed:(UIBarButtonItem *)sender {
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    [self markConversationAsRead];

    

    
    
}

- (void) viewDidDisappear:(BOOL)animated{
    

}



//MARK: Textfield delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    NSLog(@"did begin editing");
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        
        
        //adapt to screen size
        if(IS_IPAD)
        {
            _dockViewHightConstraint.constant =[UIScreen mainScreen].bounds.size.height*.35;
        }

        if(IS_IPHONE_4_OR_LESS)
        {
            //NSLog(@"IS_IPHONE_4_OR_LESS");
            _dockViewHightConstraint.constant =[UIScreen mainScreen].bounds.size.height*.65;
        }
        if(IS_IPHONE_5)
        {
           // NSLog(@"IS_IPHONE_5");
            _dockViewHightConstraint.constant =[UIScreen mainScreen].bounds.size.height*.55;
        }
        if(IS_IPHONE_6)
        {
            //NSLog(@"IS_IPHONE_6");
            _dockViewHightConstraint.constant =[UIScreen mainScreen].bounds.size.height*.45;
            
            
            
            //_tableViewTopConstraint.constant =-[UIScreen mainScreen].bounds.size.height*.45;
            

        }
        if(IS_IPHONE_6P)
        {
            //NSLog(@"IS_IPHONE_6P");
            _dockViewHightConstraint.constant =[UIScreen mainScreen].bounds.size.height*.45;
        }
        
//        NSLog(@"SCREEN_WIDTH: %f", SCREEN_WIDTH);
//        NSLog(@"SCREEN_HEIGHT: %f", SCREEN_HEIGHT);
//        NSLog(@"SCREEN_MAX_LENGTH: %f", SCREEN_MAX_LENGTH);
//        NSLog(@"SCREEN_MIN_LENGTH: %f", SCREEN_MIN_LENGTH);

        [self.view layoutIfNeeded];
        
        
    } completion:nil];
    
    
    [self scrollToLastMessage];
    
    
    
    
    

    
}


//detect if the user is typing
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
   // NSLog(@"range = %lu", (unsigned long)range.location);
    
   // NSLog(@"string value = %@", [NSString stringWithFormat:@"%@%@",_messageTextField.text, string]);
    
    NSString *rawText =[NSString stringWithFormat:@"%@%@",_messageTextField.text, string];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawText stringByTrimmingCharactersInSet:whiteSpace];
    
    if (trimmed.length == 0) {
        _sendButton.enabled = NO;
        _sendButton.backgroundColor = [UIColor lightGrayColor];

    }
    
    else if (trimmed.length == 1) {
        
        if ([string isEqualToString:@""]) {
            _sendButton.enabled = NO;
            _sendButton.backgroundColor = [UIColor lightGrayColor];
            
        }
        else{
            
            _sendButton.enabled = YES;
            _sendButton.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:126.0/255.0 blue:251.0/255 alpha:1.0];

        }

       // NSLog(@"replacement string = '%@'", string);

        
    }

    else{
        _sendButton.enabled = YES;
        _sendButton.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:126.0/255.0 blue:251.0/255 alpha:1.0];

    }

    
    return YES;
}


- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    /*
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        
        
        //adapt to screen size
        if(IS_IPAD)
        {
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

        }
        
        if(IS_IPHONE_4_OR_LESS)
        {
            //NSLog(@"IS_IPHONE_4_OR_LESS");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

        }
        if(IS_IPHONE_5)
        {
            // NSLog(@"IS_IPHONE_5");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

        }
        if(IS_IPHONE_6)
        {
            //NSLog(@"IS_IPHONE_6");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;
            
        }
        if(IS_IPHONE_6P)
        {
            //NSLog(@"IS_IPHONE_6P");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

        }
        
        //        NSLog(@"SCREEN_WIDTH: %f", SCREEN_WIDTH);
        //        NSLog(@"SCREEN_HEIGHT: %f", SCREEN_HEIGHT);
        //        NSLog(@"SCREEN_MAX_LENGTH: %f", SCREEN_MAX_LENGTH);
        //        NSLog(@"SCREEN_MIN_LENGTH: %f", SCREEN_MIN_LENGTH);
        
        [self.view layoutIfNeeded];
        
        
    } completion:nil];
     */
    
}

- (void) tableViewTapped{
    
    [self.messageTextField resignFirstResponder];
    
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        
        
        //adapt to screen size
        if(IS_IPAD)
        {
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

            
        }
        
        if(IS_IPHONE_4_OR_LESS)
        {
            //NSLog(@"IS_IPHONE_4_OR_LESS");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

        }
        if(IS_IPHONE_5)
        {
            // NSLog(@"IS_IPHONE_5");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

        }
        if(IS_IPHONE_6)
        {
            //NSLog(@"IS_IPHONE_6");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;
            
        }
        if(IS_IPHONE_6P)
        {
            //NSLog(@"IS_IPHONE_6P");
            _dockViewHightConstraint.constant =50;
            _tableViewTopConstraint.constant =0;

        }
        
        //        NSLog(@"SCREEN_WIDTH: %f", SCREEN_WIDTH);
        //        NSLog(@"SCREEN_HEIGHT: %f", SCREEN_HEIGHT);
        //        NSLog(@"SCREEN_MAX_LENGTH: %f", SCREEN_MAX_LENGTH);
        //        NSLog(@"SCREEN_MIN_LENGTH: %f", SCREEN_MIN_LENGTH);
        
        [self.view layoutIfNeeded];
        
        
    } completion:nil];
    
    
    

    
    
   // NSLog(@"table tapppe");
}


- (void) retrieveMessages{
    //we need to include the messagge between those two users only. The current user and the job poster
    
    PFQuery *query1 =[PFQuery queryWithClassName:@"Messages"];
    [query1 whereKey:@"messageTo"
             equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    PFQuery *query2 =[query1 whereKey:@"messageFrom"
                              equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    PFQuery *query3 =[PFQuery queryWithClassName:@"Messages"];
    [query3 whereKey:@"messageTo"
             equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    PFQuery *query4 =[query3 whereKey:@"messageFrom"
                              equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    
    
    
    
    //combin the two queries in an OR operation
    PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:@[query2,query4]];
    [messageQuery includeKey:@"messageFrom"];
    [messageQuery includeKey:@"messageTo"];
    [messageQuery orderByAscending:@"createdAt"];
    messageQuery.limit =1000;
    
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            //start animating progress indicator
            _HUDProgressIndicator.hidden=YES;
            

            
            
            //clear the message array first
            self.messagesArray = [NSMutableArray new];
            for (id message in objects) {
                
                [self.messagesArray addObject:message ];
                
                //NSLog(@"message: %@", _messagesArray);
                
            }
        }
        
        else{
            
            NSLog(@"Error retrieving messages");
        }
        
        //always update ui on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.jobChatTable reloadData];
            

            
        });
        
        
        if ([self.messagesArray count] >0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self scrollToLastMessage];
                
            });
        }
        


    }];
    
    
    
    //if the current user is included in the other user's blocked list, disable controls
    //get blocked users array
    PFQuery *blockedUsersQuery = [PFQuery queryWithClassName:@"_User"];
    [blockedUsersQuery includeKey:@"blockedUsers"];
    [blockedUsersQuery whereKey:@"objectId" equalTo:_jobEmployerUserObjectID];
    [blockedUsersQuery whereKey:@"blockedUsers" equalTo:[[PFUser currentUser] objectId]];
    [blockedUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        //no blocked users found
        if (!objects.count) {
           // NSLog(@"Congrats. The user did not block you");
            
            _messageTextField.enabled = YES;
            _messageTextField.text = @"";
            _messageTextField.placeholder = @"Type a message ...";
            _messageTextField.backgroundColor = [UIColor whiteColor];
            _messageTextField.textColor = [UIColor blackColor];
           // _sendButton.enabled = YES;
            //_sendButton.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:126.0/255.0 blue:251.0/255 alpha:1.0];
            
        }
        
        
        if (!error) {
            NSLog(@"users: %@",[objects objectAtIndex:0]);
            
            //turn block button to unblock and disable chat
            if (objects.count>0) {
                _messageTextField.enabled = NO;
                _messageTextField.text = @"You can't message this user";
                _messageTextField.backgroundColor = [UIColor redColor];
                _messageTextField.textColor = [UIColor whiteColor];
                //_sendButton.enabled = NO;
                //_sendButton.backgroundColor = [UIColor lightGrayColor];
            }
            

            
        }
        
        else{
            
            NSLog(@"error retrieving blocked users %@", error);
        }
        
        
    }];

    
  
}

- (void) scrollToLastMessage{
    
    
    NSLog(@"scroll to last message called");
   // NSLog(@"Size of arrray = %lu", (unsigned long)[_messagesArray count]);
    
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([_messagesArray count] - 1) inSection:0];
    [[self jobChatTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //[[self jobChatTable]
}


- (void) refreshTable{
    
    
    [self retrieveMessages];
    
    
}


- (void) markConversationAsRead{
    
    //select conversation from parse conversation table
    
    //************
    //now set the respective readby flag of the current user to TRUE
    //check if there's already an existing 1 conversation
    PFQuery *query1 =[PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"userA"
             equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    PFQuery *query2 =[query1 whereKey:@"userB"
                              equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    
    PFQuery *query3 =[PFQuery queryWithClassName:@"Conversation"];
    [query3 whereKey:@"userA"
             equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:_jobEmployerUserObjectID]];
    PFQuery *query4 =[query3 whereKey:@"userB"
                              equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
    
    //combin the two queries in an OR operation
    PFQuery *conversationQuery = [PFQuery orQueryWithSubqueries:@[query2,query4]];
    [conversationQuery includeKey:@"userA"];
    [conversationQuery includeKey:@"userB"];
    conversationQuery.limit =10;
    
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
          //  NSLog(@"Conversation objects %@", objects);
            
            //if one conversation found, change the readBy to YES of current user
            if (objects.count ==1) {
              //  NSLog(@"found 1 conversation object");
                
                
                //NSLog(@"userA: %@", [[objects objectAtIndex:0] objectForKey:@"userA"]);
                
                
                if ([[[[objects objectAtIndex:0] objectForKey:@"userA"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    
                    //set readByUserA to true
                    
                    PFObject *conversationObject =[objects objectAtIndex:0];
                    conversationObject[@"readByUserA"] = @YES;
                    
                    
                   // NSLog(@"current user is userA");
                    
                    [conversationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                           // NSLog(@"saving conversation unnread status to userA success");
                            ;
                            //refresh messages list
                          //  MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
                            
                            
                            
                            
                           // UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                           // MessagesViewController *messagesVC = (MessagesViewController *)[sb instantiateViewControllerWithIdentifier:@"MessagesVC"];

                            //[ messagesVC.messagesTable  reloadData];
                            
                            [[ NSNotificationCenter defaultCenter] postNotificationName:@"getLatestMessage" object:nil];

                            
                        }
                        
                        else{
                            
                            NSLog(@"saving conversation unread status to userA FAILED");
                            
                            
                            
                        }
                    }];
                    
                    
                    
                }
                
                else{
                    
                  //  NSLog(@"current user NOT  userA");
                    //set readByUserA to False
                    
                    
                    PFObject *conversationObject =[objects objectAtIndex:0];
                    conversationObject[@"readByUserB"] = @YES;
                    
                    
                  //  NSLog(@"current user is userB");
                    
                    [conversationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            //NSLog(@"saving conversation unnnnnead status to userB success");
                            
                            //refresh messages list
                            //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            //MessagesViewController *messagesVC = (MessagesViewController *)[sb instantiateViewControllerWithIdentifier:@"MessagesVC"];
                           // [ messagesVC.messagesTable  reloadData];
                            [[ NSNotificationCenter defaultCenter] postNotificationName:@"updateReadUnreadStatus" object:nil];

                        }
                        
                        else{
                            
                            NSLog(@"saving conversation unread status to userB FAILED");
                            
                            
                            
                        }
                    }];
                    
                    
                }
                
                
            }
            
            else{
                //no conversation found
                //create a conversation object and update the readByValues
                NSLog(@"no conversation found")      ;
            }
            
            
        }
        
        else{
            
            NSLog(@"error retrieving conversation objects");
        }
        
    }];
    
    
    //************
    

    
    
    
    //set the read flag for the current user to true
    
}




@end
