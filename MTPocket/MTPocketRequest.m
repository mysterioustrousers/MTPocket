//
//  MTPocketRequest.m
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MF_Base64Additions.h"
#import "NSObject+MTJSONUtils.h"
#import "XMLDictionary.h"
#import "mtpocket_private.h"



NSString *randomStringWithLength(NSInteger length)
{
	unichar string[length];
	for (NSInteger i = 0; i < length; i++) {
		unichar r = (arc4random() % 25) + 65;
		string[i] = r;
	}
	return [[NSString stringWithCharacters:string length:length] lowercaseString];
}




@interface MTPocketRequest () <NSCopying, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (strong, readwrite, nonatomic)	NSMutableDictionary         *params;
@property (strong, readwrite, nonatomic)	NSMutableDictionary         *headers;
@property (strong, nonatomic)               MTPocketResponse            *response;
@property (strong, nonatomic)               NSMutableData               *mutableData;
@property (strong, nonatomic)               NSData                      *fileData;              // (optional) The actual file data.
@property (strong, nonatomic)               NSString                    *fileUploadFilename;    // (optional) The filename of the file being uploaded.
@property (strong, nonatomic)               NSString                    *fileUploadFormField;   // (optional) The name of the form field this file is being uploaded with.
@property (strong, nonatomic)               NSString                    *fileUploadMIMEType;    // (optional) The Content-Type of the file being uploaded.
@property (strong, nonatomic)               NSMutableArray              *successHandlers;
@property (strong, nonatomic)               NSMutableArray              *failureHandlers;
@property (strong, nonatomic)               NSMutableArray              *completeHandlers;
@property (strong, nonatomic)               MTPocketProgressCallback    downloadProgressHandler;
@property (strong, nonatomic)               MTPocketProgressCallback    uploadProgressHandler;
@end




@implementation MTPocketRequest


- (id)init
{
    self = [super init];
    if (self) {
		_format             = MTPocketFormatJSON;
        _timeout            = 60;
        _successHandlers    = [NSMutableArray array];
        _failureHandlers    = [NSMutableArray array];
        _completeHandlers   = [NSMutableArray array];
        _headers            = [NSMutableDictionary dictionary];
        _params             = [NSMutableDictionary dictionary];
        _userAgent          = nil;
    }
    return self;
}

- (id)initWithPath:(NSString *)path
       identifiers:(NSArray *)identifiers
            method:(MTPocketMethod)method
              body:(id)body
            params:(NSDictionary *)params
{
    self = [self init];
    if (self) {
        _path           = path;
        _identifiers    = identifiers;
        _method         = method;
        _body           = body;
        [_params addEntriesFromDictionary:params];
    }
    return self;
}

+ (MTPocketRequest *)requestTemplate
{
    return [[MTPocketRequest alloc] initWithPath:nil
                                     identifiers:nil
                                          method:MTPocketMethodGET
                                            body:nil
                                          params:nil];
}

+ (MTPocketRequest *)requestWithPath:(NSString *)path
                         identifiers:(NSArray *)identifiers
                              method:(MTPocketMethod)method
                                body:(id)body
                              params:(NSDictionary *)params
{
    MTPocketRequest *request = [[MTPocketRequest alloc] initWithPath:path
                                                         identifiers:identifiers
                                                              method:method
                                                                body:body
                                                              params:params];
    return request;
}

+ (MTPocketRequest *)requestWithURL:(NSURL *)URL
                             method:(MTPocketMethod)method
                               body:(id)body
{
    NSString *scheme            = [URL scheme];
    NSString *host              = [URL host];
    NSNumber *port              = [URL port];
    NSString *p                 = [URL path];
    NSString *query             = [URL query];
    NSMutableString *baseURL    = [NSMutableString string];
    NSMutableString *path       = [NSMutableString string];
    if (scheme) [baseURL appendFormat:@"%@://", scheme];
    if (host)   [baseURL appendString:host];
    if (port)   [baseURL appendFormat:@":%@", port];
    if (p)      [path    appendString:p];
    if (query)  [path    appendFormat:@"?%@", query];

    MTPocketRequest *request = [self requestWithPath:path identifiers:nil method:method body:body params:nil];
    request.baseURL = [NSURL URLWithString:baseURL];
    return request;
}

- (NSURL *)resolvedURL
{
    return [self URLForPath:_path identifiers:_identifiers params:_params];
}



#pragma mark - Adding Callbacks

- (void)addSuccess:(MTPocketCallback)success
{
    if (success) [_successHandlers addObject:success];
}

- (void)addFailure:(MTPocketCallback)failure
{
    if (failure) [_failureHandlers addObject:failure];
}

