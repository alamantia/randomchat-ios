//
//  Session.m
//  chattoknow
//
//  Created by anthony lamantia on 7/1/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "Session.h"

@implementation Session
@synthesize  _id;
@synthesize token;
@synthesize active;
@synthesize lines;
@synthesize lines_max;
@synthesize vote_1;
@synthesize vote_1_id;
@synthesize vote_2;
@synthesize vote_2_id;
@synthesize messages;
@synthesize users;
@synthesize  user_1;
@synthesize  user_2;
@synthesize  left_1;
@synthesize  left_2;

- (void) buildFromDict : (NSDictionary *) dict
{
    self._id = [dict objectForKey:@"_id"];
    self.token = [dict objectForKey:@"token"];
    self.users = [dict objectForKey:@"users"];
    self.active = [dict objectForKey:@"active"];
    self.lines = [dict objectForKey:@"lines"];
    self.lines_max = [dict objectForKey:@"lines_max"];
    self.vote_1 = [dict objectForKey:@"vote_1"];
    self.vote_1_id = [dict objectForKey:@"vote_1_id"];
    self.vote_2 = [dict objectForKey:@"vote_2"];
    self.vote_2_id = [dict objectForKey:@"vote_2_id"];
    self.messages = [dict objectForKey:@"messages"];
    self.user_1     = [dict objectForKey:@"user_1"];
    self.user_2     = [dict objectForKey:@"user_2"];
    self.left_1     = [dict objectForKey:@"left_1"];
    self.left_2     = [dict objectForKey:@"left_2"];
    return;
}

@end
