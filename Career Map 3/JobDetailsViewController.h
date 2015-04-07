//
//  JobDetailsViewController.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/7/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (nonatomic, strong) NSString *jobTitle;
@end
