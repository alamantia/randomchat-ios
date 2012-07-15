//
//  TrophyViewCell.h
//  chattoknow
//
//  Created by anthony lamantia on 6/25/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrophyViewCell : UIViewController {
    IBOutlet UIImageView *_picture;
    IBOutlet UILabel     *_label;
}
@property (nonatomic, retain) UIImageView *picture;
@property (nonatomic, retain) UILabel *label;

@end
