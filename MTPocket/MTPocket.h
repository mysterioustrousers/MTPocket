//
//  MTPocket.h
//  MTPocket
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>


/*

 USAGE:

 1. call: NSArray *returnedArray = [NSURLConnection JSONFromURL:url usingUsername:username password:password method:method sendingBody:body error:&error];

 2. check the result option to make sure its what you expect, if its not what you expect

	I. check the error object.  If it is NOT nil

		a. see if the domain is @"ConnectionError".  If it is, that means there is no internet connection.

		b. see if the domain is @"RequestError".  If it is:

			i. if the error.code property is 401, your username and password are wrong.

			ii. if the error.code is 404, your url is wrong.

			iii. if the error.code is 422, the JSON you sent was malformed.

			iv. if the error.code is 426, you tried to connect with http when https is required.

 c. see if the domain is @"ResponseError".  If it is, the JSON returned was malformed.

 3. check to make sure returnedArray is not nil.  If it is, and error was nil too, you're screwed.


 EXAMPLE:

 dispatch_async(queue, ^(void) {

	NSError *error = nil;
	NSArray *returnedArray = [NSURLConnection JSONFromURL:url usingUsername:username password:password method:method sendingBody:body error:&error];

	dispatch_async(dispatch_get_main_queue(), ^(void) {
		*** update the UI with the response data ***
	});

 });

*/


// MTPocketResult
typedef enum {
    MTPocketResultSuccess,
	MTPocketResultCreated,
    MTPocketResultUnauthorized,
    MTPocketResultUnprocessable,
	MTPocketResultNotFound,
	MTPocketResultNoConnection,
	MTPocketResultOther,
} MTPocketResult;

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


@interface MTPocket : NSObject

@property (readonly)			NSURL *url;				// required, readonly
@property (nonatomic)			MTPocketMethod method;	// default: MTPocketMethodGET
@property (nonatomic)			MTPocketFormat format;	// defaut: MTPocketFormatJSON
@property (strong, nonatomic)	NSString *username;		// optional, HTTP Basic auth
@property (strong, nonatomic)	NSString *password;
@property (strong, nonatomic)	id body;				// can be a dictionary, array, string or data
@property (strong, nonatomic)	NSDictionary *headers;	// optional
@property (nonatomic)			NSTimeInterval timeout;	// optional

// Create and set properties. Use this if you need to set timeout, headers, etc.
- (id)initWithURL:(NSURL *)url;
- (id)fetchObjectWithResult:(MTPocketResult *)result error:(NSError **)error;

// Convenience (synchronous) 
+ (void)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, NSData *data, NSError *error))errorBlock;
+ (void)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, NSData *data, NSError *error))errorBlock;

// Convenience (asynchronous)
+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, NSData *data, NSError *error))errorBlock;
+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, NSData *data, NSError *error))errorBlock;

@end
