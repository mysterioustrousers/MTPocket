//
//  MTPocketResponse.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketRequest.h"


@interface MTPocketResponse : NSObject

@property (readonly) BOOL              success;                 // Easily determine if the request was 100% sucessful. Otherwise, lots of data in other properties to deal with the failure.
@property (readonly) MTPocketStatus    status;                  // A Mapping of common HTTP status codes to enum.
@property (readonly) MTPocketFormat    format;                  // The format of the original content. Will always be the same as the request format.
@property (readonly) id                body;                    // The response body. Depending on the format, could be an NSString, NSArray, NSDictionary or nil.

@property (readonly) NSError           *error;                  // Could be nil, but should check this for important info if its not nil.
@property (readonly) NSURLRequest      *request;                // The original request made to the server (for debugging).
@property (readonly) NSData            *data;                   // The data returned form the server (for debugging).
@property (readonly) NSString          *text;                   // The data converted to a string returned form the server (for debugging).
@property (readonly) NSData            *requestData;            // The data that was sent as the body with the request (for debugging).
@property (readonly) NSString          *requestText;            // The data sent with the request converted to a string (for debugging).
@property (readonly) NSDictionary      *requestHeaders;
@property (readonly) NSInteger         statusCode;              // The actual integer status code of the response.
@property (readonly) NSString          *MIMEType;               // What the server reports as the content type of the response.
@property (readonly) NSInteger         expectedContentLength;   // What the server reports as the expected content length of the response.
@property (readonly) NSString          *fileDownloadedPath;     // The path of the file if it successfully downloaded and is guaranteed to exist at the path.

@end
