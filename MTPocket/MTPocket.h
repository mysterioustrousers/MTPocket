//
//  MTPocket.h
//  MTPocket
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>


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
