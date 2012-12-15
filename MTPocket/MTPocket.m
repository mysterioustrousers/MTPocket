//
//  MTPocket.m
//  MTPocket
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <MF_Base64Additions.h>
#import <XMLDictionary.h>
#import <NSObject+MTJSONUtils.h>
#import "MTPocket.h"



@interface MTPocketResponse ()
@property BOOL isFileDownload;
@end





@implementation MTPocketResponse

- (id)init
{
    self = [super init];
    if (self) {
        _success = NO;
    }
    return self;
}

- (void)setStatusCode:(NSInteger)statusCode
{
    _statusCode = statusCode;
    _success = NO;

    if (statusCode == 201) {
		_status = MTPocketStatusCreated;
		_success = YES;
	}
	else if (statusCode >= 200 && statusCode < 300) {
		_status = MTPocketStatusSuccess;
		_success = YES;
	}

	else if (statusCode == 401)
        _status = MTPocketStatusUnauthorized;

	else if (statusCode == 404)
        _status = MTPocketStatusNotFound;

	else if (statusCode == 422)
        _status = MTPocketStatusUnprocessable;

    else if (statusCode >= 500 && statusCode < 600)
        _status = MTPocketStatusServerError;

	else
        _status = MTPocketStatusOther;
}

- (void)setStatus:(MTPocketStatus)status
{
    _status = status;
    if (_status == MTPocketStatusSuccess) _success = YES;
}

- (void)setError:(NSError *)error
{
    _error = nil;
    if (error) {
        _success = NO;
        _error = error;
        if (error.code == NSURLErrorUserCancelledAuthentication) {
            _statusCode = 401;
            _status = MTPocketStatusUnauthorized;
        }
    }
}

- (void)setRequestData:(NSData *)requestData
{
    _requestData = requestData;
}

- (void)setRequestText:(NSString *)requestText
{
    _requestText = requestText;
}

- (void)setRequest:(NSURLRequest *)request
{
    _request = request;
}

- (void)setFormat:(MTPocketFormat)format
{
    _format = format;
}

- (void)setData:(NSData *)data
{
    if (!data) {
        _status = MTPocketStatusNoConnection;
    }

    if (_error) return;
    
    _data = data;

    if (_isFileDownload) return;

    _text = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];

    // otherwise, build an object from the response data
    if (_format == MTPocketFormatHTML || _format == MTPocketFormatTEXT)
        _body = _text;

    else if (_format == MTPocketFormatJSON) {
        NSError *error = nil;
        _body = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) _error = error;
    }
    else if (_format == MTPocketFormatXML)
        _body = [NSDictionary dictionaryWithXMLData:data];
}

- (void)setRequestHeaders:(NSDictionary *)requestHeaders
{
    _requestHeaders = requestHeaders;
}

- (void)setMIMEType:(NSString *)MIMEType
{
    _MIMEType = MIMEType;
}

- (void)setExpectedContentLength:(NSInteger)expectedContentLength
{
    _expectedContentLength = expectedContentLength;
}

- (void)setFileDownloadedPath:(NSString *)fileDownloadedPath
{
    if (fileDownloadedPath && !_error && _success) {

        NSError *error = nil;
        [_data writeToFile:fileDownloadedPath options:0 error:&error];

        if (!error && [[NSFileManager defaultManager] fileExistsAtPath:fileDownloadedPath])
            _fileDownloadedPath = fileDownloadedPath;
        else if (error) {
            _success = NO;
            _error = error;
        }
    }
}

@end











@interface MTPocketRequest ()
@property (strong, nonatomic) MTPocketResponse *response;
@property (strong, nonatomic) NSMutableData *mutableData;
@end





@implementation MTPocketRequest

- (id)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _URL	= URL;
		_method = MTPocketMethodGET;
		_format = MTPocketFormatJSON;
    }
    return self;
}

#pragma mark - Constructors

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            format:(MTPocketFormat)format
{
    return [self requestForURL:URL method:MTPocketMethodGET format:format body:nil];
}

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body
{
    return [self requestForURL:URL method:method format:format username:nil password:nil body:body];
}

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                          username:(NSString *)username
                          password:(NSString *)password
                              body:(id)body
{
    return [self requestForURL:URL
                        method:method
                        format:format
                      username:username
                      password:password
                          body:body
                uploadFilename:nil
               uploadFormField:nil
                uploadMIMEType:nil
                downloadToFile:nil
                uploadProgress:nil
              downloadProgress:nil
                       success:nil
                       failure:nil];
}

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body
                           success:(void (^)(MTPocketResponse *response))successBlock
                           failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self requestForURL:URL
                        method:method
                        format:format
                          body:body
                downloadToFile:nil
              downloadProgress:nil
                       success:successBlock
                       failure:failureBlock];
}

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body
                    downloadToFile:(NSString *)downloadPath
                  downloadProgress:(void (^)(long long bytesLoaded, long long bytesTotal))downloadProgressBlock
                           success:(void (^)(MTPocketResponse *response))successBlock
                           failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self requestForURL:URL
                        method:method
                        format:format
                      username:nil
                      password:nil
                          body:body
                uploadFilename:nil
               uploadFormField:nil
                uploadMIMEType:nil
                downloadToFile:downloadPath
                uploadProgress:nil
              downloadProgress:downloadProgressBlock
                       success:successBlock
                       failure:failureBlock];
}

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                              body:(id)body
                    uploadFilename:(NSString *)filename
                   uploadFormField:(NSString *)fieldName
                    uploadMIMEType:(NSString *)MIMEType
                    uploadProgress:(void (^)(long long bytesLoaded, long long bytesTotal))uploadProgressBlock
                           success:(void (^)(MTPocketResponse *response))successBlock
                           failure:(void (^)(MTPocketResponse *response))failureBlock
{
    return [self requestForURL:URL
                        method:method
                        format:format
                      username:nil
                      password:nil
                          body:body
                uploadFilename:filename
               uploadFormField:fieldName
                uploadMIMEType:MIMEType
                downloadToFile:nil
                uploadProgress:uploadProgressBlock
              downloadProgress:nil
                       success:successBlock
                       failure:failureBlock];
}

