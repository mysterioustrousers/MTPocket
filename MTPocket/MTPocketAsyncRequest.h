//
//  MTPocketAsyncRequest.h
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//


#import "MTPocketRequest.h"





@interface MTPocketAsyncRequest : MTPocketRequest <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) void (^uploadProgressHandler)(float percent);
@property (strong, nonatomic) void (^downloadProgressHandler)(float percent);


+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      format:(MTPocketFormat)format
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock;

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      method:(MTPocketMethod)method
                                      format:(MTPocketFormat)format
                                        body:(id)body
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock;

+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      method:(MTPocketMethod)method
                                      format:(MTPocketFormat)format
                                    username:(NSString *)username
                                    password:(NSString *)password
                                        body:(id)body
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock;

// Download file to memory
+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                            downloadProgress:(void (^)(float percent))downloadProgressBlock
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock;

// Download file to disk
+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                             destinationPath:(NSString *)filePath         // Leave this nil if you don't want to download to a file
                            downloadProgress:(void (^)(float percent))downloadProgressBlock
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock;

// Upload (POST) the body (file) data and set the content type as multipart/form-data. Body must be NSData.
+ (MTPocketAsyncRequest *)asyncRequestForURL:(NSURL *)URL
                                      format:(MTPocketFormat)format       // Usually a server will response with json or xml data about the uploaded file
                                        body:(id)body                     // NSData of the file contents.
                              uploadFilename:(NSString *)filename         // The filename of the file being uploaded.
                             uploadFormField:(NSString *)fieldName        // The name of the form field this file is being uploaded with.
                              uploadMIMEType:(NSString *)MIMEType         // The Content-Type of the file being uploaded.
                              uploadProgress:(void (^)(float percent))uploadProgressBlock
                                     success:(void (^)(MTPocketResponse *response))successBlock
                                     failure:(void (^)(MTPocketResponse *response))failureBlock;

// Initiate request
- (NSURLConnection *)send;

@end
