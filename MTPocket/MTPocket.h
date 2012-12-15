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
    MTPocketStatusServerError,
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
    MTPocketMethodFILE,     // Will POST the body (file) data and set the content type as multipart/form-data. Body must be NSData.
	MTPocketMethodPUT,
	MTPocketMethodDELETE
} MTPocketMethod;




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




@interface MTPocketRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (readonly)			NSURL           *URL;                                           // (Required, Read-only)
@property (        nonatomic)	MTPocketMethod  method;                                         // Default: MTPocketMethodGET
@property (        nonatomic)	MTPocketFormat  format;                                         // Defaut: MTPocketFormatJSON
@property (strong, nonatomic)	NSString        *username;                                      // (optional) HTTP Basic auth
@property (strong, nonatomic)	NSString        *password;
@property (strong, nonatomic)	id              body;                                           // Can be an NSDictionary, NSArray, NSString, NSData, or nil
@property (strong, nonatomic)	NSDictionary    *headers;                                       // (optional)
@property (        nonatomic)	NSTimeInterval  timeout;                                        // (optional)
@property (strong, nonatomic)   void            (^uploadProgressHandler)(long long bytesLoaded, long long bytesTotal);      // only called with asynchronous
@property (strong, nonatomic)   void            (^downloadProgressHandler)(long long bytesLoaded, long long bytesTotal);    // only called with asynchronous
@property (strong, nonatomic)   void            (^successHandler)(MTPocketResponse *response);
@property (strong, nonatomic)   void            (^failureHandler)(MTPocketResponse *response);

@property (strong, nonatomic)   NSString        *fileDownloadPath;                              // If not nil, it will download the contents to a file at this location
@property (strong, nonatomic)   NSString        *fileUploadTitle;                               // The filename of the file being uploaded.
@property (strong, nonatomic)   NSString        *fileUploadFormField;                           // The name of the form field this file is being uploaded with.
@property (strong, nonatomic)   NSString        *fileUploadMIMEType;                            // The Content-Type of the file being uploaded.



#pragma mark - Constructors

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

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body
                           success:(void (^)(MTPocketResponse *response))successBlock
                           failure:(void (^)(MTPocketResponse *response))failureBlock;

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body
                    downloadToFile:(NSString *)downloadPath // leave this nil if you don't want to download to a file
                  downloadProgress:(void (^)(long long bytesLoaded, long long bytesTotal))downloadProgressBlock
                           success:(void (^)(MTPocketResponse *response))successBlock
                           failure:(void (^)(MTPocketResponse *response))failureBlock;

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body // NSData of the file contents
                    uploadFilename:(NSString *)filename
                   uploadFormField:(NSString *)fieldName
                    uploadMIMEType:(NSString *)MIMEType
                    uploadProgress:(void (^)(long long bytesLoaded, long long bytesTotal))uploadProgressBlock
                           success:(void (^)(MTPocketResponse *response))successBlock
                           failure:(void (^)(MTPocketResponse *response))failureBlock;


#pragma mark - Start Request

- (MTPocketResponse *)synchronous;
- (NSURLConnection *)asynchronous;


@end
