//
//  RateDialog.m
//  chattoknow
//
//  Created by anthony lamantia on 6/16/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "RateDialog.h"
#import "AppContext.h"
#import "ChatView.h"

@interface RateDialog ()

@end

@implementation RateDialog
@synthesize  sessionID;

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
    ChatView *cv = [[AppContext getContext] chatView];
    labelWith.text = [NSString stringWithFormat:@"with %@",cv.partnerName]; 
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    ChatView *cv = [[AppContext getContext] chatView];
    labelWith.text = [NSString stringWithFormat:@"with %@",cv.partnerName]; 
    return;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return NO;
    return YES;
}


- (IBAction) clickUp : (id) sender
{
    ChatView *cv = [[AppContext getContext] chatView];
    [[AppContext getContext] sendVote:@"up" : cv.sessionID];
    [self dismissModalViewControllerAnimated:YES];
    [cv cbVoteFinish:1];
    return;
}

- (IBAction) clickDown : (id) sender
{
    ChatView *cv = [[AppContext getContext] chatView];
    [[AppContext getContext] sendVote:@"down" : cv.sessionID];
    [self dismissModalViewControllerAnimated:YES];
    [cv cbVoteFinish:0];
    return;
}

@end
