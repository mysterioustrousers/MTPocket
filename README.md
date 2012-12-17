MTPocket
========

A objective-c networking library that doesn't suck.
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
3. It allows you to either call it synchronously so you can control what queue its on, which I like, or asynchronously if you want to monitor progress, etc.
4. It's dead simple, two simple components, a request and response object.
5. The enums help a lot and clearly imply your options.
6. Easily upload files as multipart/form-data.
7. Track the progress of a large download or upload.


### Installation

In your Podfile, add this line:

    pod "MTPocket"

pod? => https://github.com/CocoaPods/CocoaPods/

NOTE: You may need to add `-all_load` to "Other Linker Flags" in your targets build settings if the pods library only contains categories.

### Example Usage

Let's start simple:

	MTPocketResponse *response = [MTPocketRequest requestForURL:URL format:MTPocketFormatHTML].send;
	
	if (response.success) {
		// yeah!
	}
	else {
		if (response.status == MTPocketResultNoConnection) {
			NSLog(@"No internets.");
		}
	}

Next steps:

	MTPocketResponse *response = [MTPocketRequest requestForURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
                                                         method:MTPocketMethodGET
                                                         format:MTPocketFormatJSON
                                                       username:@"username"
                                                       password:@"password"
                                                           body:nil].send;
														
	if (response.success) {
		NSLog(@"%@", [[response.body firstObject] objectForKey:@"thread_color"]); // => red
	}
	else if (response.status == MTPocketStatusUnauthorized) {
		// code to let user update their login info
	}

Post to the server:

	NSDictionary *dict = @{ @"stitch" : @{ @"thread_color" : @"blue", @"length" : @3 } };
	MTPocketResponse *response	= [MTPocketRequest requestForURL:[NSURL URLWithString:@"stitches" relativeToURL:_baseURL]
                                                          method:MTPocketMethodPOST
                                                          format:MTPocketFormatJSON
                                                        username:nil
                                                        password:nil
                                                            body:dict].send;

An easy async example:

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BASE_URL
                                                                    method:MTPocketMethodGET
                                                                    format:MTPocketFormatHTML
                                                                      body:nil
                                                                   success:^(MTPocketResponse *successResponse) {
																		NSLog(@"%@", response.body);
                                                                   } failure:^(MTPocketResponse *response) {
																	   	NSLog(@"%@", response.error);
                                                                   }
                                   ].send;

Let's monitor the progress of a large request:

	NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BASE_URL
                                                          downloadProgress:^(long long bytesLoaded, long long bytesTotal) {
                                                              NSLog(@"%@/%@", @(bytesLoaded), @(bytesTotal));
                                                          }
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       NSLog(@"%@", response.body);
                                                                   }
                                                                   failure:^(MTPocketResponse *response) {
																		NSLog(@"%@", response.error);
                                                                   }
                                   ].send;

Easy enough, now let's download a file and save it to disk:

	NSString *location = [DOCS_DIR stringByAppendingPathComponent:@"test.mp3"];

    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:DOWNLOAD_FILE_URL
                                                           destinationPath:location
                                                          downloadProgress:^(long long bytesLoaded, long long bytesTotal) {
                                                              NSLog(@"%@/%@", @(bytesLoaded), @(bytesTotal));
                                                          }
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       NSLog(@"%@", response.body);
                                                                   }
                                                                   failure:^(MTPocketResponse *response) {
																		NSLog(@"%@", response.error);
                                                                   }
                                   ].send;

Ok, now this is cool, because normally it would be a lot of work:

	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:imagePath];
	
    NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:UPLOAD_FILE_URL
                                                                    format:MTPocketFormatJSON
                                                                      body:fileData
                                                            uploadFilename:@"test.jpg"
                                                           uploadFormField:@"files[]"
                                                            uploadMIMEType:@"image/jpeg"
                                                            uploadProgress:^(long long bytesLoaded, long long bytesTotal) {
	                                                              NSLog(@"%@/%@", @(bytesLoaded), @(bytesTotal));
                                                            }
                                                                   success:^(MTPocketResponse *successResponse) {
                                                                       NSLog(@"%@", response.body);
                                                                   }
                                                                   failure:^(MTPocketResponse *response) {
																		NSLog(@"%@", response.error);
                                                                   }
                                   ].send;

