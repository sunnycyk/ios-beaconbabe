//
//  DefinedBeacon.m
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 19/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

#import "DefinedBeacon.h"

@implementation DefinedBeacon

+(CLBeaconMajorValue)beaconRegionMajor:(NSString *)key {
    
    if ([key isEqualToString:@"door"]) {
        return 19955;
    }
    else if ([key isEqualToString:@"hidden"]) {
        return 47617;
    }
    else if ([key isEqualToString:@"xyz"]) {
        return 13746;
    }
    
    return 0;
    
}

+(CLBeaconMinorValue)beaconRegionMinor:(NSString *)key {
    
    if ([key isEqualToString:@"door"]) {
        return 12323;
        
    }
    else if ([key isEqualToString:@"hidden"]) {
        return 24186;
    }
    else if ([key isEqualToString:@"xyz"]) {
        return 7878;
    }
    
    return 0;
    
}

+(NSString *)beaconUUID {
    return @"f7826da6-4fa2-4e98-8024-bc5b71e0893e";
}
@end
