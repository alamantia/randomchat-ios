//
//  AppContext.m
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "AppContext.h"
#import "ViewController.h"
#import "ChatMessage.h"

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
@synthesize user_name;
@synthesize apnsToken;
@synthesize chatView;
@synthesize chatSessions;
@synthesize loggedIn;
@synthesize  vc;

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
    self.apnsToken = @"";
    loggedIn = 0;
    [self reconnect];
    return;
}

- (void)reconnect
{
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = [[SRWebSocket alloc] initWithSocketIO:@"192.168.1.142:81"];
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
    [wsPayload setObject:self.apnsToken forKey:@"apnsToken"];    
    [wsPayload setObject:self.user_name forKey:@"user_name"];    
    [_webSocket sendEvent:@"login_facebook" : wsPayload];
    return;
}

- (void) loginWithFacebook
{
    [facebookEngine scrapeUserProfile];
    return;
}

/* send an updated profile */
/* when the apns token or facebook token changes */

- (void) sendUpdatedProfile
{
    NSLog(@"Updating backend profile");
    return;
}

- (void) sendAuth 
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    
    [_webSocket sendEvent:@"auth" : wsPayload];
    return;
}

- (void) sendChat : (NSString *)_sessionID  : (NSString *) _message
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [wsPayload setObject:_message forKey:@"text"];
    [wsPayload setObject:_sessionID forKey:@"sessionID"];
    [_webSocket sendEvent:@"chat" : wsPayload];
    return;
}

- (void) sendFindChat 
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [_webSocket sendEvent:@"find_chat" : wsPayload];
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
    if ([name isEqualToString:@"login"]) {
        /* login success! */
        NSDictionary *elm = [event objectAtIndex:0];
        NSString *_sessionID = [elm objectForKey:@"session"];
        self.sessionID = _sessionID;
        [self.vc cbFacebookLogin];
        self.loggedIn = 1;
        return;
    }
    
    if ([name isEqualToString:@"chatHistory"]) {
        NSLog(@"received the history of a chat session");
    }

    if ([name isEqualToString:@"chat"]) {
        NSDictionary *elm = [event objectAtIndex:0];

        /* New chat received */
        NSString *_text = [elm objectForKey:@"text"];
        NSString *_senderName = [elm objectForKey:@"sender_name"];
        NSString *_senderId = [elm objectForKey:@"sender_id"];
        NSString *_chatSessionId = [elm objectForKey:@"chat_session"];
        
        ChatView *cv = [[AppContext getContext] chatView];
        if ([_chatSessionId isEqualToString:cv.sessionID]) {
            ChatMessage *newMessage = [[ChatMessage alloc] init];
            newMessage.sessionID = _chatSessionId;
            newMessage.partnerName = _senderName;
            newMessage.partnerId = _senderId;
            newMessage.message = _text;
            [cv addMessage:newMessage];
        }
        NSLog(@"Incomming from (%@)", _senderName);
        NSLog(@"Incomming id (%@)",   _senderId);
        NSLog(@"Incomming chat (%@)", _text);
        NSLog(@"Incomming chat session (%@)", _chatSessionId);
            
        
    }

    if ([name isEqualToString:@"found_chat"]) {
        NSDictionary *elm = [event objectAtIndex:0];
        NSString *_sessionID = [elm objectForKey:@"session"];
        NSString *_partnerName = [elm objectForKey:@"partner"];
        [self.vc cbFoundChat:_sessionID:_partnerName];
    }

    
}
@end
