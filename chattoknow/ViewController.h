//
//  ViewController.h
//  chattoknow
//
//  Created by anthony lamantia on 5/28/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UITextView *textChatTile;
    BOOL inSession;
}
- (void)   setupFacebook;
- (void)   cbFacebookLogin;

- (IBAction) clickFindChat : (id) sender;
- (void)     cbFoundChat : (NSString *) sessionID : (NSString *) partner;
- (void)     cbSessionsLoaded ;
- (IBAction) buttonDepressed : (id) sender;
@end
