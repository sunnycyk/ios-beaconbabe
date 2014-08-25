//
//  DealOfferViewController.h
//  iosBeaconbabe
//
//  Created by Sunny Cheung on 19/8/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DealOfferDelegate <NSObject>
-(void)didSelectYes;
-(void)didSelectNo;


@end

@interface DealOfferViewController : UIViewController
@property (weak, nonatomic) id<DealOfferDelegate> delegate;
@end
