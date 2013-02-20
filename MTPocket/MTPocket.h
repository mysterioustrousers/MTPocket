//
//  MTPocket.h
//  MTPocket
//
//  Created by Adam Kirk on 2/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketRequest.h"
#import "MTPocketResponse.h"



@interface MTPocket : NSObject

@property (strong, nonatomic) NSURL *defaultBaseURL;

+ (MTPocket *)sharedPocket;



@property (readonly, nonatomic) NSDictionary *templates;

- (void)addTemplateWithName:(NSString *)name request:(MTPocketRequest *)request;

- (void)removeTemplateWithName:(NSString *)name;



- (MTPocketRequest *)requestWithTemplate:(NSString *)name
                                    path:(NSString *)path
                             identifiers:(NSArray *)identifiers
                                  method:(MTPocketMethod)method
                                    body:(id)body
                                  params:(NSDictionary *)params;        // params will be merged with params in the template




@end
