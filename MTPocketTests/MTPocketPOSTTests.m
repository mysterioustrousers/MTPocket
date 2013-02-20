//
//  MTPocketTestsPOST.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketPOSTTests.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"




@implementation MTPocketPOSTTests


- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = BASE_URL;
}

- (void)testPostJSON
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodPOST body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } } params:nil];
    request.format = MTPocketFormatJSON;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testPostJSONWithDateObject
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodPOST body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3, @"updated_at" : [NSDate date] } } params:nil];
    request.format = MTPocketFormatJSON;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}


- (void)testPostJSONAuthenticated
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodPOST body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } } params:nil];
    request.format = MTPocketFormatJSON;
    [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testPostXML
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodPOST body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } } params:nil];
    request.format = MTPocketFormatXML;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testPutXMLAuthenticated
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodPOST body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } } params:nil];
    request.format = MTPocketFormatXML;
    [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];

    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}


@end
