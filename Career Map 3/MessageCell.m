//
//  MessageCell.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/12/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
    
    _messageCompanionImage.layer.cornerRadius = _messageCompanionImage.frame.size.width/2;
    _messageCompanionImage.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
