//
//  MTPocketTests.m
//  MTPocket
//
//  Created by Adam Kirk on 2/18/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketTests.h"
#import "MTPocket.h"
#import "MTPocketRequest.h"
#import "constants.h"



@interface MTPocketRequest ()
- (NSURL *)URLForPath:(NSString *)path identifiers:(NSArray *)identifiers params:(NSDictionary *)params;
@end


@interface MTPocketTests ()
@property (strong, nonatomic) MTPocketRequest *request;
@end



@implementation MTPocketTests


#pragma mark - URL Composition

- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = [NSURL URLWithString:BASE_URL];
    _request = [[MTPocketRequest alloc] init];
}

- (void)testSimpleRoute
{
    NSURL *URL = [_request URLForPath:@"agents" identifiers:nil params:nil];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents"], nil);
}

- (void)testRouteWithId
{
    NSURL *URL = [_request URLForPath:@"agents/:id" identifiers:@[@(2)] params:nil];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents/2"], nil);
}

- (void)testRouteWithTwoIds
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2), @(3) ]  params:nil];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents/2/companies/3"], nil);
}

- (void)testRouteWithNoId
{
    NSURL *URL = [_request URLForPath:@"agents/:id" identifiers:nil  params:nil];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents"], nil);
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents/2/companies/3"], nil);
}

- (void)testRouteWithNoSecondId
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2) ]    params:nil];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents/2/companies"], nil);
}

- (void)testParams
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2) ] params:@{ @"per_page": @(5) }];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents/2/companies?per_page=5"], nil);
}

- (void)testParamsEscaped
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2) ] params:@{ @"search_text": @"adam kirk" }];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/agents/2/companies?search_text=adam%20kirk"], nil);
}

- (void)testMultipleIdsCommaSeperated
{
    NSURL *URL = [_request URLForPath:@"notifications/:id" identifiers:@[ @[ @(2), @(3), @(4) ] ] params:nil];
    STAssertTrue([[URL absoluteString] isEqualToString:@"http://button.herokuapp.com/notifications/2,3,4"], nil);
}



#pragma mark - <#label#>


@end
