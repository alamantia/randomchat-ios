//
//  MessageCell.m
//  chattoknow
//
//  Created by anthony lamantia on 6/10/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize  sender;
#if 0

NSTextView* t =
[[NSTextView alloc] initWithFrame: NSMakeRect(0,0,width,0.1)];
[[t textStorage] setAttributedString: s];
[t sizeToFit];
// now fetch [t frame].size.height; don't forget to release t

http://stackoverflow.com/questions/728704/resizing-uitextview

#define MAX_HEIGHT 2000

NSString *foo = @"Lorem ipsum dolor sit amet.";
CGSize size = [foo sizeWithFont:[UIFont systemFontOfSize:14]
              constrainedToSize:CGSizeMake(100, MAX_HEIGHT)
                  lineBreakMode:UILineBreakModeWordWrap];

[textView setFont:[UIFont systemFontOfSize:14]];
[textView setFrame:CGRectMake(5, 30, 100, size.height + 10)];

or

UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 30, 100, size.height + 10)];



OR

CGRect frame = _textView.frame;
frame.size.height = _textView.contentSize.height;
_textView.frame = frame;

http://www.cimgf.com/2009/09/23/uitableviewcell-dynamic-height/

#endif

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    sender = 0;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
    return;
    
	CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
	CGContextRef context = UIGraphicsGetCurrentContext(); 
    

	CGContextSetRGBFillColor(context, 34/100, 169/100, 215/100, 1.0); 
	CGContextFillRect(context, drawRect);
}


@end
