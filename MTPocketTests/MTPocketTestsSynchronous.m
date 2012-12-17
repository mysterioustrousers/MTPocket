//
//  MTPocketTestsSynchronous.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsSynchronous.h"
#import "MTPocket.h"
#import "constants.h"



@implementation MTPocketTestsSynchronous

- (void)setUp
{
    if (![MANAGER fileExistsAtPath:DOCS_DIR])
        [MANAGER createDirectoryAtPath:DOCS_DIR withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)testURLFormat
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:BASE_URL
                                                         format:MTPocketFormatHTML].send;

    STAssertTrue(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
    STAssertTrue(response.format == MTPocketFormatHTML, nil);
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

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)testURLMethodFormatBody
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:BASE_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                           body:nil].send;

    STAssertTrue(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
    STAssertTrue(response.format == MTPocketFormatHTML, nil);
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

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)testURLMethodFormatUsernamePasswordBody
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:NEEDLES_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                       username:UN
                                                       password:PW
                                                           body:nil].send;

    STAssertTrue(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
    STAssertTrue(response.format == MTPocketFormatHTML, nil);
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

    STAssertNil(response.fileDownloadedPath, nil);
}








#pragma mark - failures

- (void)test_FLUNK_URLFormat
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:BAD_URL
                                                         format:MTPocketFormatHTML].send;

    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusNotFound, nil);
    STAssertTrue(response.format == MTPocketFormatHTML, nil);
    STAssertNotNil(response.body, nil);

    STAssertNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 404, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)test_FLUNK_URLMethodFormatBody
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:BAD_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                           body:nil].send;

    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusNotFound, nil);
    STAssertTrue(response.format == MTPocketFormatHTML, nil);
    STAssertNotNil(response.body, nil);

    STAssertNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 404, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)test_FLUNK_URLMethodFormatUsernamePasswordBody
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:NEEDLES_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatJSON
                                                       username:nil
                                                       password:nil
                                                           body:nil].send;

    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusUnauthorized, nil);
    STAssertTrue(response.format == MTPocketFormatJSON, nil);
    STAssertNil(response.body, nil);

    STAssertNotNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNil(response.data, nil);
    STAssertNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 401, nil);
    STAssertNil(response.MIMEType, nil);
    STAssertFalse(response.expectedContentLength > 0, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}



@end