That's just the standard stuff. say you want to cook your own totally custom request:

	NSURLConnection *connection = [MTPocketAsyncRequest asyncRequestForURL:BASE_URL
                                                                    method:MTPocketMethodGET
                                                                    format:MTPocketFormatHTML
                                                                      body:nil
                                                                   success:^(MTPocketResponse *successResponse) {
				                                                          NSLog(@"%@", response.body);
                                                                   } failure:^(MTPocketResponse *response) {
																		NSLog(@"%@", response.error);
                                                                   }];
													
	request.username = @"custom";
	request.password = @"request";
	request.headers = @{ @"Super-Rare-Header" : @"Value" };
	request.timeout = 15; // seconds
	
	// then fire it off (this is different than above where we create the request and fire it off at the same time).
	NSURLConnection *connection = [request send];

### Screenshots

As you can see, while debugging, MTPocket provides you with a LOT of very useful information about responses from server:

![Alt screenshot of debugger in XCode](https://dl.dropbox.com/u/2771219/github/MTPocket/1.png "XCode Debugger Interface")

Printing the body of the response:

![Alt screenshot of console in XCode](https://dl.dropbox.com/u/2771219/github/MTPocket/2.png "Printing body of response")

### Enums

	// MTPocketResult
	typedef enum {
	  	MTPocketResultSuccess,
		MTPocketResultCreated,
	  	MTPocketResultUnauthorized,
	  	MTPocketResultUnprocessable,
		MTPocketResultNotFound,
		MTPocketResultNoConnection,
		MTPocketStatusServerError,
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

	@property (readonly)			NSURL           *URL;                                           // (Required, Read-only)
	@property (        nonatomic)	MTPocketMethod  method;                                         // Default: MTPocketMethodGET
	@property (        nonatomic)	MTPocketFormat  format;                                         // Defaut: MTPocketFormatJSON
	@property (strong, nonatomic)	NSString        *username;                                      // (optional) HTTP Basic auth
	@property (strong, nonatomic)	NSString        *password;
	@property (strong, nonatomic)	id              body;                                           // Can be an NSDictionary, NSArray, NSString, NSData, or nil
	@property (strong, nonatomic)	NSDictionary    *headers;                                       // (optional)
	@property (        nonatomic)	NSTimeInterval  timeout;                                        // (optional)

### The Response Object

	@property (readonly) BOOL              success;                 // Easily determine if the request was 100% sucessful. Otherwise, lots of data in other properties to deal with the failure.
	@property (readonly) MTPocketStatus    status;                  // A Mapping of common HTTP status codes to enum.
	@property (readonly) MTPocketFormat    format;                  // The format of the original content. Will always be the same as the request format.
	@property (readonly) id                body;                    // The response body. Depending on the format, could be an NSString, NSArray, NSDictionary or nil.
	
	@property (readonly) NSError           *error;                  // Could be nil, but should check this for important info if its not nil.
	@property (readonly) NSURLRequest      *request;                // The original request made to the server (for debugging).
	@property (readonly) NSData            *data;                   // The data returned form the server (for debugging).
	@property (readonly) NSString          *text;                   // The data converted to a string returned form the server (for debugging).
	@property (readonly) NSData            *requestData;            // The data that was sent as the body with the request (for debugging).
	@property (readonly) NSString          *requestText;            // The data sent with the request converted to a string (for debugging).
	@property (readonly) NSDictionary      *requestHeaders;
	@property (readonly) NSInteger         statusCode;              // The actual integer status code of the response.
	@property (readonly) NSString          *MIMEType;               // What the server reports as the content type of the response.
	@property (readonly) NSInteger         expectedContentLength;   // What the server reports as the expected content length of the response.
	@property (readonly) NSString          *fileDownloadedPath;     // The path of the file if it successfully downloaded and is guaranteed to exist at the path.