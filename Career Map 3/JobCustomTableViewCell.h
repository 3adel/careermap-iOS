//
//  JobCustomTableViewCell.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobEmployer;
@property (weak, nonatomic) IBOutlet UILabel *jobStatus;
@property (weak, nonatomic) IBOutlet UILabel *jobDateAdded;

@property (weak, nonatomic) IBOutlet UILabel *jobDistanceFromUser;
@property (weak, nonatomic) IBOutlet UIButton *jobVoteUpButton;
@property (weak, nonatomic) IBOutlet UIButton *jobVoteDownButton;

@property (weak, nonatomic) IBOutlet UILabel *jobVoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobVoteUpFlag;

@end
