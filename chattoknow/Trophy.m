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
@synthesize partnerPicture;

- (void) loadFromDict : (NSDictionary *) dict
{
    self._id = [dict objectForKey:@"_id"];
    self.imageURL = [dict objectForKey:@"picture"];
    self.partnerID = [dict objectForKey:@"from_user"];
    self.partnerName = [dict objectForKey:@"name"];
    self.partnerPicture = [dict objectForKey:@"picture"];
    return;
}

@end
