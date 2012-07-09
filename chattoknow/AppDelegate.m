//
//  AppDelegate.m
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "AppContext.h"
#import "SVProgressHUD.h"

@implementation AppDelegate
@synthesize vc;

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize locationManager;

- (void) facebookSetup
{
    Facebook *facebook;
    facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];
    [[AppContext getContext] setFacebook:facebook];
    [facebook extendAccessTokenIfNeeded];
    return;
}

- (void)fbDidLogin {
    Facebook *facebook =  [[AppContext getContext] facebook];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"We Logged in to facebook now what?");
    [[[AppContext getContext] vc] setupFacebook];
    
    return;
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    return;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *tempString = [NSString stringWithFormat:@"%@",deviceToken];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tempString = [tempString stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"Device Token %@", tempString);
    [[AppContext getContext] setApnsToken:tempString];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    Facebook *facebook =  [[AppContext getContext] facebook];
    return [facebook handleOpenURL:url]; 
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    Facebook *facebook =  [[AppContext getContext] facebook];
    return [facebook handleOpenURL:url]; 
}

- (void) fbSessionInvalidated
{
    return;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AppContext getContext] Setup];
    
    //Reset badge number
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //Initialize Location Manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];

    //Register for notifications
    UIRemoteNotificationType allowedNotifications = UIRemoteNotificationTypeAlert
    | UIRemoteNotificationTypeSound
    | UIRemoteNotificationTypeBadge;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:allowedNotifications];
    application.applicationIconBadgeNumber = 0;

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    navController.navigationBarHidden = YES;
    navController.navigationBar.barStyle = UIBarStyleBlack;

    self.window.rootViewController = navController;    
    //self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self facebookSetup];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.viewController.navigationController popToViewController:self.viewController animated:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[AppContext getContext] suspend];
    [self.viewController.navigationController popToViewController:self.viewController animated:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"Entered Foreground");
    //Reset badge number
    [[[AppContext getContext] vc] wake];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.viewController.navigationController popToViewController:self.viewController animated:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[AppContext getContext] reconnect];
    //Reset badge number
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.viewController.navigationController popToViewController:self.viewController animated:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


int last_time = 0;
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation { 

    [[AppContext getContext] updateLocation:
     [NSNumber numberWithFloat:newLocation.coordinate.latitude ] :
     [NSNumber numberWithFloat:newLocation.coordinate.longitude]];
    return;
#if 1
    if (time(0) - last_time > 120) {
        return;
    }
#endif

    
}

@end
