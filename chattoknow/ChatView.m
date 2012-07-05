//
//  ChatView.m
//  chattoknow
//
//  Created by anthony lamantia on 6/7/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "MessageCell.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIColor-Expanded.h"

#import "RateDialog.h"
#import "ChatView.h"
#import "AppContext.h"
#import "ViewController.h"


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

#define CELL_OFFSET 5

@interface ChatView ()
@end

@implementation ChatView
@synthesize  buttonExit = _buttonExit;
@synthesize  buttonVote = _buttonVote;
@synthesize  partnerName;
@synthesize  hasVoted;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION     = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION     = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT    = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT   = 162;

@synthesize  sessionID;
@synthesize  chatArray;
@synthesize  messageCells;
@synthesize  fieldName = _fieldName;
@synthesize  labelLines = _labelLines;

CGFloat animatedDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        chatArray = [[NSMutableArray alloc] init];
        messageCells = [[NSMutableArray alloc] init];
        self.hasVoted = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _buttonVote.hidden = YES;
    _buttonExit.hidden = YES;

    // Do any additional setup after loading the view from its nib.
    
    // Create a view of the standard size at the bottom of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"a14ff48dbd41ba6";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [adView addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    GADRequest *request = [GADRequest request];
    request.testing = YES;
    [bannerView_ loadRequest:request];

}

- (void) viewDidAppear:(BOOL)animated {
    /* make sure we are defined as the current chat view */
    [[AppContext getContext] setChatView:self];
    _fieldName.text = [NSString stringWithFormat:@"Chatting with %@", partnerName];
    if (self.hasVoted == YES) {
        self.buttonExit.hidden = NO;
        self.buttonVote.hidden = YES;
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Return clicked");
    if ( [fieldInput.text isEqualToString:@""] ){
        [textField resignFirstResponder];
        return YES;
    }
    [[AppContext getContext] sendChat:self.sessionID :fieldInput.text];
    fieldInput.text = @"";
    [textField resignFirstResponder];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void) textFieldDidBeginEditing:(UITextField *)textView
{
    CGRect textFieldRect =
    [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];    
    [UIView commitAnimations];


    return;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{    
    CGRect textFieldRect =
    [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];    
    [UIView commitAnimations];
    
    return;
}


- (void) addMessage : (ChatMessage *) newMessage
{
    NSLog(@"New message");
    [chatArray addObject:newMessage];
    [tableView reloadData];
    
    int cells_count = [chatArray count];
    int sections_count = 1;
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: cells_count-1 inSection: sections_count-1];
    
    [tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];

    return;
}

- (IBAction) voteUp :(id)sender
{
    return;
}

- (IBAction) voteDown :(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

/* TableView delegate */


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{    
    ChatMessage *message = [chatArray objectAtIndex: indexPath.row];
    NSString *text = message.message;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    return height + (CELL_CONTENT_MARGIN * 2) + (CELL_OFFSET * 2);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
    } else {
        return cell;
    }
    ChatMessage *message = [chatArray objectAtIndex: indexPath.row];
    UILabel *label = nil;
    UILabel *nameLabel = nil;
    
    CGRect startFrame = CGRectMake(0, CELL_OFFSET, 0, 0);
    label = [[UILabel alloc] initWithFrame:startFrame];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setMinimumFontSize:FONT_SIZE];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [label setTag:1];
    //34/100, 169/100, 215/100, 1.0
    [label setBackgroundColor: [UIColor colorWithHexString:@"b8e84c"]];
     [[label layer] setBorderWidth:0.0f];
    
    [[cell contentView] addSubview:label];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    
    NSString *text = message.message;
    
    float offsetX = 0.0f;
    float offsetY = 0.0f;
    
    if ([message.partnerId isEqualToString: [[AppContext getContext] sessionID]] ) {
        label.textAlignment = UITextAlignmentRight;
    } else {
        label.textAlignment = UITextAlignmentLeft;
    }

    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];

    
    return cell;
}

- (IBAction) clickUp :(id)sender
{
    NSLog(@"Vote up");
    return;
}

- (IBAction) clickDown :(id)sender
{
    NSLog(@"Vote Down");
    return;
}

- (void) setLinesLeft : (int) linesLeft
{
    if (hasVoted == NO) {
        if (linesLeft <= 0) {
            _buttonVote.hidden = NO;
        } else {
            _buttonVote.hidden = YES;
        }
    } else {
        _buttonVote.hidden = YES;
        _buttonExit.hidden = NO;
        _labelLines.text = @"Vote submitted";
    }
    return;
}

/* display the vode modal dialog */
- (IBAction) clickVote :(id)sender
{
    rd = [[RateDialog alloc] initWithNibName:@"RateDialog" bundle:nil];
    [self presentModalViewController:rd animated:YES];
    return;
}

- (void) cbVoteFinish : (int) result
{
    if (result == 0) {
        [self.navigationController popViewControllerAnimated:NO];
        [[[AppContext getContext] vc] Update];
        return;
    }
    _labelLines.text = @"Vote submitted";
    self.hasVoted = YES;
    self.buttonVote.hidden = YES;
    self.buttonExit.hidden = NO;
    return;
}

- (IBAction) clickEnd :(id)sender
{
    return;
}
/* back button or end session button, i'm not 100% sure on this one */
- (IBAction) clickBack :(id)sender
{
    //NSLog(@"Sending end for %@", self.sessionID);
    //[[AppContext getContext] sendEnd: self.sessionID];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

@end
