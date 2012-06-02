//
//  ViewController.m
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "ViewController.h"
#import "AppContext.h"
#import "SVProgressHUD.h"

@interface ViewController () {
    
}
- (void)   cbFacebookLogin;
@end

@implementation ViewController


- (void) cbFacebookLogin
{
    [SVProgressHUD dismiss];
    return;
}

- (void)   setupFacebook {
    Facebook *facebook = [[AppContext getContext] facebook];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    } else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"user_relationships",
                                @"friends_relationships",
                                @"user_status",
                                @"email",
                                @"offline_access",
                                @"user_location",
                                @"user_interests",
                                @"user_photos",
                                @"user_about_me",
                                @"user_work_history",
                                nil];
        [facebook authorize:permissions];
        return;
    }
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"user_relationships",
                                @"friends_relationships",
                                @"user_status",
                                @"email",
                                @"user_location",
                                @"offline_access",
                                @"user_interests",
                                @"user_photos",
                                @"user_about_me",
                                @"user_work_history",
                                nil];
        [facebook authorize:permissions];
        return;
    }        
    /* if saved values were not found create a new user */
    [SVProgressHUD showWithStatus:@"Signing In"]; 
    NSLog(@"Token %@", [defaults objectForKey:@"FBAccessTokenKey"]);
    /* set the facebook token and attempt to login */
    [[AppContext getContext] setFacebookToken: [defaults objectForKey:@"FBAccessTokenKey"] ];
    //[[Network getContext] createUserWithFacebook_Node:[defaults objectForKey:@"FBAccessTokenKey"]];
    [[AppContext getContext] loginWithFacebook];
    return;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self setupFacebook];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Chat2Know"];
	// Do any additional setup after loading the view, typically from a nib.
    return;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
