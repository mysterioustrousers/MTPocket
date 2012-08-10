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
	MTPocket *request	= [[MTPocket alloc] initWithURL:_baseURL];
	request.format		= MTPocketFormatHTML;
	MTPocketResult result;
	MTPocketError *error = nil;
	NSString *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue(response.length > 0, @"String length was 0");
}

- (void)testGetTEXTAuthenticated
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:_baseURL];
	request.format		= MTPocketFormatHTML;
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSString *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue(response.length > 0, @"String length was 0");
}

- (void)testGetJSON
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.format		= MTPocketFormatJSON;
	MTPocketResult result;
	MTPocketError *error = nil;
	NSArray *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue(response.count > 0, nil);
}

- (void)testConvenienceGetJSON {
	[MTPocket objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL] method:MTPocketMethodGET format:MTPocketFormatJSON body:nil success:^(id obj, MTPocketResult result) {
		STAssertTrue(result == MTPocketResultSuccess, nil);
		NSArray *response = (NSArray *)obj;
		STAssertTrue(response.count > 0, nil);
	} error:^(MTPocketResult result, NSError *error) {
		STFail(@"Convenience failed");
	}];
}

- (void)testGetJSONAuthenticated
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.format		= MTPocketFormatJSON;
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSArray *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue(response.count > 0, nil);
}

- (void)testConvenienceGetJSONAuthenitcated {
	[MTPocket objectAtURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL] method:MTPocketMethodGET format:MTPocketFormatJSON username:@"username" password:@"password" body:nil success:^(id obj, MTPocketResult result) {
		STAssertTrue(result == MTPocketResultSuccess, nil);
		NSArray *response = (NSArray *)obj;
		STAssertTrue(response.count > 0, nil);
	} error:^(MTPocketResult result, NSError *error) {
		STFail(@"Convenience failed");
	}];
}

- (void)testGetXML
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.format		= MTPocketFormatXML;
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([(NSArray *)[response valueForKeyPath:@"stitch"] count] > 0, @"String length was 0");
}

- (void)testGetXMLAuthenticated
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.format		= MTPocketFormatXML;
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([(NSArray *)[response valueForKeyPath:@"needle"] count] > 0, @"String length was 0");
}



#pragma mark - POST

- (void)testPostJSON
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.method		= MTPocketMethodPOST;
	request.format		= MTPocketFormatJSON;
	request.body		= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultCreated, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testConveniencePostJSONAuthenitcated {
	NSDictionary *dict = @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	[MTPocket objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL] method:MTPocketMethodPOST format:MTPocketFormatJSON body:dict success:^(id obj, MTPocketResult result) {
		STAssertTrue(result == MTPocketResultCreated, nil);
		NSDictionary *response = (NSDictionary *)obj;
		STAssertNotNil(response, nil);
		STAssertTrue([[response valueForKey:@"length"] intValue] == 3, nil);
	} error:^(MTPocketResult result, MTPocketError *error) {
		STFail(@"Convenience failed");
	}];
}

- (void)testPostJSONAuthenticated
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.method		= MTPocketMethodPOST;
	request.format		= MTPocketFormatJSON;
	request.body		= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultCreated, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKey:@"sharpness"] intValue] == 7, nil);
}

- (void)testPostXML
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	request.method		= MTPocketMethodPOST;
	request.format		= MTPocketFormatXML;
	request.body		= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultCreated, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKeyPath:@"length"] intValue] == 3, nil);
}

- (void)testPostXMLAuthenticated
{
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	request.method		= MTPocketMethodPOST;
	request.format		= MTPocketFormatXML;
	request.body		= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultCreated, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKeyPath:@"sharpness.@innerText"] intValue] == 7, nil);
}

#pragma mark - PUT

- (void)testPutJSON
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatJSON;
	idrequest.body		= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResult idresult;
	MTPocketError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger jsonId = [[idresponse objectForKey:@"id"] intValue];

	NSString *path		= [NSString stringWithFormat:@"stitches/%d", jsonId];
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method		= MTPocketMethodPUT;
	request.format		= MTPocketFormatJSON;
	request.body		= @{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } };
	MTPocketResult result;
	MTPocketError *error = nil;
	NSArray *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue(response.count > 0, nil);
}

