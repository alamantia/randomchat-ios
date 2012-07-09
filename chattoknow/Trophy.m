//
//  Trophy.m
//  chattoknow
//
//  Created by anthony lamantia on 7/8/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "Trophy.h"

@implementation Trophy

@synthesize  _id;
@synthesize imageURL;
@synthesize partnerID;
@synthesize partnerName;

- (void) loadFromDict : (NSDictionary *) dict
{
    self._id = [dict objectForKey:@"_id"];
    self.imageURL = [dict objectForKey:@"imageURL"];
    self.partnerID = [dict objectForKey:@"partnerID"];
    self.partnerName = [dict objectForKey:@"partnerName"];
    return;
}

@end
