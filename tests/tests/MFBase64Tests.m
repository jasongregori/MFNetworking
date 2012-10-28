//
//  MFBase64Tests.m
//  tests
//
//  Created by Jason Gregori on 6/4/12.
//  Copyright (c) 2012 Jason Gregori. All rights reserved.
//

#import "MFBase64Tests.h"

#import "MFBase64.h"

@implementation MFBase64Tests

- (void)testPadding {
    STAssertEqualObjects([MFBase64 encodeString:@""], @"", nil);
    STAssertEqualObjects([MFBase64 encodeString:@"a"], @"YQ==", nil);
    STAssertEqualObjects([MFBase64 encodeString:@"bb"], @"YmI=", nil);
    STAssertEqualObjects([MFBase64 encodeString:@"ccc"], @"Y2Nj", nil);
    STAssertEqualObjects([MFBase64 encodeString:@"dddd"], @"ZGRkZA==", nil);
    STAssertEqualObjects([MFBase64 encodeString:@"eeeee"], @"ZWVlZWU=", nil);
    STAssertEqualObjects([MFBase64 encodeString:@"ffffff"], @"ZmZmZmZm", nil);
}

- (void)testNonASCII {
    STAssertEqualObjects([MFBase64 encodeString:@"This is a heart: \u2665"], @"VGhpcyBpcyBhIGhlYXJ0OiDimaU=", nil);
}

- (void)testImage {
    NSData *data = [NSData dataWithContentsOfFile:
                    [[NSBundle bundleForClass:[self class]]
                     pathForResource:@"Test Image" ofType:@"jpg"]];
    NSString *encodedData = [NSString stringWithContentsOfFile:
                             [[NSBundle bundleForClass:[self class]]
                              pathForResource:@"Test Image Encoded" ofType:@"txt"]
                                                  usedEncoding:NULL
                                                         error:NULL];
    STAssertEqualObjects([MFBase64 encodeData:data],
                          encodedData, nil);
}

@end