+ (MTPocketRequest *)requestForURL:(NSURL *)URL
                            method:(MTPocketMethod)method
                            format:(MTPocketFormat)format
                          username:(NSString *)username
                          password:(NSString *)password
                              body:(id)body
                    uploadFilename:(NSString *)filename
                   uploadFormField:(NSString *)fieldName
                    uploadMIMEType:(NSString *)MIMEType
                    downloadToFile:(NSString *)downloadPath
                    uploadProgress:(void (^)(long long bytesLoaded, long long bytesTotal))uploadProgressBlock
                  downloadProgress:(void (^)(long long bytesLoaded, long long bytesTotal))downloadProgressBlock
                           success:(void (^)(MTPocketResponse *response))successBlock
                           failure:(void (^)(MTPocketResponse *response))failureBlock
{
    MTPocketRequest *request = [[MTPocketRequest alloc] initWithURL:URL];
    request.method                      = method;
    request.format                      = format;
    request.username                    = username;
    request.password                    = password;
    request.body                        = body;
    request.fileUploadTitle             = filename;
    request.fileUploadFormField         = fieldName;
    request.fileUploadMIMEType          = MIMEType;
    request.fileDownloadPath            = downloadPath;
    request.uploadProgressHandler       = uploadProgressBlock;
    request.downloadProgressHandler     = downloadProgressBlock;
    request.successHandler              = successBlock;
    request.failureHandler              = failureBlock;
    return  request;
}



#pragma mark - Start Request

- (MTPocketResponse *)synchronous {

    // create the response
    MTPocketResponse *response = [[MTPocketResponse alloc] init];
    NSMutableURLRequest *request = [self requestWithResponse:&response];
    _response = response;

    // send the request
	NSHTTPURLResponse *httpURLResponse = nil;
    NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpURLResponse error:&error];

    // populate the response
    [response setStatusCode:httpURLResponse.statusCode];
    [response setError:error];
    [response setData:data];
    [response setMIMEType:httpURLResponse.MIMEType];
    [response setExpectedContentLength:httpURLResponse.expectedContentLength];
    [response setFileDownloadedPath:_fileDownloadPath];

    NSInteger cl = httpURLResponse.expectedContentLength;
    if (_downloadProgressHandler)   _downloadProgressHandler(cl,cl);
    if (_uploadProgressHandler)     _uploadProgressHandler(cl,cl);


    if (response.success && _successHandler)    _successHandler(response);
    if (!response.success && _failureHandler)   _failureHandler(response);

	return response;
}

- (NSURLConnection *)asynchronous
{
    // create the response
    MTPocketResponse *response = [[MTPocketResponse alloc] init];
    NSMutableURLRequest *request = [self requestWithResponse:&response];
    _response = response;


    if ([NSURLConnection canHandleRequest:request]) {
        _mutableData = [NSMutableData data];
        return [NSURLConnection connectionWithRequest:request delegate:self];
    }

    else {
        [_response setStatus:MTPocketStatusNoConnection];
        if (_failureHandler) _failureHandler(_response);
        return nil;
    }
}







#pragma mark - Private

