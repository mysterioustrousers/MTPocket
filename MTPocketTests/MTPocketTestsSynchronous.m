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
                                                         format:MTPocketFormatHTML].synchronous;

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
                                                           body:nil].synchronous;

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
                                                           body:nil].synchronous;

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

- (void)testURLMethodFormatBodySuccessFailure
{
    __block BOOL successBlockCalled = NO;

    MTPocketResponse *response = [MTPocketRequest requestForURL:BASE_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                           body:nil
                                                        success:^(MTPocketResponse *response) {
                                                            successBlockCalled = YES;
                                                        } failure:^(MTPocketResponse *response) {

                                                        }].synchronous;


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

    STAssertTrue(successBlockCalled, nil);
    
    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)testURLMethodFormatBodyDownloadToFileNilDownloadProgressSuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block BOOL downloadProgressCalled = YES;

    MTPocketResponse *response = [MTPocketRequest requestForURL:BASE_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                           body:nil
                                                 downloadToFile:nil
                                               downloadProgress:^(long long bytesLoaded, long long bytesTotal) {
                                                   downloadProgressCalled = YES;
                                               }
                                                        success:^(MTPocketResponse *response) {
                                                            successBlockCalled = YES;
                                                        }
                                                        failure:^(MTPocketResponse *response) {

                                                        }
                                  ].synchronous;

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

    STAssertTrue(successBlockCalled, nil);
    STAssertTrue(downloadProgressCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);

}

- (void)testURLMethodFormatBodyDownloadToFileDownloadProgressSuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block BOOL downloadProgressCalled = NO;

    NSString *location = [DOCS_DIR stringByAppendingPathComponent:@"test.mp3"];

    MTPocketResponse *response = [MTPocketRequest requestForURL:DOWNLOAD_FILE_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                           body:nil
                                                 downloadToFile:location
                                               downloadProgress:^(long long bytesLoaded, long long bytesTotal) {
                                                   downloadProgressCalled = YES;
                                               }
                                                        success:^(MTPocketResponse *response) {
                                                            successBlockCalled = YES;
                                                        }
                                                        failure:^(MTPocketResponse *response) {

                                                        }
                                  ].synchronous;

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

    STAssertTrue(successBlockCalled, nil);
    STAssertTrue(downloadProgressCalled, nil);

    STAssertNotNil(response.fileDownloadedPath, nil);
    STAssertTrue([MANAGER fileExistsAtPath:response.fileDownloadedPath], nil);
}

- (void)testURLMethodFormatBodyUploadFilenameUploadFormFieldUploadMIMETypeUploadProgressSuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block BOOL uploadProgressCalled = NO;

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *imagePath = [bundle pathForResource:@"test" ofType:@"jpg"];
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:imagePath options:0 error:&error];
    STAssertNil(error, nil);

    MTPocketResponse *response = [MTPocketRequest requestForURL:UPLOAD_FILE_URL
                                                         method:MTPocketMethodFILE
                                                         format:MTPocketFormatJSON
                                                           body:fileData
                                                 uploadFilename:@"test.jpg"
                                                uploadFormField:@"files[]"
                                                 uploadMIMEType:@"image/jpeg"
                                                 uploadProgress:^(long long bytesLoaded, long long bytesTotal) {
                                                     uploadProgressCalled = YES;
                                                 }
                                                        success:^(MTPocketResponse *response) {
                                                            successBlockCalled = YES;
                                                        }
                                                        failure:^(MTPocketResponse *response) {

                                                        }
                                  ].synchronous;

    STAssertTrue(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
    STAssertTrue(response.format == MTPocketFormatJSON, nil);
    STAssertNotNil(response.body, nil);

    STAssertNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNotNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 200, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);

    STAssertTrue(successBlockCalled, nil);
    STAssertTrue(uploadProgressCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}







#pragma mark - failures

- (void)test_FLUNK_URLFormat
{
    MTPocketResponse *response = [MTPocketRequest requestForURL:BAD_URL
                                                         format:MTPocketFormatHTML].synchronous;

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
                                                           body:nil].synchronous;

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
                                                           body:nil].synchronous;

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

- (void)test_FLUNK_URLMethodFormatBodySuccessFailure
{
    __block BOOL failureBlockCalled = NO;

    MTPocketResponse *response = [MTPocketRequest requestForURL:BAD_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                           body:nil
                                                        success:^(MTPocketResponse *response) {
                                                        }
                                                        failure:^(MTPocketResponse *response) {
                                                            failureBlockCalled = YES;
                                                        }
                                  ].synchronous;


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

    STAssertTrue(failureBlockCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}


- (void)test_FLUNK_URLMethodFormatBodyDownloadToFileDownloadProgressSuccessFailure
{
    __block BOOL failureBlockCalled = NO;
    __block BOOL downloadProgressCalled = NO;

    NSString *location = [DOCS_DIR stringByAppendingPathComponent:@"flunk/test.mp3"];

    MTPocketResponse *response = [MTPocketRequest requestForURL:DOWNLOAD_FILE_URL
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatHTML
                                                           body:nil
                                                 downloadToFile:location
                                               downloadProgress:^(long long bytesLoaded, long long bytesTotal) {
                                                   downloadProgressCalled = YES;
                                               }
                                                        success:^(MTPocketResponse *response) {
                                                        }
                                                        failure:^(MTPocketResponse *response) {
                                                            failureBlockCalled = YES;
                                                        }
                                  ].synchronous;

    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusSuccess, nil);
    STAssertTrue(response.format == MTPocketFormatHTML, nil);
    STAssertNil(response.body, nil);

    STAssertNotNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNil(response.text, nil);
    STAssertNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 200, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);

    STAssertTrue(failureBlockCalled, nil);
    STAssertTrue(downloadProgressCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
    STAssertFalse([MANAGER fileExistsAtPath:response.fileDownloadedPath], nil);
}


- (void)test_FLUNK_URLMethodFormatBodyUploadFilenameUploadFormFieldUploadMIMETypeUploadProgressSuccessFailure
{
    __block BOOL failureBlockCalled = NO;
    __block BOOL uploadProgressCalled = NO;

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *imagePath = [bundle pathForResource:@"test" ofType:@"jpg"];
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:imagePath options:0 error:&error];
    STAssertNil(error, nil);

    MTPocketResponse *response = [MTPocketRequest requestForURL:UPLOAD_FILE_URL
                                                         method:MTPocketMethodPOST
                                                         format:MTPocketFormatJSON
                                                           body:fileData
                                                 uploadFilename:@"test.jpg"
                                                uploadFormField:@"files[]"
                                                 uploadMIMEType:@"image/jpeg"
                                                 uploadProgress:^(long long bytesLoaded, long long bytesTotal) {
                                                     uploadProgressCalled = YES;
                                                 }
                                                        success:^(MTPocketResponse *response) {
                                                        }
                                                        failure:^(MTPocketResponse *response) {
                                                            failureBlockCalled = YES;
                                                        }
                                  ].synchronous;

    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusServerError, nil);
    STAssertTrue(response.format == MTPocketFormatJSON, nil);
    STAssertNil(response.body, nil);

    STAssertNotNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNotNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 500, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertFalse(response.expectedContentLength > 0, nil);

    STAssertTrue(failureBlockCalled, nil);
    STAssertTrue(uploadProgressCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}


@end
