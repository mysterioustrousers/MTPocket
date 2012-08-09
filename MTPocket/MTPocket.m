//
//  MTPocket.m
//  MTPocket
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocket.h"
#import "MF_Base64Additions.h"
#import "XMLDictionary.h"





@implementation MTPocket

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

- (id)fetchObjectWithResult:(MTPocketResult *)result error:(NSError **)error {

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
				body = [NSJSONSerialization dataWithJSONObject:_body options:0 error:&error];
				if (error)
					[[NSException exceptionWithName:@"Invalid Body Object" reason:[error localizedDescription] userInfo:[error userInfo]] raise];
			}
			else if (_format == MTPocketFormatXML) {
				if ([_body isKindOfClass:[NSArray class]]) {
					_body = @{ @"root" : _body };
				}
				body = [_body xmlString];
			}
		}
		else {
			[[NSException exceptionWithName:@"Invalid Body" reason:@"The body must be either an NSString, NSData, NSDictionary or NSArray" userInfo:nil] raise];
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
	NSHTTPURLResponse *response = nil;
	NSError *originalError;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&originalError];	

	// set the status code
	NSString *errorDescription = @"Unknown";
	if ([response statusCode] == 200) {
		*result = MTPocketResultSuccess;
	}
	else if ([response statusCode] == 201) {
		*result = MTPocketResultCreated;
	}
	else if ([response statusCode] == 401 || (originalError && [originalError code] == NSURLErrorUserCancelledAuthentication)) {
		*result = MTPocketResultUnauthorized;
		errorDescription = @"Unauthorized";
	}
	else if ([response statusCode] == 404) {
		*result = MTPocketResultNotFound;
		errorDescription = @"Not Found";
	}
	else if ([response statusCode] == 422) {
		*result = MTPocketResultUnprocessable;
		errorDescription = @"Unprocessable";
	}
	else if (!data) {
		*result = MTPocketResultNoConnection;
		errorDescription = @"No Connection";
	}
	else {
		*result = MTPocketResultOther;
	}

	// if there was an error
	if (*result != MTPocketResultSuccess && *result != MTPocketResultCreated) {
		NSDictionary *dictionary = @{ NSLocalizedDescriptionKey : errorDescription	, @"Data" : data, @"Request" : request, @"Response" : response, @"OriginalError" : originalError };
		*error = [NSError errorWithDomain:@"RequestError" code:[response statusCode] userInfo:dictionary];
		return nil;
	}

	else {
		if (_format == MTPocketFormatHTML || _format == MTPocketFormatTEXT) {
			return [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
		}
		else if (_format == MTPocketFormatJSON) {
			NSError *error = nil;
			id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
			if (error)
				[[NSException exceptionWithName:@"Invalid JSON Returned" reason:[error localizedDescription] userInfo:[error userInfo]] raise];
			else
				return obj;
		}
		else if (_format == MTPocketFormatXML) {
			return [NSDictionary dictionaryWithXMLData:data];
		}
	}


	return nil;
}


@end
