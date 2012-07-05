//
//  FacebookEngine.m
//  chattoknow
//
//  Created by anthony lamantia on 5/30/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//
//http://developers.facebook.com/docs/reference/api/
#import "FacebookEngine.h"
#import "AppContext.h"

@implementation FacebookEngine

- (id) init
{
    self = [super init];
    return self;
}

- (void) reAuth
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    if ([defaults objectForKey:@"FBAccessTokenKey"] != nil) {
        
    }
    /* they need to authroize facebook! */
    Facebook *facebook = [[AppContext getContext] facebook];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"user_relationships",
                                @"friends_relationships",
                                @"user_status",
                                @"email",
                                @"offline_access",
                                nil];
        [facebook authorize:permissions];
        return;
    }    
    return;
}

/* grabs information from the current users profile */
- (void) scrapeUserProfile
{
    [self reAuth];
    Facebook *facebook = [[AppContext getContext] facebook];
    requestMode = FB_MODE_CURRENT_PROFILE;
    NSLog(@"Starting current user profile scrape");
    //http://stackoverflow.com/questions/10489494/facebook-ios-sdk
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,email,first_name, picture",@"fields",nil];
   [facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
    return;
}

- (void)requestLoading:(FBRequest *)request
{
    NSLog(@"Facebook request is loading");
    return;
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did load facebook did recv");
    return;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Did load facebook did fail");
    return;
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"Facebook request did load");
    NSLog(@"Facebook Reply\n%@", result);
    /* usually done before the inital authentication request */
    if (requestMode == FB_MODE_CURRENT_PROFILE)
    {
        NSString *email     = [result objectForKey:@"email"];
        NSString *name      = [result objectForKey:@"name"];
        NSString *fbID      = [result objectForKey:@"id"];
        NSString *picture   = [result objectForKey:@"picture"];
        NSString *user_name = [result objectForKey:@"first_name"];

        [[AppContext getContext] setFacebookID:fbID];
        [[AppContext getContext] setFacebookName:user_name];
        [[AppContext getContext] setFacebookPicture:picture];
        [[AppContext getContext] setEmailAddress:email];
        [[AppContext getContext] setUser_name:user_name];

        //loginWithFacebook_2
        [[AppContext getContext] loginWithFacebook_2];
        
        /* we should now be able to login */
        requestMode = FB_MODE_NONE;
        return;
    }
    return;
}

@end
