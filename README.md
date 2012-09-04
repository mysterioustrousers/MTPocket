MTPocket
========

A networking pod (Objective-C Library) that doesn't suck. (https://github.com/CocoaPods/CocoaPods/)
Gives you a request object that does all the work for you and a response object that has all the info you'd ever want to know about the transaction.
SUPER easy to use, see examples below.

### Advantages

1. It gives you comprehensive response object that contains all the info you'd ever want to know about the response:
	- a boolean success property, yes or no if successful.
	- the dictionary/array object generated from the response data.
	- the raw data returned by the server (for debugging).
	- the raw data returned by the server converted to a UTF-8 encoded string (for even easier debugging).
	- the original request object.
	- the apple response object (has status codes, etc.).
	- an error object, nil if no error.
	- a status property with common status codes mapped to easy to remember/autocompleted enums.
	- the format the response is in (JSON/XML/TEXT).
2. It allows you to have fine grained control, if you want it, or you can use convenience methods.
3. It allows you to either call it synchronously so you can control what queue its on, which I like, or asynchronously on a global queue, if you don't care.
4. It's dead simple, two simple components, a request and response object.
5. The enums help a lot and clearly imply your options.


### Installation

In your Podfile, add this line:

    pod "MTPocket"

pod? => https://github.com/CocoaPods/CocoaPods/

NOTE: You may need to add `-all_load` to "Other Linker Flags" in your targets build settings if the pods library only contains categories.

### Example Usage

The long way:

	MTPocketRequest *request	= [[MTPocketRequest alloc] initWithURL:_baseURL];
	request.format				= MTPocketFormatHTML;
	request.username			= @"username";
	request.password			= @"password";
	MTPocketResponse *response	= [request fetch];
	
	if (response.success) {
		// yeah!
	}
	else {
		if (response.status == MTPocketResultNoConnection) {
			NSLog(@"The internets are down.");
		}
	}

The short way (synchronous):

	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatJSON
														 body:nil];
														
	if (response.success) {
		NSLog(@"%@", [[response.body firstObject] objectForKey:@"thread_color"]); // => red
	}

The short way (asynchronous):

	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatJSON
														 body:nil
													 complete:^(MTPocketResponse *response) {
														if (response.success) {
															NSLog(@"%@", [[response.body firstObject] objectForKey:@"thread_color"]); // => red
														}
														else if (response.error) {
															NSLog(@"%@", [error localizedDescription]);
														}
													}];

Basic HTTP Auth:

	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatJSON
													 username:@"username"
													 password:@"password"
														 body:nil];
														
	if (response.success) {
		NSLog(@"%@", [[response.body firstObject] objectForKey:@"thread_color"]); // => red
	}
	else if (response.status == MTPocketStatusUnauthorized) {
		// code to let user update their login info
	}

Post:

	NSDictionary *dict = @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodPOST
													   format:MTPocketFormatXML
														 body:dict];

### Screenshots

As you can see, while debugging, MTPocket provides you with a LOT of very useful information about responses from server:

![Alt screenshot of debugger in XCode](http://d.pr/i/R0nb/2GQ5NysC "XCode Debugger Interface")

Printing the body of the response:

![Alt screenshot of console in XCode](http://d.pr/i/fMuY/uqfLDL5a "Printing body of response")

### Enums

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

### The Request Object

	@interface MTPocketRequest : NSObject
	
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
	- (id)fetch;
	
	// Convenience (synchronous) 
	+ (MTPocketResponse *)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body;
	+ (MTPocketResponse *)objectAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body;
	
	// Convenience (asynchronous)
	+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format body:(id)body complete:(void (^)(MTPocketResponse *response))completeBlock;
	+ (void)objectAsynchronouslyAtURL:(NSURL *)url method:(MTPocketMethod)method format:(MTPocketFormat)format username:(NSString *)username password:(NSString *)password body:(id)body complete:(void (^)(MTPocketResponse *response))completeBlock;
	
	@end

### The Response Object

	@interface MTPocketResponse : NSHTTPURLResponse
	
	@property (nonatomic) BOOL success;						// Easily determine if the request was 100% sucessful. Otherwise, lots of data to deal with the failure.
	@property (nonatomic) MTPocketStatus status;			// A Mapping of common HTTP status codes to enum.
	@property (nonatomic) MTPocketFormat format;			// The format of the original content. Will always be the same as the request format.
	@property (strong, nonatomic) id body;					// The response body. Depending on the format, could be an NSString, NSArray, NSDictionary or nil.
	@property (strong, nonatomic) NSData *data;				// The data returned form the server for debugging.
	@property (strong, nonatomic) NSString *text;			// The data converted to a string returned form the server for debugging.
	@property (strong, nonatomic) NSURLRequest *request;	// The original request made to the server.
	@property (strong, nonatomic) NSError *error;			// Could be nil, but should check this for important info if its not nil.
	
	@end