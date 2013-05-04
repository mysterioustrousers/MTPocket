//
//  MTPocket.h
//  MTPocket
//
//  Created by Adam Kirk on 2/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketRequest.h"
#import "MTPocketResponse.h"


/**
 Subclass this in your application and provide a shared instance for it. Override `registerTemplates`
 and add templates for the different kinds of services you will be connecting to. For each request,
 create a reqeust from a template, update the request with specific needs, and send it.

 NOTICE: Templates are totally optional. You can use this library just fine without them. You can
 create a fresh new request, customize it and send it. It's usually pretty nice to have one template
 though for your application so that when you create a request from it, all headers, params, etc are
 already set up and ready to go.
 
 There is no difference between a template and a request. A template is just a stored request that is
 copied to create new request just like it.
*/


@interface MTPocket : NSObject

/**
 Subclassing is not required, you can use this provided shared instance, add templates to it, etc.
 */
+ (instancetype)sharedPocket;

/**
 If you register a template with no base url set, it will use this if not nil.
 */
@property (strong, nonatomic) NSURL *defaultBaseURL;




#pragma mark - Templates

/**
 A dictionary of all the registered request templates.
 */
@property (readonly, nonatomic) NSDictionary *templates;

// override to register your own templates.
/**
 Do not call this directly, the library will call it once when the first attempt to create a request
 from a template is made. In your MTPocket subclass, override this and add/register all of your
 request templates.
 
 NOTE: You must call `super` if you do override this.
 */
- (void)registerTemplates;

/**
 Create an "example" of a common request you will make in your application and save it as a template.
 */
- (void)addTemplateWithRequest:(MTPocketRequest *)request name:(NSString *)name;

/**
 Remove a template from the list of registered templates.
 */
- (void)removeTemplateWithName:(NSString *)name;




#pragma mark - Create Request

/**
 Create a new request from a template. You can pass in nil to all the other params besides "name"
 and you will get an exact copy of the template. Passing in non-nil values to the params allows
 you to create a request AND customize some of its attributes in one step.
 
 `params` will be merged with the params in the template, overwriting any conflicts
 */
- (MTPocketRequest *)requestWithTemplate:(NSString *)name
                                    path:(NSString *)path
                             identifiers:(NSArray *)identifiers
                                  method:(MTPocketMethod)method
                                    body:(id)body
                                  params:(NSDictionary *)params;




@end
