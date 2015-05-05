//
//  LoadingJobListEmptyView.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/5/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "LoadingJobListEmptyView.h"

@implementation LoadingJobListEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"LoadingJobListEmptyView" owner:self options:nil];
        [self addSubview:self.mainView];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    }
    return self;
}


@end
