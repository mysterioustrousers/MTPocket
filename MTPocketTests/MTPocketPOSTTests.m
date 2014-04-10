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
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodPOST body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } } params:nil];
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
	XCTAssertTrue(response.status == MTPocketStatusCreated);
	XCTAssertNotNil(response.body);
	XCTAssertTrue([response.body count] > 0);
}

- (void)testPostJSONWithDateObject
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodPOST body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3, @"updated_at" : [NSDate date] } } params:nil];
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
	XCTAssertTrue(response.status == MTPocketStatusCreated);
	XCTAssertNotNil(response.body);
	XCTAssertTrue([response.body count] > 0);
}


- (void)testPostJSONAuthenticated
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodPOST body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } } params:nil];
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
	XCTAssertTrue(response.status == MTPocketStatusCreated);
	XCTAssertNotNil(response.body);
	XCTAssertTrue([response.body count] > 0);
}

@end
