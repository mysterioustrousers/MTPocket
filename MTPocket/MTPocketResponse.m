//
//  MTPocketResponse.m
//  MTPocket
//
//  Created by Adam Kirk on 12/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "mtpocket_private.h"




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
    else if (statusCode == 204) {
        _status = MTPocketStatusNoContent;
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
        if (error.code == NSURLErrorTimedOut) {
            _statusCode = 408;
            _status = MTPocketStatusTimedOut;
        }
    }
}

- (void)setData:(NSData *)data
{
    if (_error) return;

    _data = data;

    _text = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];

    // otherwise, build an object from the response data
    if (_format == MTPocketFormatHTML || _format == MTPocketFormatTEXT)
        _body = _text;

    else if (_format == MTPocketFormatJSON) {
        if ([_text length] > 0) {
            NSError *error = nil;
            _body = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) _error = error;
        }
        else {
            _body = _text;
        }
    }
}


@end

