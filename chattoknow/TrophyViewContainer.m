//
//  TrophyViewContainer.m
//  chattoknow
//
//  Created by anthony lamantia on 6/25/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "AppContext.h"
#import "Trophy.h"
#import "TrophyViewContainer.h"
#import "TrophyViewCell.h"
#import "Utils.h"

@interface TrophyViewContainer ()

@end

@implementation TrophyViewContainer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        trophyArray = [[NSMutableArray alloc] init];
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

- (void) Update
{
    float xCurrent = 2.0f;
    float yCurrent = 10.0f;
    
    [trophyArray removeAllObjects];
    
    trophyArray = [[AppContext getContext] trophys];
    
    for (Trophy *trophy in trophyArray) {
        
        TrophyViewCell *currentCell = [[TrophyViewCell alloc] initWithNibName:@"TrophyViewCell" bundle:nil];

        
        CGRect viewRect   = [currentCell.view frame];
        viewRect.origin.x   = xCurrent;
        viewRect.origin.y   = yCurrent;
        currentCell.view.frame = viewRect;        
        [self.view addSubview:currentCell.view];

        
        currentCell.picture.image = [Utils getImageFromURL:trophy.partnerPicture];
        currentCell.label.text = trophy.partnerName;
        
        xCurrent += 80;
        if (xCurrent >= 320) {
            xCurrent = 3;
            yCurrent += 80;
        }
    }
    
    CGRect adjustHeight   = [self.view frame];
    adjustHeight.size.height = yCurrent + 80;
    self.view.frame = adjustHeight;
    
    return;
}

@end
