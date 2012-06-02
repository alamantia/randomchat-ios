//
//  AppContext.h
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "SRWebSocket.h"
#import "FacebookEngine.h"

#define FACEBOOK_APP_ID @"392801247428039"

@interface AppContext : NSObject <SRWebSocketDelegate> {
    SRWebSocket     *_webSocket;
}

+ (id)        getContext;
- (void) Setup;

@property (nonatomic, retain) NSString *sessionID;
@property (nonatomic, assign) id <SRWebSocketDelegate> delegate;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSString *facebookID;
@property (nonatomic, retain) NSString *facebookToken;
@property (nonatomic, retain) NSString *facebookName;

@property (nonatomic, retain) FacebookEngine *facebookEngine;
@property (nonatomic, retain) NSString *facebookPicture;
@property (nonatomic, retain) NSString *emailAddress;

- (void) open;
- (void) reconnect;
- (void) close;
- (void) send:(id)data;


- (void) webSocketDidOpen:(SRWebSocket *)webSocket;
- (void) webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void) webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void) webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void) sendChat : (NSString *) senderId : (NSString *) message;

/* external request starting point */
- (void) loginWithFacebook;
- (void) loginWithFacebook_2;

@end
