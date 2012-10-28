//
//  NSURL+MFQueryParams.h
//
//  Created by Jason Gregori on 1/9/12.
//  Copyright (c) 2012 Jason Gregori. All rights reserved.
//

// @mf: Create urls with query params or get query params from a url

/*
 
 - Keys must be NSStrings
 - Params are converted into NSStrings using `-description`
 - If a param is an array, the items are converted to NSStrings,
   sorted, and added as a separate pair with the same key.
 - When creating query params, keys are sorted using `compare:`.
   This way the same url and params always create the same final url.
 
 */

#import <Foundation/Foundation.h>

@interface NSURL (MFQueryParams)

// creating
+ (NSString *)mfURLStringWithString:(NSString *)string andParams:(NSDictionary *)params;
+ (id)mfURLWithString:(NSString *)string andParams:(NSDictionary *)params;

// getting
- (NSDictionary *)mfQueryParams;
+ (NSDictionary *)mfQueryParamsFromString:(NSString *)string;

@end
