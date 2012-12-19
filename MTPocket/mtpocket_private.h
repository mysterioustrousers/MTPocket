//
//  private.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocket.h"


@interface MTPocketRequest ()
@property (strong, nonatomic) MTPocketResponse  *response;
- (id)initWithURL:(NSURL *)URL;
- (NSMutableURLRequest *)requestWithResponse:(MTPocketResponse **)response;
@end


@interface MTPocketResponse ()
- (void)setStatusCode:(NSInteger)statusCode;
- (void)setStatus:(MTPocketStatus)status;
- (void)setError:(NSError *)error;
- (void)setRequestData:(NSData *)requestData;
- (void)setRequestText:(NSString *)requestText;
- (void)setRequest:(NSURLRequest *)request;
- (void)setFormat:(MTPocketFormat)format;
- (void)setData:(NSData *)data;
- (void)setRequestHeaders:(NSDictionary *)requestHeaders;
- (void)setMIMEType:(NSString *)MIMEType;
- (void)setExpectedContentLength:(NSInteger)expectedContentLength;
- (void)setFileDownloadedPath:(NSString *)fileDownloadedPath;
@end


@interface MTPocketResponse ()
@property BOOL isFileDownload;
@end
