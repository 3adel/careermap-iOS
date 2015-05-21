//
//  JobChatMessageCell.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/15/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobChatMessageCell.h"

@implementation JobChatMessageCell

- (void)awakeFromNib {
    // Initialization code

    // Some style setup.
    self.messageContentTextView.layer.cornerRadius=5.0f;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
