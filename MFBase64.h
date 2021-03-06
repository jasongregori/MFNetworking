//
//  MFBase64.h
//
//  Created by Jason Gregori on 3/23/12.
//  Copyright (c) 2012 Jason Gregori. All rights reserved.
//

// @mf: Easily base64 encode strings or data

#import <Foundation/Foundation.h>

@interface MFBase64 : NSObject

+ (NSString *)encodeString:(NSString *)string;
+ (NSString *)encodeData:(NSData *)data;
// ('+' -> '-', '/' -> '_')
+ (NSString *)encodeDataURLSafe:(NSData *)data;

@end
