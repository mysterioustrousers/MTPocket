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





@implementation MTPocketError
+ (MTPocketError *)errorWithError:(NSError *)error {
	return [NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
}
@end








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

- (id)fetchObjectWithResult:(MTPocketResult *)result error:(MTPocketError **)error {

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
				NSError *JSONError = nil;
				body = [NSJSONSerialization dataWithJSONObject:_body options:0 error:&JSONError];

				// If there is an error parsing the JSON, the request can't go on so create a detailed error and return
				if (JSONError) {
					*error = [MTPocketError errorWithError:JSONError];
					(*error).request	= request;
					(*error).response	= nil;
					(*error).data		= nil;
					return nil;
				}
			}
			else if (_format == MTPocketFormatXML) {
				if ([_body isKindOfClass:[NSArray class]]) {
					_body = @{ @"root" : _body };
				}
				body = [_body xmlString];
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
	NSHTTPURLResponse *response = nil;
	NSError *requestError = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];

	// set the status code
	if ([response statusCode] == 200) {
		*result = MTPocketResultSuccess;
	}
	else if ([response statusCode] == 201) {
		*result = MTPocketResultCreated;
	}
	else if ([response statusCode] == 401 || (requestError && [requestError code] == NSURLErrorUserCancelledAuthentication)) {
		*result = MTPocketResultUnauthorized;
	}
	else if ([response statusCode] == 404) {
		*result = MTPocketResultNotFound;
	}
	else if ([response statusCode] == 422) {
		*result = MTPocketResultUnprocessable;
	}
	else if (!data) {
		*result = MTPocketResultNoConnection;
	}
	else {
		*result = MTPocketResultOther;
	}

	// if there was an error
	if (requestError) {
		*error = [MTPocketError errorWithError:requestError];
		(*error).request	= request;
		(*error).response	= response;
		(*error).data		= data;
		return nil;
	}

	else {
		if (_format == MTPocketFormatHTML || _format == MTPocketFormatTEXT) {
			return [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
		}
		else if (_format == MTPocketFormatJSON) {
			NSError *JSONError = nil;
			id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
			if (JSONError) {
				*error = [MTPocketError errorWithError:JSONError];
				(*error).request	= request;
				(*error).response	= response;
				(*error).data		= data;
				return nil;
			}
			else
				return obj;
		}
		else if (_format == MTPocketFormatXML) {
			return [NSDictionary dictionaryWithXMLData:data];
		}
	}


	return nil;
}




#pragma mark - Convenience (Synchronous)

+ (void)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, MTPocketError *error))errorBlock {
	MTPocket *request = [[MTPocket alloc] initWithURL:url];
	request.method	= method;
	request.format	= format;
	request.body	= body;
	MTPocketResult result;
	MTPocketError *error = nil;
	id response = [request fetchObjectWithResult:&result error:&error];
	if (result == MTPocketResultSuccess || result == MTPocketResultCreated) {
		successBlock(response, result);
	}
	else {
		errorBlock(result, error);
	}
}

+ (void)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, MTPocketError *error))errorBlock {
	MTPocket *request = [[MTPocket alloc] initWithURL:url];
	request.method		= method;
	request.format		= format;
	request.body		= body;
	request.username	= username;
	request.password	= password;
	MTPocketResult result;
	MTPocketError *error = nil;
	id response = [request fetchObjectWithResult:&result error:&error];
	if (result == MTPocketResultSuccess || result == MTPocketResultCreated) {
		successBlock(response, result);
	}
	else {
		errorBlock(result, error);
	}
}




#pragma mark - Convenience (Asynchronous)

+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, MTPocketError *error))errorBlock {
	dispatch_queue_t queue = dispatch_get_current_queue();
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		MTPocket *request = [[MTPocket alloc] initWithURL:url];
		request.method	= method;
		request.format	= format;
		request.body	= body;
		MTPocketResult result;
		MTPocketError *error = nil;
		id response = [request fetchObjectWithResult:&result error:&error];
		dispatch_async(queue, ^{
			if (result == MTPocketResultSuccess || result == MTPocketResultCreated) {
				successBlock(response, result);
			}
			else {
				errorBlock(result, error);
			}
		});
	});
}

+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body success:(void (^)(id obj, MTPocketResult result))successBlock error:(void (^)(MTPocketResult result, MTPocketError *error))errorBlock {
	dispatch_queue_t queue = dispatch_get_current_queue();
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		MTPocket *request = [[MTPocket alloc] initWithURL:url];
		request.method		= method;
		request.format		= format;
		request.body		= body;
		request.username	= username;
		request.password	= password;
		MTPocketResult result;
		MTPocketError *error = nil;
		id response = [request fetchObjectWithResult:&result error:&error];
		dispatch_async(queue, ^{
			if (result == MTPocketResultSuccess || result == MTPocketResultCreated) {
				successBlock(response, result);
			}
			else {
				errorBlock(result, error);
			}
		});
	});
}




@end
