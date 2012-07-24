//
//  AppDelegate.h
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "FBConnect.h"

#import "ViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIAlertViewDelegate, UIApplicationDelegate, CLLocationManagerDelegate, FBSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ViewController *vc;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void) facebookSetup;

@end
