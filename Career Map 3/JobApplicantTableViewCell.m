//
//  JobApplicantTableViewCell.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 6/9/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "JobApplicantTableViewCell.h"

@implementation JobApplicantTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _jobCandidateThumb.layer.cornerRadius = _jobCandidateThumb.frame.size.width/2;
    _jobCandidateThumb.clipsToBounds = YES;

    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
