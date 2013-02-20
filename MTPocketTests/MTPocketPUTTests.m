//
//  MTPocketTestsPUT.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketPUTTests.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"




@implementation MTPocketPUTTests


- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = BASE_URL;
}

- (void)testPutJSON
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodPOST body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } } params:nil];
    request.format = MTPocketFormatJSON;


    [request sendWithSuccess:^(MTPocketResponse *res) {
        NSInteger jsonId = [res.body[@"id"] intValue];
        MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches/:id" identifiers:@[ @(jsonId) ] method:MTPocketMethodPUT body:@{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } } params:nil];
        [request sendWithSuccess:^(MTPocketResponse *resp) {
            response = resp;
            successBlockCalled = YES;
        } failure:^(MTPocketResponse *response) {

        }];
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testPutJSONAuthenticated
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodPOST body:@{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } } params:nil];
    request.format = MTPocketFormatJSON;
    [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];


    [request sendWithSuccess:^(MTPocketResponse *res) {
        NSInteger jsonId = [res.body[@"id"] intValue];
        MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles/:id" identifiers:@[ @(jsonId) ] method:MTPocketMethodPUT body:@{ @"needle" : @{ @"sharpness" : @1, @"length" : @1 } } params:nil];
        request.format = MTPocketFormatJSON;
        [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];
        [request sendWithSuccess:^(MTPocketResponse *resp) {
            response = resp;
            successBlockCalled = YES;
        } failure:^(MTPocketResponse *response) {

        }];
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testPutXML
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodPOST body:@{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } } params:nil];
    request.format = MTPocketFormatXML;


    [request sendWithSuccess:^(MTPocketResponse *res) {

        NSInteger jsonId = [[res.body valueForKeyPath:@"id.@innerText"] intValue];
        MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches/:id" identifiers:@[ @(jsonId) ] method:MTPocketMethodPUT body:@{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } } params:nil];
        request.format = MTPocketFormatXML;
        [request sendWithSuccess:^(MTPocketResponse *resp) {
            response = resp;
            successBlockCalled = YES;
        } failure:^(MTPocketResponse *response) {

        }];
    } failure:^(MTPocketResponse *response) {

    }];

    STALL(!successBlockCalled)

    STAssertTrue(response.success, nil);
	STAssertNil(response.error, nil);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
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


    [request sendWithSuccess:^(MTPocketResponse *res) {
        NSInteger jsonId = [[res.body valueForKeyPath:@"id.@innerText"] intValue];
        MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles/:id" identifiers:@[ @(jsonId) ] method:MTPocketMethodPUT body:@{ @"needle" : @{ @"sharpness" : @1, @"length" : @1 } } params:nil];
        request.format = MTPocketFormatXML;
        [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];
        [request sendWithSuccess:^(MTPocketResponse *resp) {
            response = resp;
            successBlockCalled = YES;
        } failure:^(MTPocketResponse *response) {

        }];
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
