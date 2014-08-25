//
//  BeaconViewController.m
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 18/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

#import "BeaconViewController.h"
#import "DefinedBeacon.h"

@import CoreLocation;

@interface BeaconViewController () <UIAlertViewDelegate, CLLocationManagerDelegate> {
    BOOL isShowingDoor;
}
@property (weak, nonatomic) IBOutlet UIView *flashView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@end

@implementation BeaconViewController

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
    self.locationManager  = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    isShowingDoor = NO;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[DefinedBeacon beaconUUID]];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[DefinedBeacon beaconRegionMajor:@"door"] minor:[DefinedBeacon beaconRegionMinor:@"door"] identifier:@"door"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.flashView.alpha = 1.0f;
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionRepeat |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.flashView.alpha = 0.5f;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self performSegueWithIdentifier:@"door" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        NSLog(@"Enter Region");
      //  [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        NSLog(@"Beacon View major: %@ minor: %@ rssi: %ld", beacon.major, beacon.minor , beacon.rssi);
        
        if (!isShowingDoor && beacon.major.intValue == self.beaconRegion.major.intValue && beacon.rssi > -65 && beacon.rssi)  {
                // App should send data to server that user has entered the shop
            NSArray *card = [[NSUserDefaults standardUserDefaults] objectForKey:@"Card"];
            NSURL *url = [NSURL URLWithString:@"Some URL For Check in"];
            NSString *uid = [card[0] objectForKey:@"uid"];
            NSString *postData = [NSString stringWithFormat:@"key=key-to-access-API-server&member_reg_id=%@&beacon_uuid=%@&beacon_major=%@&beacon_minor=%@", uid ,beacon.proximityUUID, beacon.major, beacon.minor];
            
            postData = [postData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfiguration.HTTPAdditionalHeaders = @{
                                                           @"Content-Type": @"application/x-www-form-urlencoded"
                                                           
                                                           };
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            request.HTTPBody = [postData dataUsingEncoding:NSUTF8StringEncoding];
            request.HTTPMethod = @"POST";
            NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                // The server answers with an error because it doesn't receive the params
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                NSLog(@"%ld", httpResp.statusCode);
                if (httpResp.statusCode == 200) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSLog(@"%@", json);
                    
                }
            }];
            [postDataTask resume];

            
            isShowingDoor = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"Welcome to the SHOP" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
