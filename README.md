MTPocket
========

A networking pod (Objective-C Library) that doesn't suck. (https://github.com/CocoaPods/CocoaPods/)

### Installation

In your Podfile, add this line:

    pod "MTPocket"
  

### Options & Defaults

Here's the header file for your enjoyment:

	// MTPocketResult
	typedef enum {
	  	MTPocketResultSuccess,
		MTPocketResultCreated,
	  	MTPocketResultUnauthorized,
	  	MTPocketResultUnprocessable,
		MTPocketResultNotFound,
		MTPocketResultNoConnection,
		MTPocketResultOther,
	} MTPocketResult;
	
	// MTPocketFormat
	typedef enum {
		MTPocketFormatJSON,
		MTPocketFormatXML,
		MTPocketFormatHTML,
		MTPocketFormatTEXT
	} MTPocketFormat;
	
	// MTPocketMethod
	typedef enum {
		MTPocketMethodGET,
		MTPocketMethodPOST,
		MTPocketMethodPUT,
		MTPocketMethodDELETE
	} MTPocketMethod;
	
	
	@interface MTPocket : NSObject
	
	@property (readonly)			NSURL *url;				// required, readonly
	@property (nonatomic)			MTPocketMethod method;	// default: MTPocketMethodGET
	@property (nonatomic)			MTPocketFormat format;	// defaut: MTPocketFormatJSON
	@property (strong, nonatomic)	NSString *username;		// optional, HTTP Basic auth
	@property (strong, nonatomic)	NSString *password;
	@property (strong, nonatomic)	id body;				// can be a dictionary, array, string or data
	@property (strong, nonatomic)	NSDictionary *headers;	// optional
	@property (nonatomic)			NSTimeInterval timeout;	// optional
	
	// Create and set properties. Use this if you need to set timeout, headers, etc.
	- (id)initWithURL:(NSURL *)url;
	- (id)fetchObjectWithResult:(MTPocketResult *)result error:(NSError **)error;

And then there is this handy error object that contains all the info you'd ever want to know about what went wrong:

	@interface MTPocketError : NSError
	@property (strong, nonatomic) NSData *data;
	@property (strong, nonatomic) NSURLRequest *request;
	@property (strong, nonatomic) NSURLResponse *response;
	+ (MTPocketError *)errorWithError:(NSError *)error;
	@end

### Example Usage

(testing off http://button.herokuapp.com)

The long way:

    MTPocket *request	= [[MTPocket alloc] initWithURL:_baseURL];
	request.format		= MTPocketFormatHTML;
	MTPocketResult result;
	MTPocketError *error = nil;
	NSString *response = [request fetchObjectWithResult:&result error:&error];
	if (result == MTPocketResultSuccess) {
		// yeah!
	}
	else {
		// darn.
		if (result == MTPocketResultNoConnection) {
			NSLog(@"The internets are down.");
		}
	}

The short way (returns a NSArray/NSDictionary object from JSON):

	[MTPocket objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL] method:MTPocketMethodGET format:MTPocketFormatJSON body:nil success:^(id obj, MTPocketResult result) {
		NSArray *response = (NSArray *)obj;
	} error:^(MTPocketResult result, MTPocketError *error) {
	}];

The short way (returns a NSArray/NSDictionary object from XML):

	[MTPocket objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL] method:MTPocketMethodGET format:MTPocketFormatXML body:nil success:^(id obj, MTPocketResult result) {
		NSArray *response = (NSArray *)obj;
	} error:^(MTPocketResult result, MTPocketError *error) {
	}];

Basic HTTP Auth:

	[MTPocket objectAtURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL] method:MTPocketMethodGET format:MTPocketFormatJSON username:@"username" password:@"password" body:nil success:^(id obj, MTPocketResult result) {
		NSArray *response = (NSArray *)obj;
	} error:^(MTPocketResult result, MTPocketError *error) {
	}];


Post:

	NSDictionary *dict = @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	[MTPocket objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL] method:MTPocketMethodPOST format:MTPocketFormatJSON body:dict success:^(id obj, MTPocketResult result) {
		NSDictionary *response = (NSDictionary *)obj;
	} error:^(MTPocketResult result, MTPocketError *error) {
	}];
