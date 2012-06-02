//
//  FacebookEngine.h
//  chattoknow
//
//  Created by anthony lamantia on 5/30/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

/*
 module of code for reading and writing data
 with the facebook api 
*/

#import <Foundation/Foundation.h>
#import "FBConnect.h"

enum FB_REQUEST_MODES {
    FB_MODE_NONE = 0,
    FB_MODE_CURRENT_PROFILE = 1,
};

@interface FacebookEngine : NSObject <FBRequestDelegate, FBDialogDelegate> {
    int requestMode;
}

- (void) scrapeUserProfile;

@end
