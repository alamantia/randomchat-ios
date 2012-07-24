//
//  FacebookDialog.m
//  chattoknow
//
//  Created by anthony lamantia on 7/23/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "FacebookDialog.h"
#import "AppContext.h"
#import "ViewController.h"

@interface FacebookDialog ()

@end

@implementation FacebookDialog

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

- (IBAction) clickFacebook : (id) sender
{
    //[self dismissModalViewControllerAnimated:YES];
    [[[AppContext getContext] vc] setupFacebook];
    return;
}

@end
