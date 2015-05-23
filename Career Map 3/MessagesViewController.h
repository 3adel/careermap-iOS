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
#import "MBProgressHUD.h"


@interface MessagesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *messagesTable;
@property (strong, nonatomic) NSMutableArray *messageFromArray;
@property (strong, nonatomic) NSMutableArray *messageToArray;
//store users ids
@property (strong, nonatomic) NSMutableArray *chatUsersList;
@property (strong, nonatomic) NSMutableArray *chatUsersNamesList;
@property (strong, nonatomic) NSMutableArray *chatUsersPFUsersList;
@property (strong, nonatomic) NSMutableArray *chatLastMessageArray;
@property (strong, nonatomic) NSMutableArray *UnreadMessagesCountBooleansArray;
@property (nonatomic, strong) NSMutableDictionary *conversationReadUnreadBooleansDictonary;
@property (nonatomic, strong) NSMutableArray *usersWhoBlockedMeList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *noMessagesYetView;
@property (nonatomic, strong) MBProgressHUD *HUDProgressIndicator;



//methods
- (void) retrieveMessages;
- (void) refreshMessages;
- (IBAction)refreshMessagesListButton:(UIButton *)sender;
- (void) getPFUsersWhoBlockedMe;
@end
