//
//  NSMutableURLRequest+MFMultipart+Tests.m
//  tests
//
//  Created by Jason Gregori on 6/6/12.
//  Copyright (c) 2012 Jason Gregori. All rights reserved.
//

#import "NSMutableURLRequest+MFMultipart+Tests.h"
#import "NSMutableURLRequest+MFMultipart.h"

@implementation NSMutableURLRequest_MFMultipart_Tests

- (void)matchURLRequest:(NSURLRequest *)request toFile:(NSString *)filename {
    STAssertEqualObjects([request HTTPMethod], @"POST", nil);
    STAssertEqualObjects([request valueForHTTPHeaderField:@"Content-Type"],
                         @"multipart/form-data; boundary=______0xMuLtIpArTbOuNdArYx0______",
                         nil);
    NSData *file = [NSData dataWithContentsOfFile:
                    [[NSBundle bundleForClass:[self class]]
                     pathForResource:filename ofType:@"httpbody"]];
    STAssertEqualObjects([request HTTPBody],file, nil);
}

- (void)testNameAndType {
    NSMutableURLRequest *r = [NSMutableURLRequest new];
    [r mfAddMultiPartData:[@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding]
                 withName:@"info"
                     type:@"application/json"];
    [self matchURLRequest:r toFile:@"Test Multipart Name and Type"];
}

- (void)testFilename {
    NSMutableURLRequest *r = [NSMutableURLRequest new];
    [r mfAddMultiPartData:[@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding]
                 withName:@"info"
                 filename:@"info.json"
                     type:@"application/json"];
    [self matchURLRequest:r toFile:@"Test Multipart Filename"];
}

- (void)testMoreHeaders {
    NSMutableURLRequest *r = [NSMutableURLRequest new];
    [r mfAddMultiPartData:[@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding]
       contentDisposition:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"info", @"name",
                           @"info.json", @"filename",
                           nil]
                  headers:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           @"en", @"Content-Language",
                           nil]];
    [self matchURLRequest:r toFile:@"Test Multipart More Headers"];    
}

- (void)testCorrectlyAddAnotherPart {
    NSMutableURLRequest *r = [NSMutableURLRequest new];
    [r mfAddMultiPartData:[@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding]
                 withName:@"info"
                     type:@"application/json"];
    [self matchURLRequest:r toFile:@"Test Multipart Name and Type"];
    [r mfAddMultiPartData:[@"{\"baz\":\"qux\"}" dataUsingEncoding:NSUTF8StringEncoding]
                 withName:@"info2"
                     type:@"application/json"];
    [self matchURLRequest:r toFile:@"Test Multipart Two Parts"];
}

- (void)testCorrectlyOverwriteBadBody {
    NSMutableURLRequest *r = [NSMutableURLRequest new];
    [r setHTTPBody:[@"bad impartial data!" dataUsingEncoding:NSUTF8StringEncoding]];
    [r mfAddMultiPartData:[@"{\"foo\":\"bar\"}" dataUsingEncoding:NSUTF8StringEncoding]
                 withName:@"info"
                     type:@"application/json"];
    [self matchURLRequest:r toFile:@"Test Multipart Name and Type"];
}

@end