- (NSMutableURLRequest *)requestWithResponse:(MTPocketResponse **)response
{
   	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_URL];

    
	// set method
	NSString *method = nil;
	switch (_method) {
		case MTPocketMethodPOST:
        case MTPocketMethodFILE:
			method = @"POST";
			break;
		case MTPocketMethodPUT:
			method = @"PUT";
			break;
		case MTPocketMethodDELETE:
			method = @"DELETE";
			break;
		default:
			method = @"GET";
			break;
	}
	[request setHTTPMethod:method];

    
	// set format
	NSString *format = nil;
	switch (_format) {
		case MTPocketFormatXML:
			format = @"application/xml";
			break;
		case MTPocketFormatHTML:
			format = @"text/html";
			break;
		case MTPocketFormatTEXT:
			format = @"text/plain";
			break;
		default:
			format = @"application/json";
			break;
	}

    [(*response) setFormat:_format];


	// prepare headers
    NSDictionary *defaultHeaders = nil;
    NSString *boundary = @"----WebKitFormBoundary9HN3IwANdrhDGAN4";
    if (_method == MTPocketMethodFILE) {
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        defaultHeaders = @{ @"Accept" : format, @"Content-Type" : contentType };
    }
    else
        defaultHeaders = @{ @"Accept" : format, @"Content-Type" : format };

	NSMutableDictionary *headerDictionary = [NSMutableDictionary dictionaryWithDictionary:defaultHeaders];
	[headerDictionary addEntriesFromDictionary:_headers];

    
	// set body
	if (_body) {
		id body = nil;

        if (_method == MTPocketMethodFILE && [_body isKindOfClass:[NSData class]]) {
            NSString *title         = _fileUploadTitle      ? _fileUploadTitle      : @"file";
            NSString *fieldName     = _fileUploadFormField  ? _fileUploadFormField  : @"files[]";
            NSString *MIMEType      = _fileUploadMIMEType   ? _fileUploadMIMEType   : @"application/octet-stream";

            NSMutableData *postbody = [NSMutableData data];
            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, title] dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", MIMEType] dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:_body];
            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            headerDictionary[@"Content-Length"] = [NSString stringWithFormat:@"%d", postbody.length];

            body = postbody;
        }

		else if ([_body isKindOfClass:[NSString class]] || [_body isKindOfClass:[NSData class]]) {
			body = _body;
		}

		else if ([_body isKindOfClass:[NSDictionary class]] || [_body isKindOfClass:[NSArray class]]) {
			if (_format == MTPocketFormatJSON) {
				NSError *error = nil;
				body = [NSJSONSerialization dataWithJSONObject:[_body objectWithJSONSafeObjects] options:0 error:&error];

				// It's in the developers power to ensure correct json is provided, so we throw an exception rather than return an error.
				if (error) {
					[[NSException exceptionWithName:@"Invalid JSON" reason:@"The JSON could not be parsed" userInfo:[error userInfo]] raise];
					return nil;
				}
			}
			else if (_format == MTPocketFormatXML) {
				if ([_body isKindOfClass:[NSArray class]]) {
					_body = @{ @"root" : _body };
				}
				body = [[_body objectWithJSONSafeObjects] xmlString];
				body = [[body stringByReplacingOccurrencesOfString:@"<root>" withString:@""] stringByReplacingOccurrencesOfString:@"</root>" withString:@""];
			}
		}

		else {
			// These problems need to be caught in development, so we throw an exception
			[[NSException exceptionWithName:@"Invalid Body" reason:@"The body must be either an NSString, NSData, NSDictionary or NSArray, or nil" userInfo:nil] raise];
		}

		if ([body isKindOfClass:[NSData class]]) {
			[request setHTTPBody:body];
			[(*response) setRequestData:body];
            if (_method != MTPocketMethodFILE) {
                NSString *requestText = [[NSString alloc] initWithBytes:[(NSData *)body bytes] length:[(NSData *)body length] encoding:NSUTF8StringEncoding];
                [(*response) setRequestText:requestText];
            }
		}
        
		else {
			NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
			[request setHTTPBody:bodyData];
			[(*response) setRequestData:bodyData];
            [(*response) setRequestText:body];
		}

	}

    
	// set username & password
	if (_username || _password) {
		NSString *username = _username ? _username : @"";
		NSString *password = _password ? _password : @"";
        NSString *plainTextAuth = [NSString stringWithFormat:@"%@:%@", username, password];
        NSString *base64EncodedAuth = [plainTextAuth base64String];
		[headerDictionary addEntriesFromDictionary:@{ @"Authorization" : [NSString stringWithFormat:@"Basic %@", base64EncodedAuth] }];
    }


	// set headers
	[request setAllHTTPHeaderFields:headerDictionary];
    [(*response) setRequestHeaders:headerDictionary];


	// set timeout
	if (_timeout)
		[request setTimeoutInterval:_timeout];


    // set properties on response
    [(*response) setRequest:request];
    (*response).isFileDownload = _fileDownloadPath != nil;

    return request;
}



#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_response setError:error];
    if (_failureHandler) _failureHandler(_response);
}



#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    [_response setStatusCode:response.statusCode];
    [_response setMIMEType:response.MIMEType];
    [_response setExpectedContentLength:response.expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
    if (_downloadProgressHandler) {
        NSNumber *loaded    = @([_mutableData length]);
        NSNumber *total     = @(_response.expectedContentLength);
        _downloadProgressHandler([loaded longLongValue], [total longLongValue]);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_response setData:_mutableData];
    [_response setFileDownloadedPath:_fileDownloadPath];

    if (_response.success && _successHandler)       _successHandler(_response);
    else if (!_response.success && _failureHandler) _failureHandler(_response);
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (_uploadProgressHandler) _uploadProgressHandler(totalBytesWritten, totalBytesExpectedToWrite);
}



@end
