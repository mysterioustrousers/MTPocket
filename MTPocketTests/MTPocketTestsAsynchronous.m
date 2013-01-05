//
//  MTPocketTestsAsynchronous.m
//  MTPocket
//
//  Created by Adam Kirk on 12/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTestsAsynchronous.h"
#import "MTPocket.h"
#import "constants.h"
#import "macros.h"



@implementation MTPocketTestsAsynchronous

- (void)setUp
{
    if (![MANAGER fileExistsAtPath:DOCS_DIR])
        [MANAGER createDirectoryAtPath:DOCS_DIR withIntermediateDirectories:YES attributes:nil error:nil];
}



- (void)testURLFormatSuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response = nil;


    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BASE_URL
                                                                    method:MTPocketMethodGET
                                                                    format:MTPocketFormatHTML
                                                                      body:nil
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       response = successResponse;
                                                                       successBlockCalled = YES;
                                                                   } failure:^(MTPocketResponse *response) {
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!successBlockCalled)

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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(successBlockCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)testURLMethodFormatBodySuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response = nil;


    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BASE_URL
                                                                    method:MTPocketMethodGET
                                                                    format:MTPocketFormatHTML
                                                                      body:nil
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       response = successResponse;
                                                                       successBlockCalled = YES;
                                                                   } failure:^(MTPocketResponse *response) {
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!successBlockCalled)

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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(successBlockCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)testURLMethodFormatUsernamePasswordBodySuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block MTPocketResponse *response = nil;


    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BASE_URL
                                                                    method:MTPocketMethodGET
                                                                    format:MTPocketFormatHTML
                                                                  username:UN
                                                                  password:PW
                                                                      body:nil
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       response = successResponse;
                                                                       successBlockCalled = YES;
                                                                   } failure:^(MTPocketResponse *response) {
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!successBlockCalled)

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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(successBlockCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)testURLDownloadProgressSuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block BOOL downloadProgressCalled = YES;
    __block MTPocketResponse *response = nil;

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BASE_URL
                                                          downloadProgress:^(float percent) {
                                                              downloadProgressCalled = YES;
                                                          }
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       response = successResponse;
                                                                       successBlockCalled = YES;
                                                                   }
                                                                   failure:^(MTPocketResponse *response) {
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!successBlockCalled);

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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(successBlockCalled, nil);
    STAssertTrue(downloadProgressCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);

}

- (void)testURLDestinationPathDownloadProgressSuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block BOOL downloadProgressCalled = NO;
    __block MTPocketResponse *response = nil;

    NSString *location = [DOCS_DIR stringByAppendingPathComponent:@"test.mp3"];

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:DOWNLOAD_FILE_URL
                                                           destinationPath:location
                                                          downloadProgress:^(float percent) {
                                                              downloadProgressCalled = YES;
                                                              // NSLog(@"downloading: %@/%@", @(bytesLoaded), @(bytesTotal));
                                                          }
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       response = successResponse;
                                                                       successBlockCalled = YES;
                                                                   }
                                                                   failure:^(MTPocketResponse *response) {
                                                                   }
                                   ].send;
    
    STAssertNotNil(connection, nil);

    STALL(!successBlockCalled)

    STAssertNotNil(response, nil);
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

    STAssertTrue(successBlockCalled, nil);
    STAssertTrue(downloadProgressCalled, nil);

    STAssertNotNil(response.fileDownloadedPath, nil);
    STAssertTrue([MANAGER fileExistsAtPath:response.fileDownloadedPath], nil);
}

- (void)testURLBodyUploadFilenameUploadFormFieldUploadMIMEtypeUploadProgressSuccessFailure
{
    __block BOOL successBlockCalled = NO;
    __block BOOL uploadProgressCalled = NO;
    __block MTPocketResponse *response = nil;

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *imagePath = [bundle pathForResource:@"test" ofType:@"jpg"];
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:imagePath options:0 error:&error];
    STAssertNil(error, nil);

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:UPLOAD_FILE_URL
                                                                    format:MTPocketFormatJSON
                                                                      body:fileData
                                                            uploadFilename:@"test.jpg"
                                                           uploadFormField:@"files[]"
                                                            uploadMIMEType:@"image/jpeg"
                                                            uploadProgress:^(float percent) {
                                                                uploadProgressCalled = YES;
                                                                // NSLog(@"uploading: %@/%@", @(bytesLoaded), @(bytesTotal));
                                                            }
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       response = successResponse;
                                                                       successBlockCalled = YES;
                                                                   }
                                                                   failure:^(MTPocketResponse *response) {
                                                                   }
                                   ].send;


    STAssertNotNil(connection, nil);

    STALL(!successBlockCalled);

    STAssertNotNil(response, nil);
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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(successBlockCalled, nil);
    STAssertTrue(uploadProgressCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}







