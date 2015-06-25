//
//  ChatView.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/15/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JobChatMessageCell.h"
#import "MessagesViewController.h"
#import "DateConverter.h"
#import "MBProgressHUD.h"

@interface JobChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dockViewHightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;




@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet JobChatMessageCell *chatMessageCellOutlet;

//hold the value of the employer objID temporarily. This will be used to extract the job poster ID
@property (nonatomic, strong) NSString *employerID;
@property (nonatomic, strong) NSString *jobEmployerUserObjectID;
@property (nonatomic, strong) PFUser *jobPosterPFUser;
@property (weak, nonatomic) IBOutlet UINavigationItem *jobChatNavigationItem;

//@property (weak, nonatomic) IBOutlet UIView *jobChatView;
@property (weak, nonatomic) IBOutlet UITableView *jobChatTable;
@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *blockUserButton;
@property (nonatomic, strong) MBProgressHUD *HUDProgressIndicator;
@property (nonatomic, strong) PFFile *userProfileThumbFile;







- (IBAction)blockUserButtonPressed:(UIBarButtonItem *)sender;




- (IBAction)sendButtonPressed:(UIButton *)sender;
- (IBAction)closeJobChatButtonPressed:(UIBarButtonItem *)sender;
- (void) markConversationAsRead;

@end