- (void)addComplete:(MTPocketCallback)complete
{
    if (complete) [_completeHandlers addObject:complete];
}

- (void)removeAllHandlers
{
    [_successHandlers removeAllObjects];
    [_failureHandlers removeAllObjects];
    [_completeHandlers removeAllObjects];
}





#pragma mark - Send 

- (void)sendWithSuccess:(MTPocketCallback)success
                failure:(MTPocketCallback)failure
{
    [self sendWithSuccess:success
                  failure:failure
           uploadProgress:nil
         downloadProgress:nil];
}

- (void)sendWithSuccess:(MTPocketCallback)success
                failure:(MTPocketCallback)failure
         uploadProgress:(MTPocketProgressCallback)uploadProgress
       downloadProgress:(MTPocketProgressCallback)downloadProgress
{
    // set callbacks
    [self addSuccess:success];
    [self addFailure:failure];
    _uploadProgressHandler      = uploadProgress;
    _downloadProgressHandler    = downloadProgress;

    // create the response
    _response = [[MTPocketResponse alloc] init];
    NSMutableURLRequest *request = [self preparedRequest];

    // if the request can be sent
    if ([NSURLConnection canHandleRequest:request]) {
        _mutableData = [NSMutableData data];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }

    // if it can't, there's probably not a connection, so we'll just call the failure callback.
    else {
        _response.status = MTPocketStatusNoConnection;
        for (MTPocketCallback handler in _completeHandlers) {
            handler(_response);
        }
        for (MTPocketCallback handler in _failureHandlers) {
            handler(_response);
        }
    }
}

- (void)sendFileData:(NSData *)fileData
            filename:(NSString *)filename
           formField:(NSString *)formField
            MIMEType:(NSString *)MIMEType
             success:(MTPocketCallback)success
             failure:(MTPocketCallback)failure
      uploadProgress:(MTPocketProgressCallback)uploadProgress
{
    _fileData               = fileData;
    _fileUploadFilename     = filename;
    _fileUploadFormField    = formField;
    _fileUploadMIMEType     = MIMEType;
    [self sendWithSuccess:success failure:failure uploadProgress:uploadProgress downloadProgress:nil];
}




#pragma mark - Headers

- (void)addHeaders:(NSDictionary *)dictionary
{
    [_headers addEntriesFromDictionary:dictionary];
}

+ (NSDictionary *)headerDictionaryForBasicAuthWithUsername:(NSString *)username password:(NSString *)password
{
    username = username ? username : @"";
    password = password ? password : @"";
    NSString *plainTextAuth = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString *base64EncodedAuth = [plainTextAuth base64String];
    return @{ @"Authorization" : [NSString stringWithFormat:@"Basic %@", base64EncodedAuth] };
}

+ (NSDictionary *)headerDictionaryForTokenAuthWithToken:(NSString *)token
{
    return @{ @"Authorization" : [NSString stringWithFormat:@"Token token=\"%@\"", token] };
}

+ (NSDictionary *)headerDictionaryForBearerAuthWithToken:(NSString *)token
{
    return @{ @"Authorization" : [NSString stringWithFormat:@"Bearer %@", token] };
}




#pragma mark - Generating URLs

- (NSURL *)URLForPath:(NSString *)path identifiers:(NSArray *)identifiers params:(NSDictionary *)params
{
    // parse the route and insert identifiers
    NSArray *parts = [path componentsSeparatedByString:@"/"];
    NSMutableArray *newParts = [NSMutableArray array];
    NSMutableArray *ids = [NSMutableArray arrayWithArray:identifiers];
    for (NSString *part in parts) {
        if (part.length == 0) continue;
        if ([part characterAtIndex:0] == ':') {
            if (ids.count == 0) continue;
            id object = ids[0];
            id identifier = nil;
            if ([object isKindOfClass:[NSArray class]]) {
                identifier = [(NSArray *)object componentsJoinedByString:@","];
            }
            else {
                identifier = object;
            }
            [ids removeObjectAtIndex:0];
            [newParts addObject:identifier];
        }
        else
            [newParts addObject:part];
    }

    NSString *routeString = [newParts componentsJoinedByString:@"/"];

    // append params
    NSMutableArray *paramPairs = [NSMutableArray array];
    for (NSString *key in [params allKeys]) {
        NSString *value = params[key];
        if ([value isKindOfClass:[NSString class]])
            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [paramPairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSString *paramsString = [paramPairs componentsJoinedByString:@"&"];

    // construct the path
    NSURL *baseURL = _baseURL ? _baseURL : [MTPocket sharedPocket].defaultBaseURL;
    NSURL *URL = [baseURL URLByAppendingPathComponent:routeString];

    // add parameters if present (hackery because URLByAppendingPathCompenent escapes the ? character. Pretty dumb.
    if (params && params.count > 0) URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [URL absoluteString], paramsString]];

    return URL;
}




