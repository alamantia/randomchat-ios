//
//  TrophyView.m
//  chattoknow
//
//  Created by anthony lamantia on 6/7/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "TrophyView.h"
#import "SVProgressHUD.h"
#import "AppContext.h"
#import "TrophyViewContainer.h"
@interface TrophyView ()

@end

@implementation TrophyView

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
     contentView = [[TrophyViewContainer alloc] initWithNibName:nil bundle:nil];
    [[AppContext getContext] setTrophyView:self];
    // Do any additional setup after loading the view from its nib.
}

- (void) cbUpdatedTrophys 
{
    [SVProgressHUD dismiss];
    [contentView Update];
    _scrollView.contentSize = 
    CGSizeMake ( [contentView.view frame].size.width,
                [contentView.view frame].size.height);
    _scrollView.maximumZoomScale =  1.0f;
    _scrollView.minimumZoomScale =  1.0f;
    _scrollView.clipsToBounds    = YES;
    _scrollView.pagingEnabled    = NO;
    _scrollView.delegate         = self;
    [_scrollView addSubview:contentView.view];
    return;
}

- (void) viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"Loading"];
    [[AppContext getContext] sendListTrophys];
    return;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)  clickBack : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return contentView.view;
}


@end
