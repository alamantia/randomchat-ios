//
//  Utils.m
//  chattoknow
//
//  Created by anthony lamantia on 7/15/12.
//  Copyright (c) 2012 Player2. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+ (UIImage *) getImageFromURL : (NSString *) url
{
    NSURL    *imageURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@", url]];    
    UIImage *image = nil;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", docDir, [Utils md5:imageURL.absoluteString]];
    NSData *imageData = [NSData dataWithContentsOfFile: imagePath];
    if (imageData == nil) {
        image = [UIImage imageWithData: [NSData dataWithContentsOfURL: imageURL]];
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    } else {
        image = [UIImage imageWithData:imageData];
    }
    return image;
}

@end
