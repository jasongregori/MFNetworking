//
//  NSURL+MFQueryParams+Tests.m
//  tests
//
//  Created by Jason Gregori on 4/16/12.
//  Copyright (c) 2012 Jason Gregori. All rights reserved.
//

#import "NSURL+MFQueryParams+Tests.h"

#import "NSURL+MFQueryParams.h"

@implementation NSURL_MFQueryParams_Tests

#pragma mark - Create Query Params

- (void)testCreateWithNumber {
    STAssertEqualObjects(@"http://www.google.com?a=1", 
                         [NSURL mfURLStringWithString:@"http://www.google.com"
                                            andParams:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"a"]],
                         nil);
}

- (void)testCreateParamsSortedByKey {
    NSString *url = [NSURL mfURLStringWithString:@"http://www.google.com"
                                       andParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"1", @"c",
                                                  @"2", @"a",
                                                  @"4", @"d",
                                                  @"3", @"b",
                                                  nil]];
    STAssertEqualObjects(@"http://www.google.com?a=2&b=3&c=1&d=4",
                         url,
                         nil);
}

- (void)testCreateWithKeysWithMultipleValues {
    NSString *url = [NSURL mfURLStringWithString:@"http://www.google.com"
                                       andParams:@{ @"key": @[ @1, @3, @2 ] }];
    STAssertEqualObjects(@"http://www.google.com?key=1&key=2&key=3",
                         url,
                         nil);
}

#pragma mark - Get Query Params

#pragma mark nil tests

- (void)testGetWithoutParams {
    STAssertNil([[NSURL URLWithString:@"http://www.google.com"] mfQueryParams], nil);
}

- (void)testGetWithQuestionMarkWithoutParams {
    STAssertNil([[NSURL URLWithString:@"http://www.google.com?"] mfQueryParams], nil);
}

- (void)testGetWithQuestionMarkAndHashtagWithoutParams {
    STAssertNil([[NSURL URLWithString:@"http://www.google.com?#"] mfQueryParams], nil);
}

- (void)testGetIgnoreMalformedParams {
    STAssertNil([[NSURL URLWithString:@"http://www.google.com?a"] mfQueryParams], nil);
}

#pragma mark Simple Params Tests

- (void)returnsSimpleParamsTest:(NSString *)url {
    STAssertEqualObjects([[NSURL URLWithString:url] mfQueryParams],
                         [NSDictionary dictionaryWithObject:@"b" forKey:@"a"],
                         nil);
}

- (void)testGetSimpleParams {
    [self returnsSimpleParamsTest:@"http://www.google.com?a=b"];
}

- (void)testGetHashtagBeforeQuestionMark {
    [self returnsSimpleParamsTest:@"http://www.google.com#asdf?a=b"];
}

- (void)testGetIgnoreMalformedParamsWithGoodParams {
    [self returnsSimpleParamsTest:@"http://www.google.com#asdf?c&a=b"];
}

- (void)testGetHashtag {
    [self returnsSimpleParamsTest:@"http://www.google.com?a=b#"];
}

- (void)testGetHashtag2 {
    [self returnsSimpleParamsTest:@"http://www.google.com?a=b#c=d&e=f"];
}

#pragma mark Complex Params Tests

- (void)testGetComplexParams {
    NSDictionary *params = [[NSURL URLWithString:@"http://www.google.com?a=b&c=d&e=f"] mfQueryParams];
    NSDictionary *shouldBe = [NSDictionary dictionaryWithObjectsAndKeys:@"b", @"a", @"d", @"c", @"f", @"e", nil];
    STAssertEqualObjects(params,
                         shouldBe,
                         nil);
}

- (void)testGetUnescapingParams {
    NSDictionary *params = [[NSURL URLWithString:@"http://www.google.com?animals=dogs+and%20cats"] mfQueryParams];
    NSDictionary *shouldBe = [NSDictionary dictionaryWithObjectsAndKeys:@"dogs and cats", @"animals", nil];
    STAssertEqualObjects(params,
                         shouldBe,
                         nil);
}

- (void)testGetWithKeysWithMultipleValues {
    NSDictionary *params = [[NSURL URLWithString:@"http://www.google.com?key=1&key=2&key=3"] mfQueryParams];
    NSDictionary *shouldBe = @{ @"key": @[ @"1", @"2", @"3" ] };
    STAssertEqualObjects(params,
                         shouldBe,
                         nil);
}

@end
