//
//  MTPocketTests.m
//  MTPocketTests
//
//  Created by Adam Kirk on 8/4/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTests.h"
#import "MTPocket.h"

@implementation MTPocketTests

- (void)setUp
{
    [super setUp];
	_baseURL = [NSURL URLWithString:@"http://button.herokuapp.com/"];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - GET

- (void)testGetTEXT
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:_baseURL];
	request.format				= MTPocketFormatHTML;
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body length] > 0, @"String length was 0");
}

- (void)testGetTEXTAuthenticated
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:_baseURL];
	request.format				= MTPocketFormatHTML;
	request.username			= @"username";
	request.password			= @"password";
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body length] > 0, @"String length was 0");
}

- (void)testGetJSON
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.format				= MTPocketFormatJSON;
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testConvenienceGetJSON {
	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatJSON
														 body:nil];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testGetJSONAuthenticated
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.format				= MTPocketFormatJSON;
	request.username			= @"username";
	request.password			= @"password";
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testConvenienceGetJSONAuthenitcated {
	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatJSON
													 username:@"username"
													 password:@"password"
														 body:nil];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testGetXML
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.format				= MTPocketFormatXML;
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"stitch"] count] > 0, @"String length was 0");
}

- (void)testGetXMLAuthenticated
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.format				= MTPocketFormatXML;
	request.username			= @"username";
	request.password			= @"password";
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"needle"] count] > 0, @"String length was 0");
}



#pragma mark - POST

- (void)testPostJSON
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.method				= MTPocketMethodPOST;
	request.format				= MTPocketFormatJSON;
	request.body				= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testConveniencePostJSONAuthenitcated {
	NSDictionary *dict = @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodPOST
													   format:MTPocketFormatJSON
														 body:dict];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testPostJSONAuthenticated
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.method				= MTPocketMethodPOST;
	request.format				= MTPocketFormatJSON;
	request.body				= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	request.username			= @"username";
	request.password			= @"password";
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"sharpness"] intValue] == 7, nil);
}

- (void)testPostXML
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.method				= MTPocketMethodPOST;
	request.format				= MTPocketFormatXML;
	request.body				= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"length"] intValue] == 3, nil);
}

- (void)testPostXMLAuthenticated
{
	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.method				= MTPocketMethodPOST;
	request.format				= MTPocketFormatXML;
	request.body				= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	request.username			= @"username";
	request.password			= @"password";
	MTPocketResponse *response	= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusCreated, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"sharpness.@innerText"] intValue] == 7, nil);
}

#pragma mark - PUT

- (void)testPutJSON
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatJSON;
	idrequest.body					= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", jsonId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodPUT;
	request.format					= MTPocketFormatJSON;
	request.body					= @{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } };
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([response.body count] > 0, nil);
}

- (void)testPutJSONAuthenticated
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatJSON;
	idrequest.body					= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username				= @"username";
	idrequest.password				= @"password";
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"needles/%d", jsonId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodPUT;
	request.format					= MTPocketFormatJSON;
	request.body					= @{ @"needle" : @{ @"sharpness" : @1, @"length" : @1 } };
	request.username				= @"username";
	request.password				= @"password";
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"sharpness"] intValue] == 1, nil);
}

- (void)testPutXML
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatXML;
	idrequest.body					= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", xmlId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodPUT;
	request.format					= MTPocketFormatXML;
	request.body					= @{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } };
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"length"] intValue] == 2, nil);
}

- (void)testPutXMLAuthenticated
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatXML;
	idrequest.body					= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username				= @"username";
	idrequest.password				= @"password";
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];
	
	NSString *path					= [NSString stringWithFormat:@"needles/%d", xmlId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodPUT;
	request.format					= MTPocketFormatXML;
	request.body					= @{ @"needle" : @{ @"sharpness" : @2, @"length" : @1 } };
	request.username				= @"username";
	request.password				= @"password";
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"sharpness.@innerText"] intValue] == 2, nil);
}

#pragma mark - PUT

- (void)testDeleteJSON
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatJSON;
	idrequest.body					= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", jsonId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodDELETE;
	request.format					= MTPocketFormatJSON;
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testDeleteJSONAuthenticated
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatJSON;
	idrequest.body					= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username				= @"username";
	idrequest.password				= @"password";
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger jsonId				= [[idresponse.body objectForKey:@"id"] intValue];

	NSString *path					= [NSString stringWithFormat:@"needles/%d", jsonId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodDELETE;
	request.format					= MTPocketFormatJSON;
	request.username				= @"username";
	request.password				= @"password";
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKey:@"sharpness"] intValue] == 7, nil);
}

- (void)testDeleteXML
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatXML;
	idrequest.body					= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path					= [NSString stringWithFormat:@"stitches/%d", xmlId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodDELETE;
	request.format					= MTPocketFormatXML;
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"length"] intValue] == 3, nil);
}

- (void)testDeleteXMLAuthenticated
{
	MTPocketRequest *idrequest		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method				= MTPocketMethodPOST;
	idrequest.format				= MTPocketFormatXML;
	idrequest.body					= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username				= @"username";
	idrequest.password				= @"password";
	MTPocketResponse *idresponse	= [idrequest fetch];
	NSInteger xmlId					= [[idresponse.body valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path					= [NSString stringWithFormat:@"needles/%d", xmlId];
	MTPocketRequest *request		= [[MTPocketRequest alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method					= MTPocketMethodDELETE;
	request.format					= MTPocketFormatXML;
	request.username				= @"username";
	request.password				= @"password";
	MTPocketResponse *response		= [request fetch];

	STAssertNil(response.error, @"Error was not nil: %@", response.error);
	STAssertTrue(response.status == MTPocketStatusSuccess, nil);
	STAssertNotNil(response.body, nil);
	STAssertTrue([[response.body valueForKeyPath:@"sharpness.@innerText"] intValue] == 7, nil);
}


@end
