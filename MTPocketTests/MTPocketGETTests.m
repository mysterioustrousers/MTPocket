//
//  MTPocketTestsAuthentication.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketGETTests.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"



@implementation MTPocketGETTests

- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = BASE_URL;
}

- (void)testGetHTML
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatHTML;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        blockCalled = YES;
    } failure:^(MTPocketResponse *response) {
        blockCalled = YES;
    }];

    STALL(!blockCalled)

    XCTAssertTrue(response.success);
	XCTAssertNil(response.error);
	XCTAssertTrue(response.status == MTPocketStatusSuccess);
	XCTAssertNotNil(response.body);
	XCTAssertTrue([response.body length] > 0);
}

- (void)testGetHTMLAuthenticated
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatHTML;
    [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];

    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        blockCalled = YES;
    } failure:^(MTPocketResponse *response) {
        blockCalled = YES;
    }];

    STALL(!blockCalled)

    XCTAssertTrue(response.success);
	XCTAssertNil(response.error);
	XCTAssertTrue(response.status == MTPocketStatusSuccess);
	XCTAssertNotNil(response.body);
	XCTAssertTrue([response.body length] > 0);
}

- (void)testGetJSON
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatJSON;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        blockCalled = YES;
    } failure:^(MTPocketResponse *response) {
        blockCalled = YES;
    }];

    STALL(!blockCalled)

    XCTAssertTrue(response.success);
	XCTAssertNil(response.error);
	XCTAssertTrue(response.status == MTPocketStatusSuccess);
	XCTAssertNotNil(response.body);
	XCTAssertTrue([response.body count] > 0);
}

- (void)testGetJSONAuthenticated
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatJSON;
    [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];

    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        blockCalled = YES;
    } failure:^(MTPocketResponse *response) {
        blockCalled = YES;
    }];

    STALL(!blockCalled)

    XCTAssertTrue(response.success);
	XCTAssertNil(response.error);
	XCTAssertTrue(response.status == MTPocketStatusSuccess);
	XCTAssertNotNil(response.body);
	XCTAssertTrue([response.body count] > 0);
}

@end
