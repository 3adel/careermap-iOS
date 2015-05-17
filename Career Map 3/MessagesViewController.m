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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // _messagesTable.delegate =self;
    // _messagesTable.dataSource = self;
    
    //  NSLog(@"Messages list 'view did load'");
    
    
    //add an ovserver to monitor upcoming message through push notifications while the message conversation window is visible to the user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessages) name:@"getLatestMessage" object:nil];
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    
    //NSLog(@"Messages list 'view did appear'");
    
    
    [self retrieveMessages];
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //NSLog(@"Number of items = %d", _chatUsersList.count);
    return _chatUsersList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell  *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    // MessageCell  *cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.usernameLabel.text = [_chatUsersNamesList objectAtIndex:indexPath.row];
    cell.userObjectIdLabel.text=[_chatUsersList objectAtIndex:indexPath.row];
    cell.lastMessageLabel.text = [_chatLastMessageArray objectAtIndex:indexPath.row];
    
    
    // NSLog(@"table row");
    
    //set unread/read highlighting of converesations
    if (_conversationReadUnreadBooleansArray.count == _chatUsersPFUsersList.count) {
       
        
        if ([[_conversationReadUnreadBooleansArray objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            
            
            cell.usernameLabel.font = [UIFont boldSystemFontOfSize:17.0];
        }
        

        else{
            cell.usernameLabel.font = [UIFont systemFontOfSize:17.0];
            
        }
        
        
        
    }
    
    else{

        
        cell.usernameLabel.font = [UIFont systemFontOfSize:17.0];

        
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
    
    
    //invoke the job chat view, but with the userIDs
    JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
    
    //pass the PFUser object of the other person to the chat view
    jobChatScreen.jobEmployerUserObjectID = [_chatUsersList objectAtIndex:indexPath.row];
    jobChatScreen.jobPosterPFUser = [_chatUsersPFUsersList objectAtIndex:indexPath.row];
    
    [self presentViewController:jobChatScreen animated:YES completion:nil];
    
    
    
    
    
    
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
    
    
    [self retrieveMessages];
}


- (void) retrieveMessages{
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageFrom = %@ OR messageTo = %@",[PFUser currentUser], [PFUser currentUser]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages" predicate:predicate];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"messageFrom"];
    [query includeKey:@"messageTo"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // NSLog(@"objects: %@", objects);
            
            //initialize arrays
            _messageFromArray = [NSMutableArray new];
            _messageToArray = [NSMutableArray new];
            _chatUsersList = [NSMutableArray new];
            _chatUsersNamesList = [NSMutableArray new];
            _chatUsersPFUsersList = [NSMutableArray new];
            _chatLastMessageArray = [NSMutableArray new];
            
            for (PFObject *object in objects) {
                // NSLog(@"messageFrom = %@", [[object objectForKey:@"messageFrom"] objectForKey:@"username"]);
                //NSLog(@"messageTo = %@", [[object objectForKey:@"messageTo"] objectId]);
                // NSLog(@"message = %@ \n\n", [object objectForKey:@"messageContent"]);
                
                
                
                // [_messageFromArray addObject:[[object objectForKey:@"messageFrom"] objectId]];
                // [_messageFromArray addObject:[[object objectForKey:@"messageTo"] objectId]];
                
                
                
                if ([[[object objectForKey:@"messageFrom"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    
                    
                    if (![_chatUsersList containsObject:[[object objectForKey:@"messageTo"] objectId]]) {
                        //add user to the list of chatters
                        [_chatUsersList addObject:[[object objectForKey:@"messageTo"] objectId]];
                        [_chatUsersNamesList addObject:[[object objectForKey:@"messageTo"] objectForKey:@"username"]];
                        [_chatUsersPFUsersList addObject:(PFUser *)[object objectForKey:@"messageTo"]];
                        [_chatLastMessageArray addObject:[object objectForKey:@"messageContent"]];
                    }
                    
                    
                    
                }
                
                else{
                    
                    if (![_chatUsersList containsObject:[[object objectForKey:@"messageFrom"] objectId]]) {
                        //add user to the list of chatters
                        [_chatUsersList addObject:[[object objectForKey:@"messageFrom"] objectId]];
                        [_chatUsersNamesList addObject:[[object objectForKey:@"messageFrom"] objectForKey:@"username"]];
                        [_chatUsersPFUsersList addObject:(PFUser *)[object objectForKey:@"messageFrom"]];
                        [_chatLastMessageArray addObject:[object objectForKey:@"messageContent"]];
                        
                        
                        
                    }
                    
                    // NSLog(@"chat users IDs list = %@", _chatUsersList);
                    //  NSLog(@"chat usernames list = %@", _chatUsersNamesList);
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
            }
            
            
            
        }
        
        else{
            
            NSLog(@"error retrieving messages");
        }
    
        
 
        
        
        _conversationReadUnreadBooleansArray = [[NSMutableArray alloc] init];
        
        
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
                                [_conversationReadUnreadBooleansArray addObject:[NSNumber numberWithBool:NO]];
                            }
                            else{
                                NSLog(@"read by user A = True");
                                //cell.usernameLabel.font = [UIFont systemFontOfSize:17.0];
                                [_conversationReadUnreadBooleansArray addObject:[NSNumber numberWithBool:YES]];
                                
                            }
                            
                            
                            
                            
                            
                        }
                        else{
                            
                            NSLog(@"current user is userB");
                            if ([[[objects objectAtIndex:0] objectForKey:@"readByUserB"]  isEqual: @NO]) {
                                [_conversationReadUnreadBooleansArray addObject:[NSNumber numberWithBool:NO]];
                            }
                            else{
                                
                                [_conversationReadUnreadBooleansArray addObject:[NSNumber numberWithBool:YES]];
                                
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
                
                [_messagesTable reloadData];
  
                
            }];
            
            
            //************
            
            
            
            
            
        }
        
        
        
        //[_messagesTable reloadData];
 
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //reload table data after data fetchibng is done
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


@end
