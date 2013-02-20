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
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatHTML;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body length] > 0, nil);
}

- (void)testGetHTMLAuthenticated
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatHTML;
    [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];

    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body length] > 0, nil);
}

- (void)testGetJSON
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatJSON;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testGetJSONAuthenticated
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
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
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testGetXML
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatXML;


    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testGetXMLAuthenticated
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
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
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}



@end
