//
//  MTPocketResponse.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketRequest.h"

/**
 MTPocketStatus
 A mapping of common HTTP status codes for easier use.
 */
typedef enum {
    MTPocketStatusSuccess,          // 200..299
	MTPocketStatusCreated,          // 201
    MTPocketStatusNoContent,        // 204
    MTPocketStatusUnauthorized,     // 401
    MTPocketStatusUnprocessable,    // 422
	MTPocketStatusNotFound,         // 404
    MTPocketStatusTimedOut,         // 408
    MTPocketStatusServerError,      // 500..599
	MTPocketStatusNoConnection,
	MTPocketStatusOther,
} MTPocketStatus;


@interface MTPocketResponse : NSObject

@property (nonatomic, readonly)         BOOL              success;                 // Easily determine if the request was 100% sucessful. Otherwise, lots of data in other properties to deal with the failure.
@property (nonatomic, readonly)         MTPocketStatus    status;                  // A Mapping of common HTTP status codes to enum.
@property (nonatomic, readonly)         MTPocketFormat    format;                  // The format of the original content. Will always be the same as the request format.
@property (nonatomic, readonly, strong) id                body;                    // The response body. Depending on the format, could be an NSString, NSArray, NSDictionary or nil.

@property (nonatomic, readonly, strong) NSError           *error;                  // Could be nil, but should check this for important info if its not nil.
@property (nonatomic, readonly, strong) NSURLRequest      *request;                // The original request made to the server (for debugging).
@property (nonatomic, readonly, strong) MTPocketRequest   *pocketRequest;          // The original request made to the server (for debugging).
@property (nonatomic, readonly, strong) NSData            *data;                   // The data returned form the server (for debugging).
@property (nonatomic, readonly, strong) NSString          *text;                   // The data converted to a string returned form the server (for debugging).
@property (nonatomic, readonly, strong) NSData            *requestData;            // The data that was sent as the body with the request (for debugging).
@property (nonatomic, readonly, strong) NSString          *requestText;            // The data sent with the request converted to a string (for debugging).
@property (nonatomic, readonly, strong) NSDictionary      *requestHeaders;
@property (nonatomic, readonly, strong) NSDictionary      *responseHeaders;
@property (nonatomic, readonly)         NSInteger         statusCode;              // The actual integer status code of the response.
@property (nonatomic, readonly, strong) NSString          *MIMEType;               // What the server reports as the content type of the response.
@property (nonatomic, readonly)         long long         expectedContentLength;   // What the server reports as the expected content length of the response.

@end
