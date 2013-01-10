//
//  MTPocketTestsDefaults.m
//  MTPocket
//
//  Created by Adam Kirk on 1/10/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsDefaults.h"
#import "MTPocket.h"

@implementation MTPocketTestsDefaults

- (void)testDefaultTimeout
{
    [MTPocketRequest setDefaultTimeout:0.01];
    MTPocketResponse *response = [[MTPocketRequest requestForURL:[NSURL URLWithString:@"https://dl.dropbox.com/u/2771219/unit_tests/genada.jpg"] format:MTPocketFormatHTML] send];
    STAssertFalse(response.success, nil);
    STAssertTrue(response.statusCode == 408, nil);
    STAssertTrue(response.status == MTPocketStatusTimedOut, nil);
}

@end
