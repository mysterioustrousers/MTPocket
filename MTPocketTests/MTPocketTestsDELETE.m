//
//  MTPocketTests.m
//  MTPocketTests
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsDELETE.h"
#import "MTPocket.h"
#import "constants.h"





@implementation MTPocketTestsDELETE




- (void)testDeleteJSON
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:STITCHES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatJSON
                                                         username:nil
                                                         password:nil
                                                             body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } }].synchronous;
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", jsonId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodDELETE
                                                          format:MTPocketFormatJSON
                                                        username:nil
                                                        password:nil
                                                            body:nil].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testDeleteJSONAuthenticated
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:NEEDLES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatJSON
                                                         username:UN
                                                         password:PW
                                                             body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } }].synchronous;
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"needles/%d", jsonId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodDELETE
                                                          format:MTPocketFormatJSON
                                                        username:UN
                                                        password:PW
                                                            body:nil].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"sharpness"] intValue] == 7, nil);
}

- (void)testDeleteXML
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:STITCHES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatXML
                                                         username:nil
                                                         password:nil
                                                             body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } }].synchronous;
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", xmlId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodDELETE
                                                          format:MTPocketFormatXML
                                                        username:nil
                                                        password:nil
                                                            body:nil].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"length"] intValue] == 3, nil);
}

- (void)testDeleteXMLAuthenticated
{
	MTPocketResponse *idresponse	= [MTPocketRequest requestForURL:NEEDLES_URL
                                                           method:MTPocketMethodPOST
                                                           format:MTPocketFormatXML
                                                         username:UN
                                                         password:PW
                                                             body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } }].synchronous;
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path					= [NSString stringWithFormat:@"needles/%d", xmlId];
	MTPocketResponse *response		= [MTPocketRequest requestForURL:[NSURL URLWithString:path relativeToURL:BASE_URL]
                                                          method:MTPocketMethodDELETE
                                                          format:MTPocketFormatXML
                                                        username:UN
                                                        password:PW
                                                            body:nil].synchronous;

	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"sharpness.@innerText"] intValue] == 7, nil);
}



@end
