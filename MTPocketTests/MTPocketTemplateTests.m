//
//  MTPocketTemplateTests.m
//  MTPocket
//
//  Created by Adam Kirk on 2/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTemplateTests.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"


@implementation MTPocketTemplateTests

- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = BASE_URL;

    MTPocketRequest *template = [MTPocketRequest requestTemplate];
    template.format = MTPocketFormatJSON;
//    template.timeout = 2;
    [template addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];
    [template.params addEntriesFromDictionary:@{ @"sessionId": @"fewoijalkfsdjlfsdhlaes" }];
    [[MTPocket sharedPocket] addTemplateWithRequest:template name:@"api"];
}

- (void)testUseTemplate
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response;

    MTPocketRequest *request = [[MTPocket sharedPocket] requestWithTemplate:@"api" path:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
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
    XCTAssertTrue([[response.request.URL absoluteString] isEqualToString:MAKE_URL(@"/needles?sessionId=fewoijalkfsdjlfsdhlaes")]);
}


@end
