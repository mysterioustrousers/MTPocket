MTPocket
========

A objective-c networking library that doesn't suck. Setting up network requests can be a pain, so MTPocket lets you define request templates and then you can create requests from those templates anywhere in your application. Cool eh?

### Advantages

- Simple API.
- Templates.
- Asynchronous.
- Success/failure callbacks.
  - You can actually add multiple success/failure callbacks. This is great for building libraries. The library builds a request, adds callback to handle the data and returns the request to the calling application to add its own callbacks and send the request.
- Upload/Download progress callbacks.
- Multi-part form uploads.
- Awesome URL path building.

### Installation

In your Podfile, add this line:

    pod "MTPocket"

pod? => https://github.com/CocoaPods/CocoaPods/

NOTE: You may need to add `-all_load` to "Other Linker Flags" in your targets build settings if the pods library only contains categories.

### Example Usage

Set up the base url:

    [MTPocket sharedPocket].defaultBaseURL = [NSURL URLWithString:@"http://button.herokuapp.com/"];

A simple request:

    MTPocketRequest *request = [MTPocketRequest requestWithPath:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    request.format = MTPocketFormatJSON;
    [request addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];
    [request sendWithSuccess:^(MTPocketResponse *response) {
        _player.id = response.body[@"id"];
        [self.tableView reloadData];
    } failure:^(MTPocketResponse *response) {
        // handle failure...
    }];

Create a template:

    MTPocketRequest *template = [MTPocketRequest requestTemplate];
    template.format = MTPocketFormatJSON;
    template.timeout = 2;
    [template addHeaders:[MTPocketRequest headerDictionaryForBasicAuthWithUsername:UN password:PW]];
    [template.params addEntriesFromDictionary:@{ @"sessionId": @"fewoijalkfsdjlfsdhlaes" }];
    [[MTPocket sharedPocket] addRequestTemplate:template name:@"api"];

Create and perform a request with that template:

    MTPocketRequest *request = [[MTPocket sharedPocket] requestWithTemplate:@"api" path:@"needles/:id" identifiers:@[ @(identifier) ] method:MTPocketMethodGET body:nil params:nil];
    [request sendWithSuccess:^(MTPocketResponse *response) {
        _person.name = respone.body[@"name"];
    } failure:^(MTPocketResponse *response) {
        // handle failure...
    }];

Monitor upload/download progress:

    MTPocketRequest *request = [[MTPocket sharedPocket] requestWithTemplate:@"api" path:@"needles" identifiers:nil method:MTPocketMethodGET body:nil params:nil];
    [request sendWithSuccess:^(MTPocketResponse *response) {
        [SVProgressHUD showSuccessWithStatus:@"Downloaded"];
        _file = response.body;
    } failure:^(MTPocketResponse *response) {
        [SVProgressHUD showErrorWithStatus:@"Darn"];
    } uploadProgress:^(float percent) {
        [SVProgressHUD showProgress:percent];
    } downloadProgress:^(float percent) {
        [SVProgressHUD showProgress:percent];
    }];

Upload a file as a multipart form:

    [request sendFileData:fileData
                 filename:@"test.jpg"
                formField:@"files[]"
                 MIMEType:@"image/jpeg"
                  success:^(MTPocketResponse *resp) {
                      [SVProgressHUD showSuccessWithStatus:@"Uploaded"];
                 } failure:^(MTPocketResponse *response) {
                      [SVProgressHUD showErrorWithStatus:@"Darn"];
                 } uploadProgress:^(float percent) {
                      [SVProgressHUD showProgress:percent];
                 }];

Easily create URL paths with ids (even multiple comma seperated ids):

    MTPocketRequest *request = [[MTPocket sharedPocket] requestWithTemplate:@"api" path:@"companies/:company_id/employee/:id" identifiers:@[ @(3), @[ @(2), @(4) ]] method:MTPocketMethodGET body:nil params:nil];
    // => @"http://www.example.com/companies/3/employee/2,4"

### Screenshots

As you can see, while debugging, MTPocket provides you with a LOT of very useful information about responses from server:

![Alt screenshot of debugger in XCode](https://dl.dropbox.com/u/2771219/github/MTPocket/1.png "XCode Debugger Interface")

Printing the body of the response:

![Alt screenshot of console in XCode](https://dl.dropbox.com/u/2771219/github/MTPocket/2.png "Printing body of response")

### The Request Object

    @property (strong,  nonatomic)   NSURL              *baseURL;               // (optional) Will override the default base URL set on the shared pocket singleton

Basic options

    @property (strong,  nonatomic)  NSString            *path;                  // (required) The resource path after the base url. Can include placeholders like ':id' that will be filled in respectively with 'identifiers'. e.g. @"buttons/:button_id/stitches/:id"
    @property (strong,  nonatomic)  NSArray             *identifiers;           // (required) NSNumber/NSString objects that are swapping it
    @property (         nonatomic)  MTPocketMethod      method;                 // (required) Default: MTPocketMethodGET
    @property (         nonatomic)  MTPocketFormat      format;                 // (required) Defaut: MTPocketFormatJSON
    @property (readonly,nonatomic)  NSMutableDictionary *params;                // (optional) Query string params. @{ @"page" : @(2) } => ?page=2
    @property (strong,  nonatomic)  id                  body;                   // (optional) The body of the request. Can be NSData, NSString, NSDictionary, NSArray.

Additional options

    @property (readonly,nonatomic)  NSMutableDictionary *headers;               // (optional) The headers dictionary. You can add or delete from the template.
    @property (         nonatomic)  NSTimeInterval      timeout;                // (optional) Default: 60 seconds.
    @property (strong,  nonatomic)  NSString            *contentLengthHeader;   // (optional) Default: Content-Length. Could also be stream-length, etc. Will be used for progress handlers.

### The Response Object

    @property (nonatomic, readonly)         BOOL              success;                 // Easily determine if the request was 100% sucessful. Otherwise, lots of data in other properties to deal with the failure.
    @property (nonatomic, readonly)         MTPocketStatus    status;                  // A Mapping of common HTTP status codes to enum.
    @property (nonatomic, readonly)         MTPocketFormat    format;                  // The format of the original content. Will always be the same as the request format.
    @property (nonatomic, readonly, strong) id                body;                    // The response body. Depending on the format, could be an NSString, NSArray, NSDictionary or nil.
    @property (nonatomic, readonly, strong) NSError           *error;                  // Could be nil, but should check this for important info if its not nil.
    @property (nonatomic, readonly, strong) NSURLRequest      *request;                // The original request made to the server (for debugging).
    @property (nonatomic, readonly, strong) MTPocketRequest   *pocketRequest;          // The original request made to the server (for debugging).
    @property (nonatomic, readonly, strong) NSData            *data;                   // The data returned form the server (for debugging).
    @property (nonatomic, readonly, strong) NSString          *text;                   // The data converted to a string returned form the server (for debugging).
    @property (nonatomic, readonly, strong) NSData            *requestData;            // The data that was sent as the body with the request (for debugging).
    @property (nonatomic, readonly, strong) NSString          *requestText;            // The data sent with the request converted to a string (for debugging).
    @property (nonatomic, readonly, strong) NSDictionary      *requestHeaders;
    @property (nonatomic, readonly, strong) NSDictionary      *responseHeaders;
    @property (nonatomic, readonly)         NSInteger         statusCode;              // The actual integer status code of the response.
    @property (nonatomic, readonly, strong) NSString          *MIMEType;               // What the server reports as the content type of the response.
    @property (nonatomic, readonly)         NSInteger         expectedContentLength;   // What the server reports as the expected content length of the response.
