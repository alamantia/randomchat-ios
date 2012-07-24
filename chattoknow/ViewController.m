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
#import "TrophyView.h"
#import "OptionsViewController.h"
#import "InfoViewController.h"
#import "FacebookDialog.h"
#import "AppDelegate.h"

@interface ViewController () {
    FacebookDialog *facebookDialog;
}

- (void)   cbFacebookLogin;

@end

@implementation ViewController

- (void) disableButtons 
{
    buttonChat.enabled = NO;
    buttonInfo.enabled = NO;
    buttonTrophy.enabled = NO;
    buttonOptions.enabled = NO;
    return;
}

- (void) enableButtons
{
    buttonChat.enabled    = YES;
    buttonInfo.enabled    = YES;
    buttonTrophy.enabled  = YES;
    buttonOptions.enabled = YES;
    return;
}
/* always poll */
- (void) listPoll 
{
    if (isShowing == YES) {
        [[AppContext getContext] sendListSessions];
    }
    [self performSelector:@selector(listPoll) withObject:nil afterDelay:10];
    return;
}

- (IBAction) buttonDepressed : (id) sender
{
    return;
}

- (void) cbFacebookLogin
{
    if (facebookDialog != nil) {
        [facebookDialog dismissModalViewControllerAnimated:YES];
    }
    [SVProgressHUD dismiss];
    [[AppContext getContext] sendListSessions];
    return;
}

- (void)   setupFacebook {
    NSLog(@"Facebook SETUP");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *facebook = [[AppContext getContext] facebook];
    if (facebook == nil) {
        facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:appDelegate];
        [[AppContext getContext] setFacebook:facebook];
        [facebook extendAccessTokenIfNeeded];
    }
    facebook = [[AppContext getContext] facebook];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    } else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
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

- (void) wake
{
    [SVProgressHUD showWithStatus:@"Loading"];
}

- (void) viewWillAppear:(BOOL)animated
{
    return;
}

- (void) viewDidAppear:(BOOL)animated
{
    inSession = NO;
    isLaunching = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]  == nil) {
        facebookDialog  = [[FacebookDialog alloc] initWithNibName:@"FacebookDialog" bundle:nil];
        [self presentModalViewController:facebookDialog animated:YES];
        return;
    }
    [self setupFacebook];
    [SVProgressHUD showWithStatus:@"Loading"];
    [[AppContext getContext] sendListSessions];
    isShowing = YES;
    [self disableButtons];
    [self listPoll];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    isShowing = NO;
    return;
}

- (void)viewDidLoad
{
    isShowing = NO;
    facebookDialog = nil;
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Chat2Know"];
    [[AppContext getContext] setVc:self];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create a view of the standard size at the bottom of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a14ff48dbd41ba6";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [adView addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    GADRequest *request = [GADRequest request];
    request.testing = YES;
    [bannerView_ loadRequest:request];

    
    return;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return NO;
    return YES;
}


- (IBAction) clickFindChat : (id) sender
{
#if 0
    if (inSession == NO) {
        return;
    }
#endif
    [self disableButtons];
    [SVProgressHUD showWithStatus:@"Loading"];
    NSMutableArray *sessions = [[AppContext getContext] activeSessions];
    for (Session *cSession in sessions) {
        if ([cSession.active boolValue] == YES) {
            for (NSString *user in cSession.users) {
                [[AppContext getContext] sessionID];
                if (![user isEqualToString:[[AppContext getContext] sessionID]]) {
                    /* do we want to autolaunch a session!? */
                    /* not totally sure */
                    [activity stopAnimating];
                    isLaunching = YES;
                    launchingSessionToken = cSession.token;
                    inSession = YES;
                    [[AppContext getContext] sendListSessions];
                    return;
                }
            }
        }
    }
    return;
}

