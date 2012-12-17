//
//  MTPocketTestsAuthentication.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsGET.h"
#import "MTPocket.h"
#import "constants.h"



@implementation MTPocketTestsGET


- (void)testGetTEXT
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:BASE_URL
                                                         format:MTPocketFormatHTML].send;

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body length] > 0, @"String length was 0");
}

- (void)testGetTEXTAuthenticated
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:BASE_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                       username:UN
                                                       password:PW
                                                           body:nil].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body length] > 0, @"String length was 0");
}

- (void)testGetJSON
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:STITCHES_URL
                                                         format:MTPocketFormatJSON].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testGetJSONAuthenticated
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:NEEDLES_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatJSON
                                                       username:UN
                                                       password:PW
                                                           body:nil].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testGetXML
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:STITCHES_URL
                                                         format:MTPocketFormatXML].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"stitch"] count] > 0, @"String length was 0");
}

- (void)testGetXMLAuthenticated
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:NEEDLES_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatXML
                                                       username:UN
                                                       password:PW
                                                           body:nil].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"needle"] count] > 0, @"String length was 0");
}



@end
