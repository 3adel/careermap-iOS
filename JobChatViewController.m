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


- (void)viewDidLoad {
    
    _jobChatTable.estimatedRowHeight = 80.0;
    self.jobChatTable.rowHeight = UITableViewAutomaticDimension;
    [_jobChatTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    
    NSLog(@"Job Employer who posted the job User ID = %@", _jobEmployerUserObjectID);
    NSLog(@"Curernt User  objectID = %@", [[PFUser currentUser] objectId]);
    
    
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
        
        NSLog(@"userID: %@", [[chatMessageObject objectForKey:@"messageFrom"] objectId]);
        
        
        if ([[[PFUser currentUser] objectId] isEqualToString:[[chatMessageObject objectForKey:@"messageFrom"] objectId]] ) {
            cell.messageAuthorLable.text = @"You (Anonymous)";
           // [cell.messageContentTextView setBackgroundColor:[UIColor redColor]];

        }
        
        else{
            
            //if that user is registered, show their username. Otherwise show anonymous
            
            
                
                //if that user is registered, show their username. Otherwise show anonymous
                
                if ([[[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"signedUp"]   isEqual:@YES] ) {
                    NSLog(@"other user is registered");
                                cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
                }
            
                else{
                    NSLog(@"other user is not registered");
                    cell.messageAuthorLable.text = @"Anonymous";
                    
                }
                
                
            

        }
        
        
        
    } else {
        
        //change the color of chat cell background
    
        if ([[[chatMessageObject objectForKey:@"messageFrom"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
           // [cell.messageContentTextView setBackgroundColor:[UIColor redColor]];
            
            //[cell.messageAuthorLable ]
            
            //cell.messageAuthorLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
            
            NSLog(@"user = %@", [[chatMessageObject objectForKey:@"messageFrom"] objectId]);

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
    cell.messagePostDateLabel.text = chatMessageObject.createdAt.description;
    
    
    return cell;
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
    [newMessageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Success saving message object");
            [self retrieveMessages];
            
            NSLog(@"The other user is %@", [_jobPosterPFUser objectId]);

            

            
            
            //send push notification to the other user
            PFQuery *uQuery = [PFUser query];
            [uQuery whereKey:@"objectId" equalTo:[_jobPosterPFUser objectId]];
            
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"user" matchesQuery:uQuery];
            

           
           // PFPush *push = [[PFPush alloc] init];
            
            NSString *pushMessage = [[NSString alloc] init];
            
            
            
            
            PFPush *push = [PFPush new];
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
                    NSLog(@"sending push notification succeedd");
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
                   NSLog(@"Conversation objects %@", objects);
                   
                   //if one conversation found, change the readBy to NO to the respective user in the TO column
                   if (objects.count ==1) {
                       NSLog(@"found 1 conversation object");
                       
                       
                       NSLog(@"userA: %@", [[objects objectAtIndex:0] objectForKey:@"userA"]);
                       
                       
                       if ([[[[objects objectAtIndex:0] objectForKey:@"userA"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                          
                           //set readByUserB to False

                           PFObject *conversationObject =[objects objectAtIndex:0];
                           conversationObject[@"readByUserB"] = @NO;

                           
                           NSLog(@"current user is userA");
                          
                           [conversationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                               if (succeeded) {
                                   NSLog(@"saving conversation unnread status to userB success");
                               }
                               
                               else{
                                   
                                   NSLog(@"saving conversation unread status to userB FAILED");

                                   
                                   
                               }
                           }];
                           
                           
                           
                       }
                       
                       else{
                           
                           NSLog(@"current user NOT  userA");
                           //set readByUserA to False
                           
                           
                           PFObject *conversationObject =[objects objectAtIndex:0];
                           conversationObject[@"readByUserA"] = @NO;
                           
                           
                           NSLog(@"current user is userB");
                           
                           [conversationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                               if (succeeded) {
                                   NSLog(@"saving conversation unnread status to userA success");
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
                               NSLog(@"saving conversation unread status for two users success");
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
        }
        
        //Reenable send button and text field after process is done
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageTextField setEnabled:YES];
            [self.sendButton setEnabled:YES];
            self.messageTextField.text = @"";
            
            
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
        _dockViewHightConstraint.constant =300;
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
            //clear the message array first
            self.messagesArray = [NSMutableArray new];
            for (id message in objects) {
                
                [self.messagesArray addObject:message ];
                
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
        
        

        
       /// dispatch_async(dispatch_get_main_queue(), ^{
          //  [self scrollToLastMessage];
      //
            
            
     //   });
        

        
        
        
    }];
    

    
}

- (void) scrollToLastMessage{
    
    
    
    
    
    NSLog(@"Size of arrray = %ld", [_messagesArray count]);
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([_messagesArray count] - 1) inSection:0];
    [[self jobChatTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //[[self jobChatTable]
}


- (void) refreshTable{
    
    
    [self retrieveMessages];
}





@end
