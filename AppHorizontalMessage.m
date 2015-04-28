//
//  AppHorizontalMessage.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/27/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "AppHorizontalMessage.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppHorizontalMessage


- (id)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"AppHorizontalMessageView" owner:self options:nil];
        [self addSubview:self.mainView];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.f);

    }
    return self;
}


- (void)showWithMessageAutoHide:(NSString *)message withColor:(UIColor *)color{
    
    self.backgroundColor = color;
    self.textLabel.text = message;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.alpha = 0.8f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.8f delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            self.alpha = 0;
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
    }];
}

//message with no autohide
- (void)showMessage:(NSString *)message withColor:(UIColor *)color{
    
    self.backgroundColor = color;
    self.textLabel.text = message;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.alpha = .8f;
    } completion:nil];
}


//hide message
- (void)hideMessage{
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}


@end
