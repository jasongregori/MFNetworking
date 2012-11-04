//
//  NSURLConnection+MFBlockize+Tests.m
//  tests
//
//  Created by Jason Gregori on 11/2/12.
//  Copyright (c) 2012 Jason Gregori. All rights reserved.
//

#import "NSURLConnection+MFBlockize+Tests.h"

#import "NSURLConnection+MFBlockize.h"

/*
 
 Note: I tried to show that the request was also released in these cases but
 - [NSURLConnection initWithRequest:delegate:startImmediately:] retained the request
 for a while and I wasn't sure which way to go from there.
 
 */

@implementation NSURLConnection_MFBlockize_Tests

- (void)testFullRequest {
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:
                             [[NSBundle mainBundle] URLForResource:@"Test Image" withExtension:@"jpg"]];
    __block BOOL blockCalled = NO;
    void (^block)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        blockCalled = YES;
    };
    
    void (__weak ^weakblock)(NSData *data, NSURLResponse *response, NSError *error) = block;
    
    id object = [NSURLConnection mfSendRequest:request background:NO withBlock:block];
    // release strong references
    block = nil;
    
    // wait until block called
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:5];
    while (!blockCalled && [timeoutDate timeIntervalSinceNow] > 0.0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    
    // test block called
    STAssertTrue(blockCalled, @"Response block was not called");
        
    // test block released
    STAssertNil(weakblock, @"Response block not released");
    
    // this is just to stop a warning about object never being used
    object = nil;
}

- (void)testCancelingRequest {
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:
                             [[NSBundle mainBundle] URLForResource:@"Test Image" withExtension:@"jpg"]];
    id object;
    __block BOOL blockCalled = NO;
    void (^block)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        blockCalled = YES;
    };
    
    void (__weak ^weakblock)(NSData *data, NSURLResponse *response, NSError *error) = block;
    
    @autoreleasepool {
        object = [NSURLConnection mfSendRequest:request background:NO withBlock:block];
        // release strong references
        request = nil;
        block = nil;
    }
    
    // cancel request
    object = nil;
    
    // test block not called
    STAssertFalse(blockCalled, @"Response block was not called");
    
    // test block released
    STAssertNil(weakblock, @"Response block not released");
}

@end
