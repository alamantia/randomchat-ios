//
//  ChatView.h
//  chattoknow
//
//  Created by anthony lamantia on 6/7/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface ChatView : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate>
{
    IBOutlet UITextField *fieldInput;
    IBOutlet UILabel *_fieldName;
    IBOutlet UITableView *tableView;

}
@property (nonatomic, retain) NSString* sessionID;
@property (nonatomic, retain) UILabel *fieldName;
@property (nonatomic, retain) NSMutableArray *chatArray;
@property (nonatomic, retain) NSMutableArray *messageCells;

- (void) addMessage : (ChatMessage *) newMessage;

- (IBAction) voteUp :(id)sender;
- (IBAction) voteDown :(id)sender;

@end