#pragma mark - failures

- (void)test_FLUNK_URLFormatSuccessFailure
{
    __block BOOL failureBlockCalled = NO;
    __block MTPocketResponse *response = nil;

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BAD_URL
                                                                    format:MTPocketFormatHTML
                                                                   success:^(MTPocketResponse *response) {
                                                                   }
                                                                   failure:^(MTPocketResponse *failureResponse) {
                                                                       response = failureResponse;
                                                                       failureBlockCalled = YES;
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!failureBlockCalled)

    STAssertNotNil(response, nil);
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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(failureBlockCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}

- (void)test_FLUNK_URLMethodFormatBodySuccessFailure
{
    __block BOOL failureBlockCalled = NO;
    __block MTPocketResponse *response = nil;

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BAD_URL
                                                                    method:MTPocketMethodGET
                                                                    format:MTPocketFormatHTML
                                                                      body:nil
                                                                   success:^(MTPocketResponse *response) {
                                                                   }
                                                                   failure:^(MTPocketResponse *failureResponse) {
                                                                       response = failureResponse;
                                                                       failureBlockCalled = YES;
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!failureBlockCalled)

    STAssertNotNil(response, nil);
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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(failureBlockCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
}


- (void)test_FLUNK_URLDestinationPathDownloadProgressSuccessFailure
{
    __block BOOL failureBlockCalled = NO;
    __block BOOL downloadProgressCalled = NO;
    __block MTPocketResponse *response = nil;

    NSString *location = [DOCS_DIR stringByAppendingPathComponent:@"flunk/test.mp3"];

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:DOWNLOAD_FILE_URL
                                                           destinationPath:location
                                                          downloadProgress:^(float percent) {
                                                              downloadProgressCalled = YES;
                                                          }
                                                                   success:^(MTPocketResponse *response) {
                                                                   }
                                                                   failure:^(MTPocketResponse *failureResponse) {
                                                                       response = failureResponse;
                                                                       failureBlockCalled = YES;
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!failureBlockCalled);

    STAssertNotNil(response, nil);
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
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(failureBlockCalled, nil);
    STAssertTrue(downloadProgressCalled, nil);

    STAssertNil(response.fileDownloadedPath, nil);
    STAssertFalse([MANAGER fileExistsAtPath:response.fileDownloadedPath], nil);
}


- (void)test_FLUNK_URLBodyUploadFilenameUploadFormFieldUploadMIMETypeUploadProgressSuccessFailure
{
    __block BOOL failureBlockCalled = NO;
    __block BOOL uploadProgressCalled = NO;
    __block MTPocketResponse *response = nil;

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *imagePath = [bundle pathForResource:@"test" ofType:@"jpg"];
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:imagePath options:0 error:&error];
    STAssertNil(error, nil);

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BAD_URL
                                                                    format:MTPocketFormatJSON
                                                                      body:fileData
                                                            uploadFilename:@"test.jpg"
                                                           uploadFormField:@"files[]"
                                                            uploadMIMEType:@"image/jpeg"
                                                            uploadProgress:^(float percent) {
                                                                uploadProgressCalled = YES;
                                                            }
                                                                   success:^(MTPocketResponse *response) {
                                                                       NSLog(@"%@", response);
                                                                   }
                                                                   failure:^(MTPocketResponse *failureResponse) {
                                                                       response = failureResponse;
                                                                       failureBlockCalled = YES;
                                                                   }
                                   ].send;

    STAssertNotNil(connection, nil);

    STALL(!failureBlockCalled)

    STAssertNotNil(response, nil);
    STAssertFalse(response.success, nil);
    STAssertTrue(response.status == MTPocketStatusNotFound, nil);
    STAssertTrue(response.format == MTPocketFormatJSON, nil);
    STAssertNil(response.body, nil);

    STAssertNotNil(response.error, nil);
    STAssertNotNil(response.request, nil);
    STAssertNotNil(response.data, nil);
    STAssertNotNil(response.text, nil);
    STAssertNotNil(response.requestData, nil);
    STAssertNil(response.requestText, nil);
    STAssertTrue(response.statusCode == 404, nil);
    STAssertNotNil(response.MIMEType, nil);
    STAssertTrue(response.expectedContentLength > 0, nil);
    STAssertNotNil(response.responseHeaders, nil);

    STAssertTrue(failureBlockCalled, nil);
    STAssertTrue(uploadProgressCalled, nil);
    
    STAssertNil(response.fileDownloadedPath, nil);
}



@end
