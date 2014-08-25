//
//  ShopViewController.m
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 19/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

#import "ShopViewController.h"
#import "DefinedBeacon.h"
#import "DealOfferViewController.h"
@import CoreLocation;

@interface ShopViewController ()<UIAlertViewDelegate, CLLocationManagerDelegate, DealOfferDelegate>
{
    BOOL isShowingHidden;
    BOOL shouldShouldXYZ;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@end

@implementation ShopViewController

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
    isShowingHidden = NO;
    shouldShouldXYZ = NO;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[DefinedBeacon beaconUUID]];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[DefinedBeacon beaconRegionMajor:@"hidden"] minor:[DefinedBeacon beaconRegionMinor:@"hidden"] identifier:@"hidden"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void) findMatch {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Match Found" message:@"Go to XYZ to meet your babe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


-(void) sellBeef{
    /*UILocalNotification *notification = [[UILocalNotification alloc] init];
     notification.alertBody = @"Matched Found! Show QR Code";
     notification.soundName = @"Default";
     [[UIApplication sharedApplication] presentLocalNotificationNow:notification];*/
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offer Found" message:@"Do you want to buy beef?" delegate:self cancelButtonTitle:@"View Offer" otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Offer Found"]) {
        [self performSegueWithIdentifier:@"offer" sender:self];
    }
    else if ([alertView.title isEqualToString:@"Match Found"]) {
        [self performSegueWithIdentifier:@"match" sender:self];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"offer"]) {
        DealOfferViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
    }
}


-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
      
        
       if (beacon.major.intValue == self.beaconRegion.major.intValue && beacon.rssi > -65 && beacon.rssi)  {
           if (!isShowingHidden) { // show offer
                NSLog(@"Shop view major: %@ minor: %@ rssi: %ld", beacon.major, beacon.minor , beacon.rssi);
               isShowingHidden = YES;
               [self sellBeef];
           }
       }
    }
}

#pragma  mark - DealOfferDelegate
-(void) didSelectNo {
    
}

-(void) didSelectYes {
    // accept deal
    // start polling
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                                    selector:@selector(checkServer:) userInfo:nil repeats:YES];
}

-(void)checkServer:(NSTimer*)theTimer {
    NSArray *card = [[NSUserDefaults standardUserDefaults] objectForKey:@"Card"];
    NSURL *url = [NSURL URLWithString:@"Some URL For Check in"];
    NSString *uid = [card[0] objectForKey:@"uid"];
    NSString *postData = [NSString stringWithFormat:@"key=key-to-access-API-server&member_reg_id=%@&beacon_uuid=%@&beacon_major=%@&beacon_minor=%@", uid, self.beaconRegion.proximityUUID, self.beaconRegion.major, self.beaconRegion.minor];
                          
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
            if ([json objectForKey:@"records"] > 0) {
                [self findMatch];
                [theTimer invalidate]; // clear timer
                [self.locationManager stopMonitoringForRegion:self.beaconRegion];
                [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
            }
            
            
        }
        else {
            NSLog(@"%@",error);
        }
    }];
    [postDataTask resume];
   /* [self findMatch];
    [theTimer invalidate];
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];*/

}
@end