- (void)testPutJSONAuthenticated
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatJSON;
	idrequest.body		= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username	= @"username";
	idrequest.password	= @"password";
	MTPocketResult idresult;
	MTPocketError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger jsonId = [[idresponse objectForKey:@"id"] intValue];

	NSString *path		= [NSString stringWithFormat:@"needles/%d", jsonId];
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method		= MTPocketMethodPUT;
	request.format		= MTPocketFormatJSON;
	request.body		= @{ @"needle" : @{ @"sharpness" : @1, @"length" : @1 } };
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKey:@"sharpness"] intValue] == 1, nil);
}

- (void)testPutXML
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatXML;
	idrequest.body		= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResult idresult;
	MTPocketError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger xmlId = [[idresponse valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path = [NSString stringWithFormat:@"stitches/%d", xmlId];
	MTPocket *request = [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method = MTPocketMethodPUT;
	request.format = MTPocketFormatXML;
	request.body	= @{ @"stitch" : @{ @"thread_color" : @"red", @"length" : @2 } };
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKeyPath:@"length"] intValue] == 2, nil);
}

- (void)testPutXMLAuthenticated
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatXML;
	idrequest.body		= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username	= @"username";
	idrequest.password	= @"password";
	MTPocketResult idresult;
	MTPocketError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger xmlId = [[idresponse valueForKeyPath:@"id.@innerText"] intValue];
	
	NSString *path		= [NSString stringWithFormat:@"needles/%d", xmlId];
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method		= MTPocketMethodPUT;
	request.format		= MTPocketFormatXML;
	request.body		= @{ @"needle" : @{ @"sharpness" : @2, @"length" : @1 } };
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKeyPath:@"sharpness.@innerText"] intValue] == 2, nil);
}

#pragma mark - PUT

- (void)testDeleteJSON
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatJSON;
	idrequest.body		= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResult idresult;
	MTPocketError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger jsonId = [[idresponse objectForKey:@"id"] intValue];

	NSString *path		= [NSString stringWithFormat:@"stitches/%d", jsonId];
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method		= MTPocketMethodDELETE;
	request.format		= MTPocketFormatJSON;
	MTPocketResult result;
	MTPocketError *error = nil;
	NSArray *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKey:@"length"] intValue] == 3, nil);
}

- (void)testDeleteJSONAuthenticated
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatJSON;
	idrequest.body		= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username	= @"username";
	idrequest.password	= @"password";
	MTPocketResult idresult;
	NSError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger jsonId = [[idresponse objectForKey:@"id"] intValue];

	NSString *path		= [NSString stringWithFormat:@"needles/%d", jsonId];
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method		= MTPocketMethodDELETE;
	request.format		= MTPocketFormatJSON;
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKey:@"sharpness"] intValue] == 7, nil);
}

- (void)testDeleteXML
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatXML;
	idrequest.body		= @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResult idresult;
	MTPocketError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger xmlId = [[idresponse valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path = [NSString stringWithFormat:@"stitches/%d", xmlId];
	MTPocket *request = [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method = MTPocketMethodDELETE;
	request.format = MTPocketFormatXML;
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKeyPath:@"length"] intValue] == 3, nil);
}

- (void)testDeleteXMLAuthenticated
{
	MTPocket *idrequest = [[MTPocket alloc] initWithURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]];
	idrequest.method	= MTPocketMethodPOST;
	idrequest.format	= MTPocketFormatXML;
	idrequest.body		= @{ @"needle" : @{ @"sharpness" : @7, @"length" : @3 } };
	idrequest.username	= @"username";
	idrequest.password	= @"password";
	MTPocketResult idresult;
	MTPocketError *iderror = nil;
	NSDictionary *idresponse = [idrequest fetchObjectWithResult:&idresult error:&iderror];
	NSInteger xmlId = [[idresponse valueForKeyPath:@"id.@innerText"] intValue];

	NSString *path		= [NSString stringWithFormat:@"needles/%d", xmlId];
	MTPocket *request	= [[MTPocket alloc] initWithURL:[NSURL URLWithString:path relativeToURL:_baseURL]];
	request.method		= MTPocketMethodDELETE;
	request.format		= MTPocketFormatXML;
	request.username	= @"username";
	request.password	= @"password";
	MTPocketResult result;
	MTPocketError *error = nil;
	NSDictionary *response = [request fetchObjectWithResult:&result error:&error];
	STAssertNil(error, @"Error was not nil: %@", error);
	STAssertTrue(result == MTPocketResultSuccess, nil);
	STAssertNotNil(response, nil);
	STAssertTrue([[response valueForKeyPath:@"sharpness.@innerText"] intValue] == 7, nil);
}


@end
