//
//  Session.h
//  chattoknow
//
//  Created by anthony lamantia on 7/1/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSNumber *active;
@property (nonatomic, retain) NSNumber *lines;
@property (nonatomic, retain) NSNumber *lines_max;
@property (nonatomic, retain) NSNumber *vote_1;
@property (nonatomic, retain) NSString *vote_1_id;
@property (nonatomic, retain) NSNumber *vote_2;
@property (nonatomic, retain) NSString *vote_2_id;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) NSMutableArray *users;
- (void) buildFromDict : (NSDictionary *) dict;

@end