- (void) launchSession : (Session *) session : (BOOL) hasVoted
{
    ChatView *chatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    [[AppContext getContext] setChatView:chatView];    
    [chatView setSessionID:session.token];

    for (NSString *user in session.users) {
        if (![user isEqualToString:[[AppContext getContext] sessionID]]) {
            NSString *partnerName = @""; 
            if ([ user isEqualToString:[session.user_1 objectForKey:@"token"]]) {
                partnerName = [session.user_1 objectForKey:@"user_name"];
            } else {
                partnerName = [session.user_2 objectForKey:@"user_name"];
            }
            chatView.fieldName.text = [NSString stringWithFormat:@"Chatting with %@", partnerName];
            chatView.partnerName = partnerName;
        }
    }
    
    [self.navigationController pushViewController:chatView animated:YES];
    for (NSDictionary *message in session.messages) {
        NSLog(@"Message %@", message);
        ChatMessage *cMessage = [[ChatMessage alloc] init];
        cMessage.message = [message objectForKey:@"message"];
        cMessage.partnerId = [message objectForKey:@"sender"];
        [chatView addMessage:cMessage];
    }
    
    int linesLeft = [session.lines_max intValue] - [session.lines intValue];
    
    if (linesLeft <= 0) {
        linesLeft = 0;
        [chatView setLinesLeft:linesLeft];
        chatView.labelLines.text =  [NSString stringWithFormat:@"You can now vote!"];
    } else {
        [chatView setLinesLeft:linesLeft];
        chatView.labelLines.text =  [NSString stringWithFormat:@"%i lines until you can vote", linesLeft];
    }
    for (NSString *user in session.users) {
        if (![user isEqualToString:[[AppContext getContext] sessionID]]) {
            NSLog(@"22 Partner is %@", user);
            NSString *partnerName = @""; 
            if ([ user isEqualToString:[session.user_1 objectForKey:@"token"]]) {
                partnerName = [session.user_1 objectForKey:@"user_name"];
            } else {
                partnerName = [session.user_2 objectForKey:@"user_name"];
            }
            NSLog(@"22 Chatting With %@", partnerName);
            chatView.fieldName.text = [NSString stringWithFormat:@"Chatting with %@", partnerName];
            chatView.partnerName = partnerName;
        }
    }
    chatView.hasVoted = hasVoted;
    if (hasVoted == YES) {
        chatView.buttonExit.hidden = NO;
        chatView.buttonVote.hidden = YES;
        chatView.labelLines.text = @"Vote submitted";
    }
    isLaunching = NO;
    return;
}

- (void) cbSessionsLoaded 
{
    bool hasVoted = NO;
    NSLog(@"Sessions have been loaded");
    NSMutableArray *sessions = [[AppContext getContext] activeSessions];
    NSLog(@"There are %i active sessions", [sessions count]);
    for (Session *cSession in sessions) {
        hasVoted = NO;
        if ([cSession.active boolValue] == YES) {
            NSLog(@"We have an active session");
            NSLog(@"Session messages %@", cSession.messages);
            NSLog(@"Session users %@", cSession.users);
            /* if we have voted conintue */
            if ([cSession.vote_1_id isEqualToString:[[AppContext getContext] sessionID]]) {
                NSLog(@"WE were vote 1");
                if ([cSession.vote_1 intValue] != 1)
                    continue;
                hasVoted = YES;
            } else if ([cSession.vote_2_id isEqualToString:[[AppContext getContext] sessionID]]) {
                if ([cSession.vote_1 intValue] != 1)
                    continue;
                hasVoted = YES;
            }
            
            if ([cSession.left_1 isEqualToString:[[AppContext getContext] sessionID]]) {
                continue;
            }
            
            if ([cSession.left_2 isEqualToString:[[AppContext getContext] sessionID]]) {
                continue;
            }

            for (NSString *user in cSession.users) {
                [[AppContext getContext] sessionID];
                if (![user isEqualToString:[[AppContext getContext] sessionID]]) {
                    NSLog(@"Partner is %@", user);
                    NSString *partnerName = @""; 
                    if ([ user isEqualToString:[cSession.user_1 objectForKey:@"token"]]) {
                        partnerName = [cSession.user_1 objectForKey:@"user_name"];
                    } else {
                        partnerName = [cSession.user_2 objectForKey:@"user_name"];
                    }
                    textChatTile.text = [NSString stringWithFormat:@"Session with %@", partnerName];
                    /* do we want to autolaunch a session!? */
                    /* not totally sure */
                    [activity stopAnimating];    
                    if (isLaunching == YES) {
                        [self launchSession:cSession:hasVoted];
                    }
                    inSession = YES;
                    [SVProgressHUD dismiss];
                    [self enableButtons];

                    return;
                }
            }
        }
    }
    
    NSLog(@"We if are here, we need to find an active session");    
    [activity startAnimating];
    textChatTile.text = @"You are currently searching for a chat partner";
    [[AppContext getContext] sendFindChat];
    [SVProgressHUD dismiss];
    [self enableButtons];
    return; 
}

- (void) Update
{
    [[AppContext getContext] sendListSessions];
    return;
}

- (void) cbFoundChat : (NSString *) sessionID : (NSString *) partner
{
    [[AppContext getContext] sendListSessions];
    return;

    [activity stopAnimating];
    ChatView *chatView = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    [[AppContext getContext] setChatView:chatView];
    [chatView setSessionID:sessionID];
    [self.navigationController pushViewController:chatView animated:YES];
    chatView.fieldName.text = [NSString stringWithFormat:@"Chatting with %@", partner];
    chatView.partnerName = partner;
    return;
}

- (IBAction) clickTrophy : (id) sender
{
    tv = [[TrophyView alloc] initWithNibName:@"TrophyView" bundle:nil];
    [self.navigationController pushViewController:tv animated:YES];

    return;
}

- (IBAction) clickOptions : (id) sender
{
    NSLog(@"Options clicked");
    OptionsViewController *ovc = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
    [self.navigationController pushViewController:ovc animated:YES];
    return;
}

- (IBAction) clickInfo : (id) sender
{
    InfoViewController *ivc = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    [self.navigationController pushViewController:ivc animated:YES];
    return;
}

@end
