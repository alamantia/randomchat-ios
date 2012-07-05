//
//  ChatView.h
//  chattoknow
//
//  Created by anthony lamantia on 6/7/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"
#import "RateDialog.h"
#import "GADBannerView.h"

@interface ChatView : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate>
{
    IBOutlet UITextField *fieldInput;
    IBOutlet UILabel *_fieldName;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *_labelLines;
    IBOutlet UIButton *_buttonVote;
    IBOutlet UIButton *_buttonExit;
    IBOutlet UIView *adView;
    RateDialog *rd;
    GADBannerView *bannerView_;

}
@property (nonatomic, retain) NSString* sessionID;
@property (nonatomic, retain) UILabel *fieldName;
@property (nonatomic, retain) UILabel *labelLines;
@property (nonatomic, retain) UIButton *buttonExit;
@property (nonatomic, retain) UIButton *buttonVote;
@property (nonatomic) BOOL hasVoted;
@property (nonatomic, retain) NSMutableArray *chatArray;
@property (nonatomic, retain) NSMutableArray *messageCells;

- (void) addMessage : (ChatMessage *) newMessage;

- (IBAction) voteUp :(id)sender;
- (IBAction) voteDown :(id)sender;


- (IBAction) clickUp :(id)sender;
- (IBAction) clickDown :(id)sender;

- (IBAction) clickVote :(id)sender;
- (IBAction) clickEnd :(id)sender;
- (IBAction) clickBack :(id)sender;

- (void) cbVoteFinish : (int) result;
- (void) setLinesLeft : (int) linesLeft;

@end
