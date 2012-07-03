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
#import "ChatView.h"
#import "Facebook.h"
#import "Session.h"
#import "ChatMessage.h"


@interface ViewController () {
    
}
- (void)   cbFacebookLogin;
@end

@implementation ViewController


- (IBAction) buttonDepressed : (id) sender
{
    return;
}

- (void) cbFacebookLogin
{
    [SVProgressHUD dismiss];
    [[AppContext getContext] sendListSessions];
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
                                @"picture",
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
                                @"picture",
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
    if ( [[AppContext getContext] loggedIn] == 1) 
        return;
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
    inSession = NO;
    [self setupFacebook];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Chat2Know"];
    [[AppContext getContext] setVc:self];
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

- (IBAction) clickFindChat : (id) sender
{
    if (inSession == NO) {
        return;
    }    
    NSMutableArray *sessions = [[AppContext getContext] activeSessions];
    for (Session *cSession in sessions) {
        if ([cSession.active boolValue] == YES) {
            for (NSString *user in cSession.users) {
                [[AppContext getContext] sessionID];
                if (![user isEqualToString:[[AppContext getContext] sessionID]]) {
                    /* do we want to autolaunch a session!? */
                    /* not totally sure */
                    [activity stopAnimating];
                    [self launchSession:cSession];
                    inSession = YES;
                    return;
                }
            }
        }
    }
    return;
}

- (void) launchSession : (Session *) session
{
    ChatView *chatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    [[AppContext getContext] setChatView:chatView];
    [chatView setSessionID:session.token];
    [self.navigationController pushViewController:chatView animated:YES];
    NSLog(@"Adding message");
    for (NSDictionary *message in session.messages) {
        NSLog(@"Message %@", message);
        ChatMessage *cMessage = [[ChatMessage alloc] init];
        cMessage.message = [message objectForKey:@"message"];
        cMessage.partnerId = [message objectForKey:@"sender"];
        [chatView addMessage:cMessage];
    }
    return;
}

- (void) cbSessionsLoaded 
{
    NSLog(@"Sessions have been loaded");
    NSMutableArray *sessions = [[AppContext getContext] activeSessions];
    NSLog(@"There are %i active sessions", [sessions count]);
    for (Session *cSession in sessions) {
        if ([cSession.active boolValue] == YES) {
            NSLog(@"We have an active session");
            NSLog(@"Session messages %@", cSession.messages);
            NSLog(@"Session users %@", cSession.users);
            for (NSString *user in cSession.users) {
                [[AppContext getContext] sessionID];
                if (![user isEqualToString:[[AppContext getContext] sessionID]]) {
                    NSLog(@"Partner is %@", user);
                    textChatTile.text = [NSString stringWithFormat:@"Session with %@", user];
                    /* do we want to autolaunch a session!? */
                    /* not totally sure */
                    [activity stopAnimating];
                    //[self launchSession:cSession];
                    inSession = YES;
                    return;
                }
            }
        }
    }
    
    NSLog(@"We if are here, we need to find an active session");    
    [activity startAnimating];
    textChatTile.text = @"You are currently searching for a chat partner";
    [[AppContext getContext] sendFindChat];
    return;
}

- (void) cbFoundChat : (NSString *) sessionID : (NSString *) partner
{
    [activity stopAnimating];
    ChatView *chatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    [[AppContext getContext] setChatView:chatView];
    [chatView setSessionID:sessionID];
    [self.navigationController pushViewController:chatView animated:YES];
    chatView.fieldName.text = [NSString stringWithFormat:@"Chatting with %@", partner];
    return;
}

@end
