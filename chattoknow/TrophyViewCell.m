//
//  TrophyViewCell.m
//  chattoknow
//
//  Created by anthony lamantia on 6/25/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "TrophyViewCell.h"

@interface TrophyViewCell ()

@end

@implementation TrophyViewCell
@synthesize  picture = _picture;
@synthesize  label = _label;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
