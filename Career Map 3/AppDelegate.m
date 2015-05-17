//
//  AppDelegate.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 3/24/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "AppDelegate.h"
#import "JobChatViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //configure parse project
    [Parse setApplicationId:@"tlHTprDlMSewDUTLFD0IiXchTlAmG43nHKbPiOxD" clientKey:@"pEFQ3jdtGu7L9q3P13kfdX6pwZMp2i3e3M0bH9OV"];
    
    //creae an automatic user all the time
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] saveInBackground];
    
    
    //setup push notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge| UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    

    //check if opening the app is a result of remote notification
    _notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

    
    
    
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    // UIViewController* vc =
    
    
    
    // NSString *json = [localNotif valueForKey:@"data"];
    // Parse your string to dictionary
    


    if (_notificationPayload) {
    
      //  NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
       // NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
        
        
      //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:[notificationPayload objectForKey:@"message"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        //[alert show];
        
        
        
        
        //invoke the job chat view, but with the userIDs
        //JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
        //jobChatScreen.jobEmployerUserObjectID = [[notificationPayload valueForKey:@"otherPFUser"] objectForKey:@"objectId"];
       // jobChatScreen.jobPosterPFUser = [notificationPayload valueForKey:@"otherPFUser"];
      
       // [self.window makeKeyAndVisible];
       // [self.window.rootViewController presentViewController:jobChatScreen animated:YES completion:nil];

       // UIViewController *newRoot = jobChatScreen;
        //self.window.rootViewController = jobChatScreen;
        
        
      // [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:newRoot animated:YES completion:nil];
        

       // UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:jobChatScreen];
        //[self.window addSubview:navigationController.view];
        

        
        
        JobListViewController *jobListVC = (JobListViewController *)[sb instantiateViewControllerWithIdentifier:@"JobListViewController"];
        
        //change notification payload to view controller
        
        
        [jobListVC changeMessageIsReceivedValue];
        
 
        
        
    }
    
    

    
  
    
    
    return YES;
}


//MARK: push notifications methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    
    
    //save the user to parse installation table
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saving user to parse installation table succeeded");
        }
        
        else{
            NSLog(@"saving user to parse installation table FAILED");

            
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Error registering remote notification: %@", error.localizedDescription);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@" application status %li",(long)[application applicationState]);
    
    
    //if the application is running in the forground
    UIApplicationState state = [application applicationState];
    if (!(state == UIApplicationStateActive)) {
      
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message received"
                                                        message:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];*/
        
        
        //invoke the job chat view, but with the userIDs
        JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
        jobChatScreen.jobEmployerUserObjectID = [[userInfo valueForKey:@"otherPFUser"] valueForKey:@"objectId"];
        jobChatScreen.jobPosterPFUser = [userInfo valueForKey:@"otherPFUser"];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:jobChatScreen animated:YES completion:nil];
    }
    


    //update chat with latest message
    
    
    /*
    //Check if the chat view controller visible
    
    
    JobChatViewController  *jobChatScreen = [[JobChatViewController alloc] initWithNibName:@"JobChatView" bundle:nil];
    
    if (([jobChatScreen isViewLoaded] && jobChatScreen.view.window)) {
        
        NSLog(@"chat view is loaded");
    }
    else{
        
        NSLog(@"chat view is not loaded");
    }
    */
    
    //show an alert with content of push notif
    
    
    

    
    
     //[PFPush handlePush:userInfo];
    
    [[ NSNotificationCenter defaultCenter] postNotificationName:@"getLatestMessage" object:nil];
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
