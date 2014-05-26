//
//  MTPocketRequest.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

@class MTPocketResponse;
@class MTPocketRequest;


typedef void (^MTPocketCallback)(MTPocketResponse *response);
typedef void (^MTPocketBatchCallback)(MTPocketRequest *request, MTPocketResponse *response);
typedef void (^MTPocketProgressCallback)(float percent);

/**
 MTPocketFormat
 This will determine how the response is parsed into an object.
 */
typedef enum {
	MTPocketFormatJSON,     // If the body is a dictionary/array, it is encoded as JSON for the request and the JSON response is parsed into a dictionary/array.
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

// (optional) Will override the default base URL set on the shared pocket singleton
@property (nonatomic, strong) NSURL *baseURL;


// Basic options

// (required) The resource path after the base url. Can include placeholders like ':id' that will be filled in respectively with 'identifiers'. e.g. @"buttons/:button_id/stitches/:id"
@property (nonatomic, strong) NSString *path;

// (required) NSNumber/NSString objects that are swapping it
@property (nonatomic, strong) NSArray *identifiers;

// (required) Default: MTPocketMethodGET
@property (nonatomic) MTPocketMethod method;

// (required) Defaut: MTPocketFormatJSON
@property (nonatomic) MTPocketFormat format;

// (optional) Query string params. @{ @"page" : @(2) } => ?page=2
@property (readonly,nonatomic)	NSMutableDictionary *params;

// (optional) The body of the request. Can be NSData, NSString, NSDictionary, NSArray.
@property (nonatomic, strong) id body;


// Additional options

// (optional) The headers dictionary. You can add or delete from the template.
@property (readonly,nonatomic)	NSMutableDictionary *headers;
// (optional) Default: 60 seconds.
@property (nonatomic) NSTimeInterval timeout;

// (optional) Default: Content-Length. Could also be stream-length, etc. Will be used for progress handlers.
@property (nonatomic, strong) NSString *contentLengthHeader;

// (optional) Default: MTPocket/1.0
@property (nonatomic, strong) NSString *userAgent;

@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;



+ (MTPocketRequest *)requestTemplate;

+ (MTPocketRequest *)requestWithPath:(NSString *)path
                         identifiers:(NSArray *)identifiers
                              method:(MTPocketMethod)method
                                body:(id)body
                              params:(NSDictionary *)params;

+ (MTPocketRequest *)requestWithURL:(NSURL *)URL
                             method:(MTPocketMethod)method
                               body:(id)body;

/**
 The URL that is generated after the baseURL is added, identifiers are inserted and parameters are added to the 
 query string.
 */
- (NSURL *)resolvedURL;










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

/**
 Is called once the request is completed, regardless of the result. It is called BEFORE success/failure callbacks.
 */
- (void)addComplete:(MTPocketCallback)complete;

/**
 Remove all callbacks from a request. You should call this before retrying a request.
 */
- (void)removeAllHandlers;











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
+ (NSDictionary *)headerDictionaryForBearerAuthWithToken:(NSString *)token;





@end
