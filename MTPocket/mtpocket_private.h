//
//  private.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocket.h"


@interface MTPocketRequest ()
@property (nonatomic, strong) MTPocketResponse  *response;
- (id)initWithURL:(NSURL *)URL;
- (NSMutableURLRequest *)requestWithResponse:(MTPocketResponse **)response;
@end


@interface MTPocketResponse ()
@property (nonatomic, readwrite)            NSInteger       statusCode;
@property (nonatomic, readwrite)            MTPocketStatus  status;
@property (nonatomic, readwrite, strong)    NSError         *error;
@property (nonatomic, readwrite, strong)    NSData          *requestData;
@property (nonatomic, readwrite, strong)    NSString        *requestText;
@property (nonatomic, readwrite, strong)    NSURLRequest    *request;
@property (nonatomic, readwrite)            MTPocketFormat  format;
@property (nonatomic, readwrite, strong)    NSData          *data;
@property (nonatomic, readwrite, strong)    NSDictionary    *requestHeaders;
@property (nonatomic, readwrite, strong)    NSDictionary    *responseHeaders;
@property (nonatomic, readwrite, strong)    NSString        *MIMEType;
@property (nonatomic, readwrite)            NSInteger       expectedContentLength;
@property (nonatomic, readwrite, strong)    NSString        *fileDownloadedPath;
@end


@interface MTPocketResponse ()
@property BOOL isFileDownload;
@end
