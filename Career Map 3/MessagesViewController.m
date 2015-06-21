//
//  MessagesViewController.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/12/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "MessagesViewController.h"

@interface MessagesViewController ()

@end



@implementation MessagesViewController

@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //progress spinner initialization
    self.messagesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:_messagesTable animated:YES];
    _HUDProgressIndicator.labelText = @"Loading messages ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    
    
    //add an ovserver to monitor upcoming message through push notifications while the message conversation window is visible to the user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessages) name:@"getLatestMessage" object:nil];

    [self getUsersWhoBlockedMe];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:220.0/255.0 green:234.0/255 blue:255.0/255.0 alpha:1];
    [self.refreshControl addTarget:self
                            action:@selector(getUsersWhoBlockedMe)
                  forControlEvents:UIControlEventValueChanged];
    [self.messagesTable addSubview:self.refreshControl];
    
    
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    //update read unread bold/regular values
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReadUnreadStatus) name:@"updateReadUnreadStatus" object:nil];
    
    
}


- (void) viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateReadUnreadStatus" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _chatUsersList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell  *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!(!_chatUsersNamesList || !_chatUsersNamesList.count)) {
        cell.usernameLabel.text = [_chatUsersNamesList objectAtIndex:indexPath.row];
        
        
        
        //username setting logic
        if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
            
            if ([[[PFUser currentUser] objectId] isEqualToString:[[_chatUsersPFUsersList objectAtIndex:indexPath.row] objectId]])
            {
                //  cell.messageAuthorLable.text = @"You (Anonymous)";
                cell.usernameLabel.text = @"You (Anonymous)";
                
            }
            
            else{
                
                //if that user is registered, show their username. Otherwise show anonymous
                if ([[[_chatUsersPFUsersList objectAtIndex:indexPath.row] objectForKey:@"signedUp"] isEqual:@YES] ) {
                    cell.usernameLabel.text = [[_chatUsersPFUsersList objectAtIndex:indexPath.row] objectForKey:@"username"];
                }
                
                else{
                    cell.usernameLabel.text = @"Anonymous";
                    
                }
                
            }
            
            
            
        } else {
            
            //other user is registered
            if ([[[_chatUsersPFUsersList objectAtIndex:indexPath.row] objectForKey:@"signedUp"] isEqual:@YES] ) {
                cell.usernameLabel.text = [[_chatUsersPFUsersList objectAtIndex:indexPath.row] objectForKey:@"username"];
            }
            
            //other user is not registered
            else{
                cell.usernameLabel.text = @"Anonymous";
                
            }
            
            
        }
        
        
    }
    
    
    if (!(!_chatLastMessageArray || !_chatLastMessageArray.count)) {
        cell.lastMessageLabel.text = [_chatLastMessageArray objectAtIndex:indexPath.row];
        
    }
    
    
    //set unread/read highlighting of converesations
    if ((_conversationReadUnreadBooleansDictonary.count == _chatUsersPFUsersList.count) && (_chatUsersPFUsersList.count)) {
        
        
        if ([[_conversationReadUnreadBooleansDictonary valueForKey:  [[_chatUsersPFUsersList objectAtIndex:indexPath.row] objectId]] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            cell.usernameLabel.font = [UIFont boldSystemFontOfSize:17.0];
            cell.lastMessageLabel.font = [UIFont boldSystemFontOfSize:15.0];
            //light blue color
            cell.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:234.0/255 blue:255.0/255.0 alpha:1];
            cell.userObjectIdLabel.text=@"Unread";
            
            
        }
        
        
        else{
            cell.usernameLabel.font = [UIFont systemFontOfSize:17.0];
            cell.lastMessageLabel.font = [UIFont systemFontOfSize:15.0];
            cell.backgroundColor = [UIColor clearColor];
            cell.userObjectIdLabel.text=@"";
            
        }
        
        
        
    }
    
    return cell;
    
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    //only go to chat when there's actually data
    if (!(!_chatUsersPFUsersList || !_chatUsersPFUsersList.count)) {
        
        
        
        //invoke the job chat view, but with the userIDs
        JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
        
        //pass the PFUser object of the other person to the chat view
        jobChatScreen.jobEmployerUserObjectID = [_chatUsersList objectAtIndex:indexPath.row];
        jobChatScreen.jobPosterPFUser = [_chatUsersPFUsersList objectAtIndex:indexPath.row];
        
        [self presentViewController:jobChatScreen animated:YES completion:nil];
        
        
        
    }

    
}


