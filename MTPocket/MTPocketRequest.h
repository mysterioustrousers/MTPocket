//
//  MTPocketRequest.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

@class MTPocketResponse;


typedef void (^MTPocketCallback)(MTPocketResponse *response);
typedef void (^MTPocketProgressCallback)(float percent);

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









@interface MTPocketRequest : NSObject

@property (strong,  nonatomic)   NSURL              *baseURL;               // (optional) Will override the default base URL set on the shared pocket singleton

// Basic options
@property (strong,  nonatomic)  NSString            *path;                  // (required) The resource path after the base url. Can include placeholders like ':id' that will be filled in respectively with 'identifiers'. e.g. @"buttons/:button_id/stitches/:id"
@property (strong,  nonatomic)	NSArray             *identifiers;           // (required) NSNumber/NSString objects that are swapping it
@property (         nonatomic)	MTPocketMethod      method;                 // (required) Default: MTPocketMethodGET
@property (         nonatomic)	MTPocketFormat      format;                 // (required) Defaut: MTPocketFormatJSON
@property (readonly,nonatomic)	NSMutableDictionary *params;                // (optional) Query string params. @{ @"page" : @(2) } => ?page=2
@property (strong,  nonatomic)  id                  body;                   // (optional) The body of the request. Can be NSData, NSString, NSDictionary, NSArray.

// Additional options
@property (readonly,nonatomic)	NSMutableDictionary *headers;               // (optional) The headers dictionary. You can add or delete from the template.
@property (         nonatomic)	NSTimeInterval      timeout;                // (optional) Default: 60 seconds.
@property (strong,  nonatomic)  NSString            *contentLengthHeader;   // (optional) Default: Content-Length. Could also be stream-length, etc. Will be used for progress handlers.


+ (MTPocketRequest *)requestTemplate;

+ (MTPocketRequest *)requestWithPath:(NSString *)path
                         identifiers:(NSArray *)identifiers
                              method:(MTPocketMethod)method
                                body:(id)body
                              params:(NSDictionary *)params;











#pragma mark - Adding callbacks

/**
 You can add multiple callbacks for success and failure. This comes in handy if, for example, you have a library that abstracts away handling the
 request result, but wants to delegate the actual act of triggering the request to the application using the library. The library would have model
 objects with methods like "fetch" and when called, it would add its own callback so that on success it could populate the object with the returned
 data, then pass the request object back to the calling application so that it can add it's own success callbacks and actually trigger the call.
 This allows the library to keep it's methods simple and short, simply returning an MTPocketRequest object that the application can call itself rather
 than having every method in the library have sucess and failure callbacks adding tons of clutter to the interface. This also allows the application
 to modify the request if it needs to and/or call it on a particular thread. So, bottom line, this allows the library to create the request, attach it's
 opportunity to deal with the request and then pass it off to the calling application.
 */

- (void)addSuccess:(MTPocketCallback)success;
- (void)addFailure:(MTPocketCallback)failure;












#pragma mark - Send

- (void)sendWithSuccess:(MTPocketCallback)success
                failure:(MTPocketCallback)failure;

- (void)sendWithSuccess:(MTPocketCallback)success
                failure:(MTPocketCallback)failure
         uploadProgress:(MTPocketProgressCallback)uploadProgress
       downloadProgress:(MTPocketProgressCallback)downloadProgress;

- (void)sendFileData:(NSData *)fileData
            filename:(NSString *)filename
           formField:(NSString *)formField
            MIMEType:(NSString *)MIMEType
             success:(MTPocketCallback)success
             failure:(MTPocketCallback)failure
      uploadProgress:(MTPocketProgressCallback)uploadProgress;












#pragma mark - Headers

- (void)addHeaders:(NSDictionary *)dictionary;
+ (NSDictionary *)headerDictionaryForBasicAuthWithUsername:(NSString *)username password:(NSString *)password;
+ (NSDictionary *)headerDictionaryForTokenAuthWithToken:(NSString *)token;









@end
