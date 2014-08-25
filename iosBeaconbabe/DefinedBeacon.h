//
//  DefinedBeacon.h
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 19/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface DefinedBeacon : NSObject
+ (CLBeaconMajorValue) beaconRegionMajor:(NSString *)key;
+(CLBeaconMinorValue)beaconRegionMinor:(NSString *)key;
+(NSString *) beaconUUID;
@end
