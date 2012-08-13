MTPocket
========

A networking pod (Objective-C Library) that doesn't suck. (https://github.com/CocoaPods/CocoaPods/)
Gives you a request object that does all the work for you and a response object that has all the info you'd ever want to know about the transaction.
SUPER easy to use, see examples below.

### Installation

In your Podfile, add this line:

    pod "MTPocket"
  

### Options & Defaults

Here's the header file for your enjoyment:

Important Enums:

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

The Request Object:	
	
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

The Response Object:

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

### Example Usage

(testing off http://button.herokuapp.com)

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

The short way (returns a NSArray/NSDictionary object from JSON):

	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatJSON
														 body:nil];
														
	NSLog(@"%@", [[response.body firstObject] objectForKey:@"thread_color"]); // => red

The short way (returns a NSArray/NSDictionary object from XML):

	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatXML
														 body:nil];
													
	NSLog(@"%@", [[[response.body valueForKeyPath:@"stitch"] firstObject] valueForKeyPath:@"thread-color"]); // => red

Basic HTTP Auth:

	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"needles" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatJSON
													 username:@"username"
													 password:@"password"
														 body:nil];

Post:

	NSDictionary *dict = @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *response = [MTPocketRequest objectAtURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
													   method:MTPocketMethodGET
													   format:MTPocketFormatXML
														 body:dict];
