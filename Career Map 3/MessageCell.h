//
//  MessageCell.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/12/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *userObjectIdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageCompanionImage;


@end
