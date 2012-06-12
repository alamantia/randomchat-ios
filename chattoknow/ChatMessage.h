//
//  ChatMessage.h
//  chattoknow
//
//  Created by anthony lamantia on 6/7/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject {
    
}
@property (nonatomic, retain) NSString *sessionID;
@property (nonatomic, retain) NSString *partnerName;
@property (nonatomic, retain) NSString *partnerId;
@property (nonatomic, retain) NSString *message;
@end
