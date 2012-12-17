//
//  MTPocketRequest.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

@class MTPocketResponse;

/**
 MTPocketStatus
 A mapping of common HTTP status codes for easier use.
 */
typedef enum {
    MTPocketStatusSuccess,          // 200..299
	MTPocketStatusCreated,          // 201
    MTPocketStatusUnauthorized,     // 401
    MTPocketStatusUnprocessable,    // 422
	MTPocketStatusNotFound,         // 404
	MTPocketStatusNoConnection,
    MTPocketStatusServerError,      // 500..599
	MTPocketStatusOther,
} MTPocketStatus;

/**
 MTPocketFormat
 This will determine how the response is parsed into an object.
 */
typedef enum {
	MTPocketFormatJSON,     // If the body is a dictionary/array, it is encoded as JSON for the request and the JSON response is parsed into a dictionary/array.
	MTPocketFormatXML,      // If the body is a dictionary/array, it is encoded as XML for the request and the XML response is parsed into a dictionary/array.
	MTPocketFormatHTML,
	MTPocketFormatTEXT
} MTPocketFormat;

/**
 MTPocketMethod
 RESTful HTTP methods.
 */
typedef enum {
	MTPocketMethodGET,
	MTPocketMethodPOST,
	MTPocketMethodPUT,
	MTPocketMethodDELETE
} MTPocketMethod;




/**

 MTPocketRequest
 
 Use the convenience constructors to create a request and then call `send` to make the request.
 The convenience constructors will give you a "template" for a common request, but you can always
 use the properties of this class to customize the request further.
 
 Example: One shot

    MTPocketResponse *response = [MTPocketRequest requestForURL:URL format:MTPocketFormatHTML].send;
 
 Example: Customize

     MTPocketRequest *request = [MTPocketRequest requestForURL:URL method:MTPocketMethodPost format:MTPocketFormatJSON body:@{"Name" : "Adam"}];
     request.timeout = 60;
     [request send];

 */

@interface MTPocketRequest : NSObject

@property (readonly)			NSURL           *URL;           // (Required, Read-only)
@property (        nonatomic)	MTPocketMethod  method;         // Default: MTPocketMethodGET
@property (        nonatomic)	MTPocketFormat  format;         // Defaut: MTPocketFormatJSON
@property (strong, nonatomic)	NSString        *username;      // (optional) HTTP Basic auth
@property (strong, nonatomic)	NSString        *password;
@property (strong, nonatomic)	id              body;           // Can be an NSDictionary, NSArray, NSString, NSData, or nil
@property (strong, nonatomic)	NSDictionary    *headers;       // (optional)
@property (        nonatomic)	NSTimeInterval  timeout;        // (optional)


+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            format:(MTPocketFormat)format;

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body;

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                          username:(NSString *)username
                          password:(NSString *)password
                              body:(id)body;

// Initiate request
- (MTPocketResponse *)send;


@end
