//
//  MTPocket.h
//  MTPocket
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//




// MTPocketStatus - A mapping of common HTTP status codes for easier use
typedef enum {
    MTPocketStatusSuccess,
	MTPocketStatusCreated,
    MTPocketStatusUnauthorized,
    MTPocketStatusUnprocessable,
	MTPocketStatusNotFound,
	MTPocketStatusNoConnection,
	MTPocketStatusOther,
} MTPocketStatus;

// MTPocketFormat
typedef enum {
	MTPocketFormatJSON,
	MTPocketFormatXML,
	MTPocketFormatHTML,
	MTPocketFormatTEXT
} MTPocketFormat;

// MTPocketMethod
typedef enum {
	MTPocketMethodGET,
	MTPocketMethodPOST,
	MTPocketMethodPUT,
	MTPocketMethodDELETE
} MTPocketMethod;




@interface MTPocketResponse : NSHTTPURLResponse

@property (nonatomic) BOOL success;						// Easily determine if the request was 100% sucessful. Otherwise, lots of data in other properties to deal with the failure.
@property (nonatomic) MTPocketStatus status;			// A Mapping of common HTTP status codes to enum.
@property (nonatomic) MTPocketFormat format;			// The format of the original content. Will always be the same as the request format.
@property (strong, nonatomic) id body;					// The response body. Depending on the format, could be an NSString, NSArray, NSDictionary or nil.
@property (strong, nonatomic) NSData *data;				// The data returned form the server for debugging.
@property (strong, nonatomic) NSURLRequest *request;	// The original request made to the server.
@property (strong, nonatomic) NSError *error;			// Could be nil, but should check this for important info if its not nil.

@end




@interface MTPocketRequest : NSObject

@property (readonly)			NSURL *url;				// (Required, Read-only)
@property (nonatomic)			MTPocketMethod method;	// Default: MTPocketMethodGET
@property (nonatomic)			MTPocketFormat format;	// Defaut: MTPocketFormatJSON
@property (strong, nonatomic)	NSString *username;		// (optional) HTTP Basic auth
@property (strong, nonatomic)	NSString *password;
@property (strong, nonatomic)	id body;				// Can be an NSDictionary, NSArray, NSString, NSData, or nil
@property (strong, nonatomic)	NSDictionary *headers;	// (optional)
@property (nonatomic)			NSTimeInterval timeout;	// (optional)

// Create and set properties. Use this if you need to set timeout, headers, etc.
- (id)initWithURL:(NSURL *)url;
- (MTPocketResponse *)fetch;

// Convenience (synchronous) 
+ (MTPocketResponse *)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body;
+ (MTPocketResponse *)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body;

// Convenience (asynchronous)
+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body complete:(void (^)(MTPocketResponse *response))completeBlock;
+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body complete:(void (^)(MTPocketResponse *response))completeBlock;

@end
