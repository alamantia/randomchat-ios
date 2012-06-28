//
//  RateDialog.h
//  chattoknow
//
//  Created by anthony lamantia on 6/16/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateDialog : UIViewController {
    IBOutlet UILabel * labelWith;
}
@property (nonatomic, retain) NSString *sessionID;
- (IBAction) clickUp   : (id) sender;
- (IBAction) clickDown : (id) sender;
@end
