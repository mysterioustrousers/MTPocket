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
@property (nonatomic, readwrite)            NSInteger       statusCode;
@property (nonatomic, readwrite)            MTPocketStatus  status;
@property (nonatomic, readwrite, strong)    NSError         *error;
@property (nonatomic, readwrite, strong)    NSData          *requestData;
@property (nonatomic, readwrite, strong)    NSString        *requestText;
@property (nonatomic, readwrite, strong)    NSURLRequest    *request;
@property (nonatomic, readwrite, strong)    MTPocketRequest *pocketRequest;
@property (nonatomic, readwrite)            MTPocketFormat  format;
@property (nonatomic, readwrite, strong)    NSData          *data;
@property (nonatomic, readwrite, strong)    NSDictionary    *requestHeaders;
@property (nonatomic, readwrite, strong)    NSDictionary    *responseHeaders;
@property (nonatomic, readwrite, strong)    NSString        *MIMEType;
@property (nonatomic, readwrite)            NSUInteger      expectedContentLength;
@end


#endif
