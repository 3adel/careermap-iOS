//
//  AppHorizontalMessage.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 4/27/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppHorizontalMessage : UIView

@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UIView *mainView;
- (void)showWithMessageAutoHide: (NSString *) message withColor: (UIColor *) color;
- (void)showMessage:(NSString *)message withColor: (UIColor *) color;
- (void)hideMessage;
@end


