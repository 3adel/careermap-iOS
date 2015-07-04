//
//  ConnectivityCheck.m
//  InternetConnectivityCheck
//
//  Created by Adel  Shehadeh on 7/4/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "ConnectivityCheck.h"

@implementation ConnectivityCheck


+ (BOOL) ConnectivityStatus{
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
    
    return NO ;
}



@end