#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _response.error = error;
    for (MTPocketCallback callback in _completeHandlers) {
        callback(_response);
    }
    for (MTPocketCallback callback in _failureHandlers) {
        callback(_response);
    }
}



#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    _response.statusCode            = response.statusCode;
    _response.MIMEType              = response.MIMEType;
    _response.responseHeaders       = response.allHeaderFields;

    _response.expectedContentLength = response.expectedContentLength;
    if (_contentLengthHeader || (_contentLengthHeader && response.expectedContentLength == NSURLResponseUnknownLength)) {
        NSString *length = _response.responseHeaders[_contentLengthHeader];
        if (length) _response.expectedContentLength = [length integerValue];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
    if (_downloadProgressHandler) {
        NSNumber *loaded    = @([_mutableData length]);
        NSNumber *total     = @(_response.expectedContentLength);
        float percent = [loaded floatValue] / [total floatValue];
        _downloadProgressHandler(percent);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _response.data                  = _mutableData;

    for (MTPocketCallback handler in _completeHandlers) {
        handler(_response);
    }

    if (_response.success) {
        for (MTPocketCallback handler in _successHandlers) {
            handler(_response);
        }
    }
    else {
        for (MTPocketCallback handler in _failureHandlers) {
            handler(_response);
        }
    }
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float percent = totalBytesWritten / totalBytesExpectedToWrite;
    if (_uploadProgressHandler) _uploadProgressHandler(percent);
}








#pragma mark - Private

- (NSMutableURLRequest *)preparedRequest
{
   	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self resolvedURL]];

	// set method
	NSString *method = nil;
	switch (_method) {
		case MTPocketMethodPOST:
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
    _response.format = _format;


    // user agent
    NSString *userAgentString = _userAgent ? _userAgent : @"MTPocket/1.0";

	// prepare headers
    NSDictionary *defaultHeaders = @{ @"Accept" : format, @"Content-Type" : format, @"User-Agent" : userAgentString };
	NSMutableDictionary *headerDictionary = [NSMutableDictionary dictionaryWithDictionary:defaultHeaders];
	[headerDictionary addEntriesFromDictionary:_headers];

    // set headers
	[request setAllHTTPHeaderFields:headerDictionary];



	// set body
    if (_fileData && _fileUploadFormField && _fileUploadFilename && _fileUploadMIMEType) {

        NSString *boundary  = [NSString stringWithFormat:@"----WebKitFormBoundary%@", randomStringWithLength(20)];

        // post body
        NSMutableData *body = [NSMutableData data];

        // add params (all params are strings)
        if ([_body isKindOfClass:[NSDictionary class]]) {
            for (NSString *param in [_body allKeys]) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_body objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }

        // add image data
        if (_fileData) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", _fileUploadFormField, _fileUploadFilename] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", _fileUploadMIMEType] dataUsingEncoding:NSUTF8StringEncoding]];
            _response.requestText = [NSString stringWithUTF8String:[body bytes]];
            [body appendData:_fileData];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];

        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        _response.requestData = body;

    }
	else if (_body) {
		id body = nil;

        if ([_body isKindOfClass:[NSString class]] || [_body isKindOfClass:[NSData class]]) {
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
            _response.requestData = body;
            NSString *requestText = [[NSString alloc] initWithBytes:[(NSData *)body bytes] length:[(NSData *)body length] encoding:NSUTF8StringEncoding];
            _response.requestText = requestText;
		}
        
		else {
			NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
			[request setHTTPBody:bodyData];
            _response.requestData = bodyData;
            _response.requestText = body;
		}

	}

    
	// set timeout
	if (_timeout != 0)
		[request setTimeoutInterval:_timeout];


    // Misc
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    [request setHTTPShouldHandleCookies:NO];



    // set properties on response
    _response.requestHeaders    = headerDictionary;
    _response.pocketRequest     = self;
    _response.request           = request;


    return request;
}






#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MTPocketRequest *copy = [[MTPocketRequest alloc] init];
    copy.baseURL                = [_baseURL copy];
    copy.method                 = _method;
    copy.format                 = _format;
    copy.params                 = [_params mutableCopy];
    copy.headers                = [_headers mutableCopy];
    copy.timeout                = _timeout;
    copy.contentLengthHeader    = [_contentLengthHeader copy];
    copy.userAgent              = [_userAgent copy];
    return copy;
}





@end