- (void) refreshMessages{
    
    
    [self getUsersWhoBlockedMe];

}




- (void) refreshReadUnreadStatus{
    
    [self getUsersWhoBlockedMe];

}


- (void) retrieveMessages{

    _UnreadMessagesCountBooleansArray =[[NSMutableArray alloc] init];
    
    //initialize arrays
    _messageFromArray = [NSMutableArray new];
    _messageToArray = [NSMutableArray new];
    _chatUsersList = [NSMutableArray new];
    _chatUsersNamesList = [NSMutableArray new];
    _chatUsersPFUsersList = [NSMutableArray new];
    _chatLastMessageArray = [NSMutableArray new];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageFrom = %@ OR messageTo = %@",[PFUser currentUser], [PFUser currentUser]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages" predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"messageFrom"];
    [query includeKey:@"messageTo"];
    [query setLimit:1000];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            NSInteger counter2 = 0;
            
            for (PFObject *object in objects) {

                if ([[[object objectForKey:@"messageFrom"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    
                    
                    if (![_chatUsersList containsObject:[[object objectForKey:@"messageTo"] objectId]]) {

                        if (![_usersWhoBlockedMeList containsObject:[[object objectForKey:@"messageTo"] objectId]]) {
                            
                            //add user to the list of chatters if the user is not blocked
                            [_chatUsersList addObject:[[object objectForKey:@"messageTo"] objectId]];
                            [_chatUsersNamesList addObject:[[object objectForKey:@"messageTo"] objectForKey:@"username"]];
                            [_chatUsersPFUsersList addObject:(PFUser *)[object objectForKey:@"messageTo"]];
                            [_chatLastMessageArray addObject:[object objectForKey:@"messageContent"]];
                        }
                        
                        else{
                            
                            
                            ;
                        }
                        
                        
                        
                    }
                    
                    
                    
                }
                
                else{
                    
                    if (![_chatUsersList containsObject:[[object objectForKey:@"messageFrom"] objectId]]) {
  
                        if (![_usersWhoBlockedMeList containsObject:[[object objectForKey:@"messageFrom"] objectId]]) {
                            //add user to the list of chatters
                            [_chatUsersList addObject:[[object objectForKey:@"messageFrom"] objectId]];
                            [_chatUsersNamesList addObject:[[object objectForKey:@"messageFrom"] objectForKey:@"username"]];
                            [_chatUsersPFUsersList addObject:(PFUser *)[object objectForKey:@"messageFrom"]];
                            [_chatLastMessageArray addObject:[object objectForKey:@"messageContent"]];
                            
                        }
                        
                        else{
                            
                            // NSLog(@"found a blocked user");
                            ;
                        }
                        
                        
                        
                        
                        
                    }

                    
                }

                counter2++;
                if (counter2 == objects.count -1)
                    
                    
                    break;}

        }
        
        else{
            //end refreshing
            if (self.refreshControl) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUDProgressIndicator hide:YES];
                    [self.refreshControl endRefreshing];
                    
                });
            }
            else{
                [_HUDProgressIndicator hide:YES];

                
                
            }

            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Something went wrong. Or check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        }
        

        NSInteger count =0;
        _conversationReadUnreadBooleansDictonary = [[NSMutableDictionary alloc] init];

        //hide refresh control if no users exist
        if (!_chatUsersPFUsersList.count) {
            if (self.refreshControl) {
                [self.refreshControl endRefreshing];
                
                //also show the no messages view
                [_noMessagesYetView setHidden:NO];

                    [_HUDProgressIndicator hide:YES];

                
            }
            
        }
        
        else{
            
            [_noMessagesYetView setHidden:YES];
            //show seperator
            self.messagesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        
        
        
        for (PFUser *user in _chatUsersPFUsersList) {

            
            PFQuery *query1 =[PFQuery queryWithClassName:@"Conversation"];
            [query1 whereKey:@"userA"
                     equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
            PFQuery *query2 =[query1 whereKey:@"userB"
                                      equalTo: user];
            PFQuery *query3 =[PFQuery queryWithClassName:@"Conversation"];
            [query3 whereKey:@"userA"
                     equalTo:user];
            PFQuery *query4 =[query3 whereKey:@"userB"
                                      equalTo:[PFObject objectWithoutDataWithClassName:@"_User" objectId:[[PFUser currentUser] objectId]]];
            
            //combin the two queries in an OR operation
            PFQuery *conversationQuery = [PFQuery orQueryWithSubqueries:@[query2,query4]];
            [conversationQuery includeKey:@"userA"];
            [conversationQuery includeKey:@"userB"];
            conversationQuery.limit =1000;
            
            
            
            [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (!error) {

                    if (objects.count ==1) {

                        if ([[[[objects objectAtIndex:0] objectForKey:@"userA"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {

                            
                            
                            if ([[[objects objectAtIndex:0] objectForKey:@"readByUserA"]  isEqual: @NO]) {
                                [_UnreadMessagesCountBooleansArray addObject:[NSNumber numberWithBool:NO]];
                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:NO] forKey:[user objectId]];

                                
                            }
                            
                            
                            else{

                                
                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:YES] forKey:[user objectId]];
                                
                            }
 
                            
                        }
                        else{
                            
                            if ([[[objects objectAtIndex:0] objectForKey:@"readByUserB"]  isEqual: @NO]) {
                                [_UnreadMessagesCountBooleansArray addObject:[NSNumber numberWithBool:NO]];
                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:NO] forKey:[user objectId]];

                            }
                            else{

                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:YES] forKey:[user objectId]];

                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    else{
                        //no conversation found. should never execute this
                        ;
                        
                        
                        
                    }
                    
                    
                }
                
                else{
                    
                    //end refreshing
                    if (self.refreshControl) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_HUDProgressIndicator hide:YES];
                            [self.refreshControl endRefreshing];
                            
                        });
                    }
                    else{
                        [_HUDProgressIndicator hide:YES];
                        
                        
                        
                    }

                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Something went wrong. Or check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    
                }
                
                
                //update the badge of messages tab bar item
                if (count == _chatUsersPFUsersList.count-1 ) {

                    UITabBarController *tbc = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
                    
                    if ([_UnreadMessagesCountBooleansArray count] >0) {
                        
                        
                        [[[[tbc tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%lu", (unsigned long)[_UnreadMessagesCountBooleansArray count]]];
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[_UnreadMessagesCountBooleansArray count]];
                        
                    }
                    else{
                        
                        [[[[tbc tabBar] items] objectAtIndex:3] setBadgeValue:0];
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                        
                        
                    }

                    //end refreshing
                    if (self.refreshControl) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_HUDProgressIndicator hide:YES];
                            [self.refreshControl endRefreshing];
                            
                        });
                        
                    }
                    
                    else{
                        [_HUDProgressIndicator hide:YES];

                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                else{
                    
                    //end refreshing
                    if (self.refreshControl) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_HUDProgressIndicator hide:YES];
                            [self.refreshControl endRefreshing];
                            
                        });
                    }

                    
                    
                }
                
                
                //prevent crash
                [_messagesTable reloadData];

            }];

            count ++;
        }

    }];

}



- (void) getUsersWhoBlockedMe{
    
    PFQuery *blockedUsersQuery = [PFQuery queryWithClassName:@"_User"];
    [blockedUsersQuery includeKey:@"blockedUsers"];
    [blockedUsersQuery whereKey:@"blockedUsers" equalTo:[[PFUser currentUser] objectId]];
    [blockedUsersQuery setLimit:1000];
    
    _usersWhoBlockedMeList = [[NSMutableArray alloc] init];
    
    [blockedUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            
            for (PFUser *user in objects) {
                
                [_usersWhoBlockedMeList addObject:[user objectId]];
 
            }
            
            
            [self retrieveMessages];
            
            
        }
        
        else{
            
            //end refreshing
            if (self.refreshControl) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUDProgressIndicator hide:YES];
                    [self.refreshControl endRefreshing];
                    
                });
            }
            else{
                [_HUDProgressIndicator hide:YES];

                
            }

            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Something went wrong. Or check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        
        
    }];
    
    
    
    
}


@end
