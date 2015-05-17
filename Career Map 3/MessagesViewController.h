//
//  MessagesViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/12/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MessageCell.h"
#import "JobChatViewController.h"

@interface MessagesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *messagesTable;
@property (strong, nonatomic) NSMutableArray *messageFromArray;
@property (strong, nonatomic) NSMutableArray *messageToArray;
//store users ids
@property (strong, nonatomic) NSMutableArray *chatUsersList;
@property (strong, nonatomic) NSMutableArray *chatUsersNamesList;
@property (strong, nonatomic) NSMutableArray *chatUsersPFUsersList;
@property (strong, nonatomic) NSMutableArray *chatLastMessageArray;



//methods
- (void) retrieveMessages;


@end
