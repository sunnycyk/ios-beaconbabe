//
//  ViewController.m
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 18/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate> {
    NSString *ageRange;
    NSString *gender;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ageSegCtrl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegCtrl;
-(IBAction)register:(id)sender;
@end

@implementation ViewController
-(NSString *)selectAge {
    switch (self.ageSegCtrl.selectedSegmentIndex) {
        case 0: return  @"20 or under";
        case 1: return @"20 - 40";
        case 2: return @"40 or above";
    }
    return @"20-40"; // default
    
}

-(NSString *)selectGender {
    switch (self.genderSegCtrl.selectedSegmentIndex) {
        case 0: return  @"Male";
        case 1: return  @"Female";
    }
    
    return @"Male"; //default
}


/*
 TODO:
    Need to check for successfully register before locating beacon
*/
-(IBAction)register:(id)sender {
    NSURL *url = [NSURL URLWithString:@"some url"]; // replace URL
    
    NSString *postData = [NSString stringWithFormat:@"utf=%%E2%%9C%%93&key=key-to-access-API-server&ent_domain=beaconbabe&ent_qid=register&meta_event=beaconbabe&changes%%5Broot_namefolder_fullname%%5D=%@&changes%%5Broot_contactfolder_email%%5D=%@&changes%%5Broot_detailsfolder_age%%5D=%@&changes%%5Broot_detailsfolder_sex%%5D=%@",
                          self.nameTextField.text,  self.emailTextField.text,[self selectAge],[self selectGender]];
    
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
        if (httpResp.statusCode == 200) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:[[json valueForKeyPath:@"name"]objectForKey:@"fullname" ] forKey:@"Name"];
            [defaults setObject:[[json valueForKeyPath:@"contact"]objectForKey:@"email" ] forKey:@"Email"];
            [defaults setObject:[[json valueForKeyPath:@"demographic.age"]objectForKey:@"label" ] forKey:@"AgeRange"];
            [defaults setObject:[[json valueForKeyPath:@"demographic.sex"]objectForKey:@"label" ] forKey:@"Gender"];
            [defaults setObject:[[json valueForKeyPath:@"demographic.zodiac"]objectForKey:@"label" ] forKey:@"Zodiac"];
            [defaults setObject:[json objectForKey:@"card"] forKey:@"Card"];
            [defaults synchronize];
           
        
        }
        else {
            NSLog(@"%@",error);
        }
        
    }];
    [postDataTask resume];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
   
   // [self.ageRangeSegCtrl addTarget:self action:@selector(selectAge:)forControlEvents:UIControlEventValueChanged];
    //[self.genderSegCtrl addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventValueChanged];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    // Check if user already register in the app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *card = [defaults objectForKey:@"Card"];
    NSLog(@"%@", [card[0] objectForKey:@"uid"]);
    if ( [card[0] objectForKey:@"uid"] == nil) { // if user not registered
        NSLog(@"Not Registered");
    }
    else  {
        NSLog(@"Registered");
        [self performSegueWithIdentifier:@"activated" sender:self];
    }
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
