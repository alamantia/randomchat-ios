//
//  TileButton.m
//  chattoknow
//
//  Created by anthony lamantia on 7/2/12.
//  Copyright (c) 2012 Player2. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "TileButton.h"
#import "UIColor-Expanded.h"
@implementation TileButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _highlighted = false;
    }
    return self;
}

-(void) setHighlighted:(BOOL)highlighted 
{
    _highlighted = highlighted;
    NSLog(@"Highlighted is %i", highlighted);
    [self setNeedsDisplay];
    return;
}

- (void) setSelected:(BOOL)selected
{
    return;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!_highlighted) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        CGContextAddRect(context, rect);
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"cafe54"].CGColor);

        CGContextFillPath(context);
    } else {
        NSLog(@"Not normal");
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        CGContextAddRect(context, rect);
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"b4e24a"].CGColor);
        CGContextFillPath(context);
    }

}


@end
