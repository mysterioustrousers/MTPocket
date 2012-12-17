//
//  MTPocketTestsPUT.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsPUT.h"
#import "MTPocket.h"
#import "constants.h"




@implementation MTPocketTestsPUT

- (void)testPutJSON
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:STITCHES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatJSON
                                                         username:nil
                                                         password:nil
                                                             body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } }].send;
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", jsonId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodPUT
                                                          format:MTPocketFormatJSON
                                                        username:nil
                                                        password:nil
                                                            body:@{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } }].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testPutJSONAuthenticated
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:NEEDLES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatJSON
                                                         username:UN
                                                         password:PW
                                                             body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } }].send;
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"needles/%d", jsonId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodPUT
                                                          format:MTPocketFormatJSON
                                                        username:UN
                                                        password:PW
                                                            body:@{ @"needle" : @{ @"sharpness" : @1, @"length" : @1 } }].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"sharpness"] intValue] == 1, nil);
}

- (void)testPutXML
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:STITCHES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatXML
                                                         username:nil
                                                         password:nil
                                                             body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } }].send;
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", xmlId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodPUT
                                                          format:MTPocketFormatXML
                                                        username:nil
                                                        password:nil
                                                            body:@{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } }].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"length"] intValue] == 2, nil);
}

- (void)testPutXMLAuthenticated
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:NEEDLES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatXML
                                                         username:UN
                                                         password:PW
                                                             body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } }].send;
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path					= [NSString stringWithFormat:@"needles/%d", xmlId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodPUT
                                                          format:MTPocketFormatXML
                                                        username:UN
                                                        password:PW
                                                            body:@{ @"needle" : @{ @"sharpness" : @2, @"length" : @1 } }].send;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"sharpness.@innerText"] intValue] == 2, nil);
}


@end
