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
        
        if ([[[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"signedUp"]   isEqual:@YES] ) {
            NSLog(@"other user is registered");
            cell.messageAuthorLable.text = [[chatMessageObject objectForKey:@"messageFrom"] objectForKey:@"username"];
        }
        
        else{
            NSLog(@"other user is not registered");
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





@end
