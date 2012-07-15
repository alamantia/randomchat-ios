//
//  TrophyView.h
//  chattoknow
//
//  Created by anthony lamantia on 6/7/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrophyViewContainer.h"

@interface TrophyView : UIViewController <UIScrollViewDelegate>{
    IBOutlet UIScrollView *_scrollView;
    TrophyViewContainer *contentView;
}

- (IBAction)  clickBack : (id) sender;
- (void)      cbUpdatedTrophys;

@end
