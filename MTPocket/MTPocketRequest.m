//
//  MTPocketRequest.m
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketRequest.h"
#import <MF_Base64Additions.h>
#import <NSObject+MTJSONUtils.h>
#import <XMLDictionary.h>
#import "mtpocket_private.h"





@implementation MTPocketRequest


static NSNumber *__defaultTimeout;


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
    MTPocketRequest *request        = [[MTPocketRequest alloc] initWithURL:URL];
    request.method                  = method;
    request.format                  = format;
    request.username                = username;
    request.password                = password;
    request.body                    = body;
    return request;
}





- (MTPocketResponse *)send {

    // create the response
    MTPocketResponse *response = [[MTPocketResponse alloc] init];
    NSMutableURLRequest *request = [self requestWithResponse:&response];
    _response = response;

    // send the request
	NSHTTPURLResponse *httpURLResponse = nil;
    NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpURLResponse error:&error];

    // populate the response
    response.statusCode             = httpURLResponse.statusCode;
    response.error                  = error;
    response.data                   = data;
    response.MIMEType               = httpURLResponse.MIMEType;
    response.responseHeaders        = httpURLResponse.allHeaderFields;

    response.expectedContentLength  = httpURLResponse.expectedContentLength;
    if (_lengthHeader || (_lengthHeader && response.expectedContentLength == NSURLResponseUnknownLength)) {
        NSString *length = response.responseHeaders[_lengthHeader];
        if (length) response.expectedContentLength = [length integerValue];
    }

	return response;
}





+ (void)setDefaultTimeout:(NSTimeInterval)timeout
{
    __defaultTimeout = @(timeout);
}








#pragma mark - Private

- (NSMutableURLRequest *)requestWithResponse:(MTPocketResponse **)response
{
   	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_URL];

    
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

    (*response).format = _format;


	// prepare headers
    NSDictionary *defaultHeaders = @{ @"Accept" : format, @"Content-Type" : format };
	NSMutableDictionary *headerDictionary = [NSMutableDictionary dictionaryWithDictionary:defaultHeaders];
	[headerDictionary addEntriesFromDictionary:_headers];

    
	// set body
	if (_body) {
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
            (*response).requestData = body;
            NSString *requestText = [[NSString alloc] initWithBytes:[(NSData *)body bytes] length:[(NSData *)body length] encoding:NSUTF8StringEncoding];
            (*response).requestText = requestText;
		}
        
		else {
			NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
			[request setHTTPBody:bodyData];
            (*response).requestData = bodyData;
            (*response).requestText = body;
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
    (*response).requestHeaders = headerDictionary;


	// set timeout
	if (_timeout || __defaultTimeout)
		[request setTimeoutInterval:(_timeout != 0 ? _timeout : [__defaultTimeout doubleValue])];


    // set properties on response
    (*response).request = request;

    return request;
}






@end
