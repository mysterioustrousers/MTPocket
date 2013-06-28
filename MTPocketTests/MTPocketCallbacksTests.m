//
//  MTPocketTestsAsynchronous.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketCallbacksTests.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"



@implementation MTPocketCallbacksTests
//
- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = BASE_URL;
}



- (void)testSuccessHandler
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response = nil;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitches" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatJSON;

    [request sendWithSuccess:^(MTPocketResponse *resp) {
       response             = resp;
       successBlockCalled   = YES;
    } failure:^(MTPocketResponse *response) {
        STFail(@"Request Failed");
        successBlockCalled = YES;
    }];

    STALL(!successBlockCalled)

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

- (void)testFailureHandler
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response = nil;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitchess" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatJSON;

    [request sendWithSuccess:^(MTPocketResponse *resp) {
        STFail(@"Request succeeded when it should have failed");
        blockCalled = YES;
    } failure:^(MTPocketResponse *resp) {
        blockCalled  = YES;
        response     = resp;
    }];

    STALL(!blockCalled)

    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusNotFound, nil);
    STAssertTrue(response.format == MTPocketFormatJSON, nil);
    STAssertNil(response.body, nil);

    STAssertNotNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 404, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);
    STAssertNotNil(response.responseHeaders, nil);
}

- (void)testDownloadProgress
{
    __block BOOL successBlockCalled = NO;
    __block BOOL downloadProgressCalled = YES;
    __block MTPocketResponse *response = nil;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:DOWNLOAD_FILE_PATH identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatHTML;
    request.baseURL = DOWNLOAD_FILE_BASE;

    [request sendWithSuccess:^(MTPocketResponse *resp) {
        response = resp;
        successBlockCalled = YES;
    } failure:^(MTPocketResponse *response) {
        STFail(@"Request Failed");
        successBlockCalled = YES;
    } uploadProgress:^(float percent) {
        STFail(@"Upload progress was called");
        downloadProgressCalled = YES;
    } downloadProgress:^(float percent) {
        downloadProgressCalled = YES;
    }];

    STALL(!successBlockCalled);

    STAssertTrue(successBlockCalled, nil);
    STAssertTrue(downloadProgressCalled, nil);

    STAssertTrue(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
    STAssertTrue(response.format == MTPocketFormatHTML, nil);
    STAssertNil(response.body, nil);

    STAssertNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 200, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);
    STAssertNotNil(response.responseHeaders, nil);
}

//- (void)testUploadFile
//{
//    __block BOOL successBlockCalled = NO;
//    __block BOOL uploadProgressCalled = NO;
//    __block MTPocketResponse *response = nil;
//
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//	NSString *imagePath = [bundle pathForResource:@"test" ofType:@"jpg"];
//    NSError *error = nil;
//    NSData *fileData = [NSData dataWithContentsOfFile:imagePath options:0 error:&error];
//    STAssertNil(error, nil);
//
//    MTPocketRequest *request = [MTPocketRequest requestWithPath:nil identifiers:nil method:MTPocketMethodPOST body:nil params:nil];
//    request.format  = MTPocketFormatJSON;
//    request.baseURL = UPLOAD_FILE_URL;
//
//    [request sendFileData:fileData
//                 filename:@"test.jpg"
//                formField:@"files[]"
//                 MIMEType:@"image/jpeg"
//                  success:^(MTPocketResponse *resp) {
//                      response = resp;
//                      successBlockCalled = YES;
//                 } failure:^(MTPocketResponse *response) {
//                     STFail(@"Request Failed");
//                     uploadProgressCalled = YES;
//                 } uploadProgress:^(float percent) {
//                     uploadProgressCalled = YES;
//                 }];
//
//
//    STALL(!successBlockCalled);
//
//    STAssertTrue(successBlockCalled, nil);
//    STAssertTrue(uploadProgressCalled, nil);
//
//    STAssertNotNil(response, nil);
//    STAssertTrue(response.success, nil);
//    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
//    STAssertTrue(response.format == MTPocketFormatJSON, nil);
//    STAssertNotNil(response.body, nil);
//
//    STAssertNil(response.error, nil);
//    STAssertNotNil(response.request, nil);
//    STAssertNotNil(response.data, nil);
//    STAssertNotNil(response.text, nil);
//    STAssertNotNil(response.requestData, nil);
//    STAssertNil(response.requestText, nil);
//    STAssertTrue(response.statusCode == 200, nil);
//    STAssertNotNil(response.MIMEType, nil);
//    STAssertTrue(response.expectedContentLength > 0, nil);
//    STAssertNotNil(response.responseHeaders, nil);
//}

- (void)testCompleteHandler
{
    __block BOOL blockCalled = NO;
    __block MTPocketResponse *response = nil;

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"stitchess" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatJSON;

    [request addComplete:^(MTPocketResponse *resp) {
        blockCalled = YES;
        response    = resp;
    }];

    [request sendWithSuccess:^(MTPocketResponse *resp) {
        STFail(@"Request succeeded when it should have failed");
        blockCalled = YES;
    } failure:^(MTPocketResponse *resp) {
    }];

    STALL(!blockCalled)

    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusNotFound, nil);
    STAssertTrue(response.format == MTPocketFormatJSON, nil);
    STAssertNil(response.body, nil);

    STAssertNotNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 404, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);
    STAssertNotNil(response.responseHeaders, nil);

}








@end
