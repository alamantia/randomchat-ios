//
//  ViewController.h
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileButton.h"
#import "GADBannerView.h"

@interface ViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UITextView *textChatTile;
    IBOutlet TileButton *buttonChat;
    IBOutlet UIView *adView;
    BOOL inSession;
    BOOL isLaunching;
    BOOL isShowing;
    NSString *launchingSessionToken;
    GADBannerView *bannerView_;

}
- (void)   setupFacebook;
- (void)   cbFacebookLogin;
- (void) wake;
- (IBAction) clickFindChat : (id) sender;
- (void)     cbFoundChat : (NSString *) sessionID : (NSString *) partner;
- (void)     cbSessionsLoaded ;
- (IBAction) buttonDepressed : (id) sender;
- (void) Update;
@end
