//
//  MatchedViewController.m
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 19/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//@

#import "MatchedViewController.h"
#import "DefinedBeacon.h"

@import CoreLocation;

@interface MatchedViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MatchedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[DefinedBeacon beaconUUID]];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[DefinedBeacon beaconRegionMajor:@"xyz"] minor:[DefinedBeacon beaconRegionMinor:@"xyz"] identifier:@"xyz"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        
        
        if (beacon.major.intValue == [DefinedBeacon beaconRegionMajor:@"xyz"] && beacon.rssi > -65 && beacon.rssi)  {
            NSLog(@"Shop view major: %@ minor: %@ rssi: %ld", beacon.major, beacon.minor , beacon.rssi);
            [self.locationManager stopMonitoringForRegion:self.beaconRegion];
            [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
            [self performSegueWithIdentifier:@"qrcode" sender:self];
        }
    }
}

@end
