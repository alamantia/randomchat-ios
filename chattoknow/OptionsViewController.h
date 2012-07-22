//
//  OptionsViewController.h
//  chattoknow
//
//  Created by anthony lamantia on 7/13/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController {
    IBOutlet UISlider *sliderRange;
    IBOutlet UISwitch *switchSearching;
    IBOutlet UISegmentedControl *segmentRange;
}
- (IBAction)  clickBack : (id) sender;

- (IBAction)  clickQuit : (id) sender;

- (IBAction) sliderChange:(id)sender;

- (void) cbSettingsUpdated;

@end
