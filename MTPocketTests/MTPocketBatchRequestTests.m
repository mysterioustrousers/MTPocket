//
//  MTPocketBatchRequestTests.m
//  MTPocket
//
//  Created by Adam Kirk on 3/9/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketBatchRequestTests.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"



@implementation MTPocketBatchRequestTests

- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = BASE_URL;
}


- (void)testBatchRequests
{
    __block BOOL successBlockCalled = NO;
    __block BOOL completeBlockCalled = NO;
    __block MTPocketResponse *response = nil;

    MTPocketRequest *request1 = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    MTPocketRequest *request2 = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    MTPocketRequest *request3 = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];

    [MTPocketRequest sendBatchRequests:@[ request1, request2, request3 ]
                               success:^(MTPocketRequest *request, MTPocketResponse *resp) {
                                   response = resp;
                                   successBlockCalled = YES;
                               } failure:^(MTPocketRequest *request, MTPocketResponse *resp) {

                               } allComplete:^(BOOL allSuccessful) {
                                   completeBlockCalled = YES;
                               }];


    STALL(!completeBlockCalled)

    STAssertTrue(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
    STAssertTrue(response.format == MTPocketFormatJSON, nil);
    STAssertNotNil(response.body, nil);

    STAssertNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 200, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);
    STAssertNotNil(response.responseHeaders, nil);
}

@end
