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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // _messagesTable.delegate =self;
    // _messagesTable.dataSource = self;
    
    //  NSLog(@"Messages list 'view did load'");
    
    
    //progress spinner initialization
    self.messagesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _HUDProgressIndicator = [MBProgressHUD showHUDAddedTo:_messagesTable animated:YES];
    _HUDProgressIndicator.labelText = @"Loading messages ...";
    _HUDProgressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    
    
    
    //add an ovserver to monitor upcoming message through push notifications while the message conversation window is visible to the user

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessages) name:@"getLatestMessage" object:nil];
    
    //
    
    
    [self getUsersWhoBlockedMe];
    
    //[self retrieveMessages];
    
    
    
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    // self.refreshControl.backgroundColor = [UIColor colorWithRed:255/255.0 green:149.0/255.0 blue:0.0/0.0 alpha:0.8]; //light blue color
    //self.refreshControl.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:234.0/255 blue:255.0/255.0 alpha:1];
    self.refreshControl.tintColor = [UIColor colorWithRed:220.0/255.0 green:234.0/255 blue:255.0/255.0 alpha:1];
    
    //self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getUsersWhoBlockedMe)
                  forControlEvents:UIControlEventValueChanged];
    [self.messagesTable addSubview:self.refreshControl];


    
}

- (void) viewDidAppear:(BOOL)animated{

    
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



- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    
    
    /*
     
     if ([[_conversationReadUnreadBooleansArray objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
     
     
     cell.textLabel.backgroundColor = [UIColor redColor];
     }
     
     else{
     cell.textLabel.backgroundColor = [UIColor clearColor];
     
     }
     
     
     
     */
    
    
    
    
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







/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (void) refreshMessages{
    
    
    [self getUsersWhoBlockedMe];
    
    
    
    

}




- (void) refreshReadUnreadStatus{
    
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // NSLog(@"objects: %@", objects);
            

            
            NSInteger counter2 = 0;
            
            for (PFObject *object in objects) {
                
                
                NSLog(@"object= %@", object);
                // NSLog(@"messageFrom = %@", [[object objectForKey:@"messageFrom"] objectForKey:@"username"]);
                //NSLog(@"messageTo = %@", [[object objectForKey:@"messageTo"] objectId]);
                // NSLog(@"message = %@ \n\n", [object objectForKey:@"messageContent"]);
                
                
                
                // [_messageFromArray addObject:[[object objectForKey:@"messageFrom"] objectId]];
                // [_messageFromArray addObject:[[object objectForKey:@"messageTo"] objectId]];
                
                
                
                if ([[[object objectForKey:@"messageFrom"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    
                    
                    if (![_chatUsersList containsObject:[[object objectForKey:@"messageTo"] objectId]]) {
                        
                        
                        
                       // [[[_usersWhoBlockedmePFUsersList objectAtIndex:counter2] objectId] isEqualToString:[[object objectForKey:@"messageTo"] objectId]]
                        
                        NSLog(@"object = %@", [[object objectForKey:@"messageTo"] objectId]);
                        
                        if (![_usersWhoBlockedMeList containsObject:[[object objectForKey:@"messageTo"] objectId]]) {
                            
                            
                            
                            //add user to the list of chatters if the user is not blocked
                            [_chatUsersList addObject:[[object objectForKey:@"messageTo"] objectId]];
                            [_chatUsersNamesList addObject:[[object objectForKey:@"messageTo"] objectForKey:@"username"]];
                            [_chatUsersPFUsersList addObject:(PFUser *)[object objectForKey:@"messageTo"]];
                            [_chatLastMessageArray addObject:[object objectForKey:@"messageContent"]];
                        }
                        
                        else{
                            
                            NSLog(@"founddddd a blocked user");
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
                            
                            NSLog(@"found a blocked user");
                        }
                        
                        
         
                        
                        
                    }
                    
                    // NSLog(@"chat users IDs list = %@", _chatUsersList);
                    //  NSLog(@"chat usernames list = %@", _chatUsersNamesList);
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
            
            
                counter2++;
                if (counter2 == objects.count -1)
                    
                  
                    break;}
                
                
                
            
            
            
            
        }
        
        else{
            
            NSLog(@"error retrieving messages");
        }
        
        
        
        
        NSInteger count =0;
        //_conversationReadUnreadBooleansArray = [[NSMutableArray alloc] initWithCapacity:_chatUsersPFUsersList.count];
        _conversationReadUnreadBooleansDictonary = [[NSMutableDictionary alloc] init];

        
        
        //hide refresh control if no users exist
        if (!_chatUsersPFUsersList.count) {
            if (self.refreshControl) {
                
                [self.refreshControl endRefreshing];
                
                //also show the no messages view
                [_noMessagesYetView setHidden:NO];
                
                
            }

        }
        
        else{
            
            [_noMessagesYetView setHidden:YES];
            //show seperator
            self.messagesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        
        
        
        for (PFUser *user in _chatUsersPFUsersList) {
            
            
            
            // *****
            
            //if current user is userA
            // ifread by user A is NO
            //set to bold
            //else set to normal
            
            //else if readby userB is NO
            //set to bold
            //else set to normal
            // ****
            
            //************
            //now set the respective readbyUser flag to false
            //check if there's already an existing 1 conversation
            
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
            conversationQuery.limit =10;
            
            
            
            [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (!error) {
                    NSLog(@"Conversation objects %@", objects);
                    
                    //if one conversation found, change the readBy to NO to the respective user in the TO column
                    if (objects.count ==1) {
                        NSLog(@"found 1 conversation object");
                        
                        
                        NSLog(@"userA: %@", [[objects objectAtIndex:0] objectForKey:@"userA"]);
                        
                        
                        if ([[[[objects objectAtIndex:0] objectForKey:@"userA"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            
                            NSLog(@"current user is userA");
                            //check if the read flag is false
                            NSLog(@"conversation %@", [[objects objectAtIndex:0] objectForKey:@"readByUserA"]);
                            
                            
                            if ([[[objects objectAtIndex:0] objectForKey:@"readByUserA"]  isEqual: @NO]) {
                                
                                NSLog(@"read by user A = False");
                                //cell.usernameLabel.font = [UIFont boldSystemFontOfSize:17.0];
                                 [_UnreadMessagesCountBooleansArray addObject:[NSNumber numberWithBool:NO]];
                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:NO] forKey:[user objectId]];
                                
                                
                               
                                
                               // [_conversationReadUnreadBooleansArray addObject:[NSNumber numberWithBool:NO]];
                               // [_conversationReadUnreadBooleansArray insertObject:[NSNumber numberWithBool:NO] atIndex:count ];
                                //[_conversationReadUnreadBooleansArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:count];
                                
                            
                            }
                            
                            
                            else{
                                NSLog(@"read by user A = True");
                                //cell.usernameLabel.font = [UIFont systemFontOfSize:17.0];
                              // [_conversationReadUnreadBooleansArray addObject:[NSNumber numberWithBool:YES]];
                                
                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:YES] forKey:[user objectId]];
                               // [_conversationReadUnreadBooleansArray insertObject:[NSNumber numberWithBool:YES] atIndex:count ];
                                // [_conversationReadUnreadBooleansArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:count];
                                
                                
                            }
                            
                            
                            
                            
                            
                        }
                        else{
                            
                            NSLog(@"current user is userB");
                            if ([[[objects objectAtIndex:0] objectForKey:@"readByUserB"]  isEqual: @NO]) {
                                [_UnreadMessagesCountBooleansArray addObject:[NSNumber numberWithBool:NO]];
                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:NO] forKey:[user objectId]];
                                
                                
                                
                               // [_conversationReadUnreadBooleansArray insertObject:[NSNumber numberWithBool:NO] atIndex:count ];
                                
                                 //[_conversationReadUnreadBooleansArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:count];
                            }
                            else{
                                
                                //[_conversationReadUnreadBooleansArray addObject:[NSNumber numberWithBool:YES]];
                                [_conversationReadUnreadBooleansDictonary setValue:[NSNumber numberWithBool:YES] forKey:[user objectId]];
                               // [_conversationReadUnreadBooleansArray insertObject:[NSNumber numberWithBool:YES] atIndex:count ];
                                 //[_conversationReadUnreadBooleansArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:count];
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    else{
                        //no conversation found. should never execute this
                        NSLog(@"no conversations found");
                        
                        
                        
                    }
                    
                    
                }
                
                else{
                    
                    NSLog(@"error retrieving conversation objects");
                }
                
                
                //update the badge of messages tab bar item
                if (count == _chatUsersPFUsersList.count-1 ) {
                    NSLog(@"update unread tab bar badge now");
                    //[[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld", [_UnreadMessagesCountBooleansArray count]]];
                    
                    
                    UITabBarController *tbc = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
                    
                    if ([_UnreadMessagesCountBooleansArray count] >0) {
                        
                        
                        [[[[tbc tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%lu", (unsigned long)[_UnreadMessagesCountBooleansArray count]]];
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[_UnreadMessagesCountBooleansArray count]];
                        
                        NSLog(@"counttttttt = %ld", (long)count);
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
                
                
                
   
                    
                    NSLog(@"message list reload data called");
                    [_messagesTable reloadData];

                
                
         
                
                

                
            }];
            
            
            
            //************
            
            

            
            count ++;
        }
        
        
        
       //  [_messagesTable reloadData];
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //reload table data after data fetchibng is done
    
    
    
    
    
    
}



- (void) getUsersWhoBlockedMe{

    PFQuery *blockedUsersQuery = [PFQuery queryWithClassName:@"_User"];
    [blockedUsersQuery includeKey:@"blockedUsers"];
    [blockedUsersQuery whereKey:@"blockedUsers" equalTo:[[PFUser currentUser] objectId]];
    
    _usersWhoBlockedMeList = [[NSMutableArray alloc] init];
    
    
    [blockedUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        

        if (!error) {
            //NSLog(@"users who blocked me: %lu", (unsigned long)objects.count);
            

            for (PFUser *user in objects) {
               // NSLog(@"users who blocked me: %lu", (unsigned long)objects.count);
 
                
                [_usersWhoBlockedMeList addObject:[user objectId]];
                
                
            }
            
            
            [self retrieveMessages];
            
            
        }
        
        else{
            
            NSLog(@"error retrieving blocked users %@", error);

        }
        
        
    }];

    

    
}


@end
