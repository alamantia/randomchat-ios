//
//  AppContext.m
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "AppContext.h"

static AppContext *sharedMyManager = nil;

@implementation AppContext
@synthesize sessionID;
@synthesize delegate;
@synthesize facebook;
@synthesize facebookID;
@synthesize facebookToken;
@synthesize facebookEngine;
@synthesize facebookPicture;
@synthesize emailAddress;
@synthesize facebookName;

+ (id)getContext {
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager                 = [[self alloc] init];
    }
    return sharedMyManager;
}

- (void) onTimer 
{
    [self sendPing];
    [self performSelector:@selector(onTimer) withObject:nil afterDelay:5];
    return;
}

- (void) Setup
{
    facebookEngine = [[FacebookEngine alloc] init];
    sessionID = @"DEADBEEF";
    [self reconnect];
    return;
}

- (void)reconnect
{
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = [[SRWebSocket alloc] initWithSocketIO:@"127.0.0.1:81"];
    _webSocket.delegate = self;    
    return;
}

- (void)open
{
    [self reconnect];
    return;
}

- (void)close
{
    return;
}

- (void)send:(id)data
{
    return;
}

/* the scraped information should be loaded actually try to login */
- (void) loginWithFacebook_2
{
    NSLog(@"Performing the next step of the facebook login process");
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [wsPayload setObject:self.facebookID forKey:@"facebookID"];
    [wsPayload setObject:self.facebookToken forKey:@"facebookToken"];
    [wsPayload setObject:self.facebookName forKey:@"facebookName"];
    [wsPayload setObject:self.facebookPicture forKey:@"facebookPicture"];
    [wsPayload setObject:self.emailAddress forKey:@"emailAddress"];    
    [_webSocket sendEvent:@"login_facebook" : wsPayload];
    return;
}

- (void) loginWithFacebook
{
    [facebookEngine scrapeUserProfile];
    return;
}

- (void) sendAuth 
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [_webSocket sendEvent:@"auth" : wsPayload];
    return;
}

/* send a point with the needed sessionID */
- (void) sendPing 
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [_webSocket sendEvent:@"ping" : wsPayload];
    return;
}

/* WebSocket delegates */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"--  websocket opened");
    [self sendAuth];
    [self onTimer];
    return;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"--  websocket Failed With Error %@", error);
    [self open];
    return;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"--- websocket closed");
    [self open];
    return;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    return;
}

- (void) webSocket:(SRWebSocket *)webSocket didReceiveEvent:(id) event name:(NSString *)name
{
    NSLog(@"-- WebSocket socketIO event (%@)", name);
    if ([name isEqualToString:@"auth"]) {
        NSDictionary *elm = [event objectAtIndex:0];
        NSString *_sessionID = [elm objectForKey:@"token"];
        self.sessionID = _sessionID;
    }
}
@end
