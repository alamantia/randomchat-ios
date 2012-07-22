//
//  OptionsViewController.m
//  chattoknow
//
//  Created by anthony lamantia on 7/13/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "OptionsViewController.h"
#import "SVProgressHUD.h"
#import "AppContext.h"

@interface OptionsViewController ()
@end

@implementation OptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CGFloat)scaleValue:(CGFloat)value {
    return pow(value, 10);
}

- (CGFloat)unscaleValue:(CGFloat)value {
    return pow(value, 1.0 / 10.0);
}

- (CGFloat)roundValue:(CGFloat)value {
    if(value <=   200) return floor(value /   10) * 10;
    if(value <=   500) return floor(value /   50) * 50;
    if(value <=  1000) return floor(value /  100) * 100;
    if(value <= 50000) return floor(value / 1000) * 1000;
    return floor(value / 25000) * 25000;
}

- (void) transmitSettings
{
    NSLog(@"%i", switchSearching.on);
    NSLog(@"%i", segmentRange.selectedSegmentIndex);
    [SVProgressHUD showWithStatus:@"Updating"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject: [[AppContext getContext] sessionID] forKey:@"token"];
    [[AppContext getContext] sendOptions:params];
    return;
}

- (void) updateSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    

    
    [defaults synchronize];
    return;
}

- (IBAction)sliderChange:(id)sender {
    [self transmitSettings];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    

    [defaults synchronize];
    return;
}

- (IBAction)segmentChange:(id)sender {
    [self transmitSettings];
    return;
}

- (void) cbSettingsUpdated 
{
    /* repopulate views and all (if needed) */
    [SVProgressHUD dismiss];
    return;
}

- (void) populate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults synchronize];
    return;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self updateSettings];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppContext getContext] setOptionView:self];
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

- (IBAction)  clickBack : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

- (IBAction)  clickQuit : (id) sender;
{
    return;
}
@end
