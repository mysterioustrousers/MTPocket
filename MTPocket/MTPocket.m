//
//  MTPocket.m
//  MTPocket
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <MF_Base64Additions.h>
#import <XMLDictionary.h>
#import <NSDictionary+MTJSONDictionary.h>
#import "MTPocket.h"




@implementation MTPocketResponse

+ (MTPocketResponse *)responseWithResponse:(NSURLResponse *)resp {
	MTPocketResponse *response = [[MTPocketResponse alloc] initWithURL:resp.URL MIMEType:resp.MIMEType expectedContentLength:resp.expectedContentLength textEncodingName:resp.textEncodingName];
	response.success = NO;
	response.body = nil;
	response.error = nil;
	return response;
}

@end








@implementation MTPocketRequest

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url	= url;
		_method = MTPocketMethodGET;
		_format = MTPocketFormatJSON;
    }
    return self;
}

- (MTPocketResponse *)fetch {

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];

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

	// prepare headers
	NSMutableDictionary *headerDictionary = [NSMutableDictionary dictionaryWithDictionary:_headers];
	[headerDictionary addEntriesFromDictionary:@{ @"Accept" : format, @"Content-Type" : format }];

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
			}
		}
		else {
			// These problems need to be caught in development, so we throw an exception
			[[NSException exceptionWithName:@"Invalid Body" reason:@"The body must be either an NSString, NSData, NSDictionary or NSArray, or nil" userInfo:nil] raise];
		}

		if ([body isKindOfClass:[NSData class]]) {
			[request setHTTPBody:body];
		}
		else {
			[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
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

	// set timeout
	if (_timeout)
		[request setTimeoutInterval:_timeout];

	// make the request
	NSHTTPURLResponse *httpURLResponse = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpURLResponse error:&error];

	// form the response
	MTPocketResponse *response = [MTPocketResponse responseWithResponse:httpURLResponse];
	response.format		= _format;
	response.request	= request;
	response.data		= data;
	response.text		= [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];

	// set the status
	if ([httpURLResponse statusCode] == 200) {
		response.status = MTPocketStatusSuccess;
		response.success = YES;
	}
	else if ([httpURLResponse statusCode] == 201) {
		response.status = MTPocketStatusCreated;
		response.success = YES;
	}
	else if ([httpURLResponse statusCode] == 401 || (error && [error code] == NSURLErrorUserCancelledAuthentication)) {
		response.status = MTPocketStatusUnauthorized;
	}
	else if ([httpURLResponse statusCode] == 404) {
		response.status = MTPocketStatusNotFound;
	}
	else if ([httpURLResponse statusCode] == 422) {
		response.status = MTPocketStatusUnprocessable;
	}
	else if (!data) {
		response.status = MTPocketStatusNoConnection;
	}
	else {
		response.status = MTPocketStatusOther;
	}

	// if there was an error
	if (error) response.error = error;

	// otherwise, build an object from the response data
	else {
		if (_format == MTPocketFormatHTML || _format == MTPocketFormatTEXT) {
			response.body = response.text;
		}
		else if (_format == MTPocketFormatJSON) {
			NSError *error = nil;
			response.body = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
			if (error) response.error = error;
		}
		else if (_format == MTPocketFormatXML) {
			response.body = [NSDictionary dictionaryWithXMLData:data];
		}
	}

	return response;
}




#pragma mark - Convenience (Synchronous)

+ (MTPocketResponse *)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body {
	MTPocketRequest *request = [[MTPocketRequest alloc] initWithURL:url];
	request.method	= method;
	request.format	= format;
	request.body	= body;
	MTPocketResponse *response = [request fetch];
	return response;
}

+ (MTPocketResponse *)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body {
	MTPocketRequest *request = [[MTPocketRequest alloc] initWithURL:url];
	request.method		= method;
	request.format		= format;
	request.body		= body;
	request.username	= username;
	request.password	= password;
	MTPocketResponse *response = [request fetch];
	return response;
}




#pragma mark - Convenience (Asynchronous)

+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body complete:(void (^)(MTPocketResponse *response))completeBlock {
	dispatch_queue_t queue = dispatch_get_current_queue();
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		MTPocketRequest *request = [[MTPocketRequest alloc] initWithURL:url];
		request.method	= method;
		request.format	= format;
		request.body	= body;
		MTPocketResponse *response = [request fetch];
		dispatch_async(queue, ^{
			completeBlock(response);
		});
	});
}

+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body complete:(void (^)(MTPocketResponse *response))completeBlock {
	dispatch_queue_t queue = dispatch_get_current_queue();
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		MTPocketRequest *request = [[MTPocketRequest alloc] initWithURL:url];
		request.method		= method;
		request.format		= format;
		request.body		= body;
		request.username	= username;
		request.password	= password;
		MTPocketResponse *response = [request fetch];
		dispatch_async(queue, ^{
			completeBlock(response);
		});
	});
}




@end
