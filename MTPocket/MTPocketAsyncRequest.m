//
//  MTPocketAsyncRequest.m
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketAsyncRequest.h"
#import "mtpocket_private.h"


@interface MTPocketAsyncRequest ()
@property (strong, nonatomic) void          (^successHandler)(MTPocketResponse *response);
@property (strong, nonatomic) void          (^failureHandler)(MTPocketResponse *response);
@property (strong, nonatomic) NSString      *fileDownloadPath;
@property (strong, nonatomic) NSString      *fileUploadTitle;                               // The filename of the file being uploaded.
@property (strong, nonatomic) NSString      *fileUploadFormField;                           // The name of the form field this file is being uploaded with.
@property (strong, nonatomic) NSString      *fileUploadMIMEType;                            // The Content-Type of the file being uploaded.
@property (strong, nonatomic) NSMutableData *mutableData;
@end





@implementation MTPocketAsyncRequest


+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      format:(MTPocketFormat)format
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self asyncRequestForURL:URL
                             method:MTPocketMethodGET
                             format:format
                               body:nil
                            success:successBlock
                            failure:failureBlock];
}

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      method:(MTPocketMethod)method
                                      format:(MTPocketFormat)format
                                        body:(id)body
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self asyncRequestForURL:URL
                             method:method
                             format:format
                           username:nil
                           password:nil
                               body:body
                     uploadFilename:nil
                    uploadFormField:nil
                     uploadMIMEType:nil
                     downloadToFile:nil
                     uploadProgress:nil
                   downloadProgress:nil
                            success:successBlock
                            failure:failureBlock];
}

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      method:(MTPocketMethod)method
                                      format:(MTPocketFormat)format
                                    username:(NSString *)username
                                    password:(NSString *)password
                                        body:(id)body
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock
{

    return [self asyncRequestForURL:URL
                             method:method
                             format:format
                           username:username
                           password:password
                               body:body
                     uploadFilename:nil
                    uploadFormField:nil
                     uploadMIMEType:nil
                     downloadToFile:nil
                     uploadProgress:nil
                   downloadProgress:nil
                            success:successBlock
                            failure:failureBlock];
}

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                            downloadProgress:(void (^)(float percent))downloadProgressBlock
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self asyncRequestForURL:URL
                    destinationPath:nil
                   downloadProgress:downloadProgressBlock
                            success:successBlock
                            failure:failureBlock];
}

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                             destinationPath:(NSString *)filePath
                            downloadProgress:(void (^)(float percent))downloadProgressBlock
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self asyncRequestForURL:URL
                             method:MTPocketMethodGET
                             format:MTPocketFormatHTML
                           username:nil
                           password:nil
                               body:nil
                     uploadFilename:nil
                    uploadFormField:nil
                     uploadMIMEType:nil
                     downloadToFile:filePath
                     uploadProgress:nil
                   downloadProgress:downloadProgressBlock
                            success:successBlock
                            failure:failureBlock];
}

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      format:(MTPocketFormat)format
                                        body:(id)body
                              uploadFilename:(NSString *)filename
                             uploadFormField:(NSString *)fieldName
                              uploadMIMEType:(NSString *)MIMEType
                              uploadProgress:(void (^)(float percent))uploadProgressBlock
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self asyncRequestForURL:URL
                             method:MTPocketMethodPOST
                             format:format
                           username:nil
                           password:nil
                               body:body
                     uploadFilename:filename
                    uploadFormField:fieldName
                     uploadMIMEType:MIMEType
                     downloadToFile:nil
                     uploadProgress:uploadProgressBlock
                   downloadProgress:nil
                            success:successBlock
                            failure:failureBlock];
}





- (NSURLConnection *)send
{
    // create the response
    MTPocketResponse *response = [[MTPocketResponse alloc] init];
    NSMutableURLRequest *request = [self requestWithResponse:&response];
    self.response = response;


    if ([NSURLConnection canHandleRequest:request]) {
        _mutableData = [NSMutableData data];
        return [NSURLConnection connectionWithRequest:request delegate:self];
    }

    else {
        self.response.status = MTPocketStatusNoConnection;
        if (_failureHandler) _failureHandler(self.response);
        return nil;
    }
}






#pragma mark - Private

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      method:(MTPocketMethod)method
                                      format:(MTPocketFormat)format
                                    username:(NSString *)username
                                    password:(NSString *)password
                                        body:(id)body
                              uploadFilename:(NSString *)filename
                             uploadFormField:(NSString *)fieldName
                              uploadMIMEType:(NSString *)MIMEType
                              downloadToFile:(NSString *)filePath
                              uploadProgress:(void (^)(float percent))uploadProgressBlock
                            downloadProgress:(void (^)(float percent))downloadProgressBlock
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock
{
    MTPocketAsyncRequest *request       = [[MTPocketAsyncRequest alloc] initWithURL:URL];
    request.method                      = method;
    request.format                      = format;
    request.username                    = username;
    request.password                    = password;
    request.body                        = body;
    request.fileUploadTitle             = filename;
    request.fileUploadFormField         = fieldName;
    request.fileUploadMIMEType          = MIMEType;
    request.fileDownloadPath            = filePath;
    request.uploadProgressHandler       = uploadProgressBlock;
    request.downloadProgressHandler     = downloadProgressBlock;
    request.successHandler              = successBlock;
    request.failureHandler              = failureBlock;
    return  request;
}

- (NSMutableURLRequest *)requestWithResponse:(MTPocketResponse **)response
{
    NSMutableURLRequest *request = [super requestWithResponse:response];

    if (_fileUploadFormField && _fileUploadTitle && _fileUploadMIMEType) {
        NSString *boundary      = @"----WebKitFormBoundary9HN3IwANdrhDGAN4";
        NSString *contentType   = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];

        NSMutableData *postbody = [NSMutableData data];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", _fileUploadFormField, _fileUploadTitle] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", _fileUploadMIMEType] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:self.body];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", postbody.length] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postbody];
    }

    (*response).isFileDownload = _fileDownloadPath != nil;

    return request;
}






#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.response.error = error;
    if (_failureHandler) _failureHandler(self.response);
}



#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.response.statusCode            = response.statusCode;
    self.response.MIMEType              = response.MIMEType;
    self.response.responseHeaders       = response.allHeaderFields;

    self.response.expectedContentLength = response.expectedContentLength;
    if (self.lengthHeader || (self.lengthHeader && response.expectedContentLength == NSURLResponseUnknownLength)) {
        NSString *length = self.response.responseHeaders[self.lengthHeader];
        if (length) self.response.expectedContentLength = [length integerValue];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
    if (_downloadProgressHandler) {
        NSNumber *loaded    = @([_mutableData length]);
        NSNumber *total     = @(self.response.expectedContentLength);
        _downloadProgressHandler([loaded floatValue] / [total floatValue]);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.response.data                  = _mutableData;
    self.response.fileDownloadedPath    = _fileDownloadPath;

    if (self.response.success && _successHandler)       _successHandler(self.response);
    else if (!self.response.success && _failureHandler) _failureHandler(self.response);
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (_uploadProgressHandler) _uploadProgressHandler(totalBytesWritten / totalBytesExpectedToWrite);
}


@end
