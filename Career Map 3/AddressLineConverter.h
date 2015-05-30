//
//  AddressLineConverter.h
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/30/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressLineConverter : NSObject <MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *addressLine;

- (NSString *) convertLocationToAddress: (CLLocation *) location;

@end
