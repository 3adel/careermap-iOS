//
//  ConnectivityCheck.h
//  InternetConnectivityCheck
//
//  Created by Adel  Shehadeh on 7/4/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//


//A singleton to check for internet connection status

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ConnectivityCheck : NSObject

+ (BOOL) ConnectivityStatus;


@end
