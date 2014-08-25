//
//  AppDelegate.m
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 18/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

#import "AppDelegate.h"
//#import "DefinedBeacon.h"
//@import CoreLocation;

@interface AppDelegate() 
//@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   /* self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[DefinedBeacon beaconUUID]];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"beaconbabe"];
    // [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];*/
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/*
#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSLog(@"AppDelegate: Enter Region major: %d minor: %d", beaconRegion.major.intValue, beaconRegion.minor.intValue);
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [manager startRangingBeaconsInRegion:beaconRegion];
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"AppDelegate: Exit Region");
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [manager stopRangingBeaconsInRegion:(CLBeaconRegion *) region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    for (CLBeacon *beacon in beacons) {
        NSLog(@"AppDelegate @door");
        if (beacon.major.intValue == [DefinedBeacon beaconRegionMajor:@"door"] && beacon.rssi > -65 && beacon.rssi)  {
            // close to the door
            NSLog(@"AppDelegate @door");
           [manager stopRangingBeaconsInRegion:region]; // stop ranging region
            
            
        }
    }
    
}*/






@end
