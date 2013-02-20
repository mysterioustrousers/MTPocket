//
//  MTPocket.m
//  MTPocket
//
//  Created by Adam Kirk on 2/17/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


#import "mtpocket_private.h"


@interface MTPocket ()
@property (strong, readwrite, nonatomic) NSDictionary *templates;
@end


@implementation MTPocket

- (id)init
{
    self = [super init];
    if (self) {
        _templates = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (MTPocket *)sharedPocket
{
    static MTPocket *__sharedPocket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedPocket = [[MTPocket alloc] init];
        [__sharedPocket registerTemplates];
    });
    return __sharedPocket;
}

- (void)addRequestTemplate:(MTPocketRequest *)request name:(NSString *)name
{
    NSMutableDictionary *dict = (NSMutableDictionary *)_templates;
    dict[name] = [request copy];
}

- (void)removeTemplateWithName:(NSString *)name
{
    NSMutableDictionary *dict = (NSMutableDictionary *)_templates;
    dict[name] = nil;
}

- (MTPocketRequest *)requestWithTemplate:(NSString *)name
                                    path:(NSString *)path
                             identifiers:(NSArray *)identifiers
                                  method:(MTPocketMethod)method
                                    body:(id)body
                                  params:(NSDictionary *)params
{
    MTPocketRequest *request = [_templates[name] copy];
    request.path            = path;
    request.identifiers     = identifiers;
    request.method          = method;
    request.body            = body;
    if (params) [request.params addEntriesFromDictionary:params];
    return request;
}




#pragma mark - Methods to override

- (void)registerTemplates
{
}





@end
