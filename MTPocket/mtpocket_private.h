//
//  mtpocket_private.h
//  MTPocket
//
//  Created by Adam Kirk on 2/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocket.h"

#ifndef MTPocket_mtpocket_private_h
#define MTPocket_mtpocket_private_h

@interface MTPocketResponse ()
@property (nonatomic,         readwrite) NSInteger       statusCode;
@property (nonatomic,         readwrite) MTPocketStatus  status;
@property (nonatomic, strong, readwrite) NSError         *error;
@property (nonatomic, strong, readwrite) NSData          *requestData;
@property (nonatomic, strong, readwrite) NSString        *requestText;
@property (nonatomic, strong, readwrite) id              requestBody;              // The body sent with the request (for debugging).
@property (nonatomic, strong, readwrite) NSURLRequest    *request;
@property (nonatomic, strong, readwrite) MTPocketRequest *pocketRequest;
@property (nonatomic,         readwrite) MTPocketFormat  format;
@property (nonatomic, strong, readwrite) NSData          *data;
@property (nonatomic, strong, readwrite) NSDictionary    *requestHeaders;
@property (nonatomic, strong, readwrite) NSDictionary    *responseHeaders;
@property (nonatomic, strong, readwrite) NSString        *MIMEType;
@property (nonatomic,         readwrite) long long       expectedContentLength;
@end


#endif
