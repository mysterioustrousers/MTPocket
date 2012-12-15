//
//  MTPocketTestsPOST.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsPOST.h"
#import "MTPocket.h"
#import "constants.h"




@implementation MTPocketTestsPOST


- (void)testPostJSON
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:STITCHES_URL
                                                         method:MTPocketMethodPOST
                                                         format:MTPocketFormatJSON
                                                       username:nil
                                                       password:nil
                                                           body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } }].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testPostJSONWithDateObject
{
	MTPocketResponse *response	= [MTPocketRequest requestForURL:STITCHES_URL
                                                         method:MTPocketMethodPOST
                                                         format:MTPocketFormatJSON
                                                       username:nil
                                                       password:nil
                                                           body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3, @"updated_at" : [NSDate date] } }].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testPostJSONAuthenticated
{
	MTPocketResponse *response	= [MTPocketRequest requestForURL:NEEDLES_URL
                                                         method:MTPocketMethodPOST
                                                         format:MTPocketFormatJSON
                                                       username:UN
                                                       password:PW
                                                           body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } }].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"sharpness"] intValue] == 7, nil);
}

- (void)testPostXML
{
	MTPocketResponse *response	= [MTPocketRequest requestForURL:STITCHES_URL
                                                         method:MTPocketMethodPOST
                                                         format:MTPocketFormatXML
                                                       username:nil
                                                       password:nil
                                                           body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } }].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"length"] intValue] == 3, nil);
}

- (void)testPostXMLAuthenticated
{
	MTPocketResponse *response	= [MTPocketRequest requestForURL:NEEDLES_URL
                                                         method:MTPocketMethodPOST
                                                         format:MTPocketFormatXML
                                                       username:UN
                                                       password:PW
                                                           body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } }].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"sharpness.@innerText"] intValue] == 7, nil);
}


@end
