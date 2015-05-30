//
//  AddressLineConverter.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/30/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "AddressLineConverter.h"

@implementation AddressLineConverter


- (NSString *) convertLocationToAddress: (CLLocation *) location{
    
    
    __block NSString *addressFromBlock = @"";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            
            CLPlacemark *placemark = [placemarks lastObject];
            if ([[placemarks lastObject] locality] != nil ) {

                //add the address line as a component
                NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
                NSString *addressString = [lines componentsJoinedByString:@"\n"];
                NSLog(@"Address: %@", addressString);
                addressFromBlock = addressString;
                
            }
            else{
                NSLog(@"no address found");
                addressFromBlock = @"No address found";


                
            }
            
            
        }
        
        else{
            
            NSLog(@"Error = %@", error);
            // cell.jobArea.text =@"-";
        }
        
    }];
    
    return @"";
}



@end
