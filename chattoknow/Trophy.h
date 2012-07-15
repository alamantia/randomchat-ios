//
//  Trophy.h
//  chattoknow
//
//  Created by anthony lamantia on 7/8/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trophy : NSObject {
    
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *imageURL;
/* for possible future messaging */
@property (nonatomic, retain) NSString *partnerID;
@property (nonatomic, retain) NSString *partnerName;
@property (nonatomic, retain) NSString *partnerPicture;

- (void) loadFromDict : (NSDictionary *) dict;

@end
