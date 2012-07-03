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
#import "Session.h"

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
@synthesize  activeSessions;

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
    activeSessions = [[NSMutableArray alloc] init];
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
    _webSocket = [[SRWebSocket alloc] initWithSocketIO:@"player2.mobi:8080"];
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

- (void) loginWithToken
{
    
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

- (void) sendListSessions
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [_webSocket sendEvent:@"list_sessions" : wsPayload];
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

- (void) sendVote :(NSString *) value:  (NSString *) chatSession 
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [wsPayload setObject:value forKey:@"vote"];
    [wsPayload setObject:chatSession forKey:@"session"];
    [_webSocket sendEvent:@"vote" : wsPayload];
    return;
}

- (void) sendEnd : (NSString *) chatSession 
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [wsPayload setObject:chatSession forKey:@"session"];
    [_webSocket sendEvent:@"end_session" : wsPayload];
    return;
}

- (void) voteChatSession  
{
    NSMutableDictionary *wsPayload = [[NSMutableDictionary alloc] init];
    [wsPayload setObject:self.sessionID forKey:@"token"];
    [_webSocket sendEvent:@"ping" : wsPayload];
    return;
}

/* this should actually load the current history of the sesion as well */
- (void) loadSessions : (NSArray *) sessionsArray
{
    [activeSessions removeAllObjects];
    /* build up the active sessions list */
    for (NSDictionary *session in sessionsArray) {
        Session *newSession = [[Session alloc] init];
        [newSession buildFromDict:session];
        [activeSessions addObject:newSession];
    }
    [self.vc cbSessionsLoaded];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    

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
        [defaults setObject:_sessionID forKey:@"token"];
        [self.vc cbFacebookLogin];
        self.loggedIn = 1;
        [defaults synchronize];
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
        
        NSString *_active = [elm objectForKey:@"active"];
        NSString *_auto = [elm objectForKey:@"auto"];
        NSDecimalNumber *_lines = [elm objectForKey:@"lines"];
        NSDecimalNumber *_lines_max = [elm objectForKey:@"lines_max"];
        
        ChatView *cv = [[AppContext getContext] chatView];
        if ([_chatSessionId isEqualToString:cv.sessionID]) {
            ChatMessage *newMessage = [[ChatMessage alloc] init];
            newMessage.sessionID = _chatSessionId;
            newMessage.partnerName = _senderName;
            newMessage.partnerId = _senderId;
            newMessage.message = _text;
            
            int linesMax   =  [_lines_max integerValue] ;
            int linesTotal =  [_lines integerValue];
            int linesLeft = linesMax - linesTotal;
        
            NSLog(@"Current lines %@ lines_max %@", _lines, _lines_max);
            NSLog(@"Lines left %i", linesLeft);
            if (linesLeft <= 0) {
                linesLeft = 0;
                [chatView setLinesLeft:linesLeft];
                cv.labelLines.text =  [NSString stringWithFormat:@"You can now vote!"];
            } else {
                [chatView setLinesLeft:linesLeft];
                cv.labelLines.text =  [NSString stringWithFormat:@"%i lines until you can vote", linesLeft];
            }
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
        NSString *_linesMax = [elm objectForKey:@"lines_max"];
        [self.vc cbFoundChat:_sessionID:_partnerName];
    }
    
    /* prarse a our list of active sessions */
    if ([name isEqualToString:@"session_list"]) {
        NSArray *elm = [event objectAtIndex:0];
        [self loadSessions:elm];
    }
    
    //the session has been ended
    if ([name isEqualToString:@"end_session"]) {
        NSDictionary *elm = [event objectAtIndex:0];
    }
    
    //there has been a vote on the current session
    if ([name isEqualToString:@"session_vote"]) {
        NSDictionary *elm = [event objectAtIndex:0];
    }

    
}

/* send updated location infromation to the server */
- (void) updateLocation : (NSNumber *) lat : (NSNumber *) lon
{
    return;
}

@end
