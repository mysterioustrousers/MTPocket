//
//  MTPocketTests.m
//  MTPocket
//
//  Created by Adam Kirk on 2/18/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTPocketPathTests.h"
#import "MTPocket.h"
#import "MTPocketRequest.h"
#import "constants.h"
#import "macros.h"



@interface MTPocketRequest ()
- (NSURL *)URLForPath:(NSString *)path identifiers:(NSArray *)identifiers params:(NSDictionary *)params;
@end


@interface MTPocketPathTests ()
@property (strong, nonatomic) MTPocketRequest *request;
@end



@implementation MTPocketPathTests


#pragma mark - URL Composition

- (void)setUp
{
    [MTPocket sharedPocket].defaultBaseURL = BASE_URL;
    _request = [[MTPocketRequest alloc] init];
}

- (void)testSimpleRoute
{
    NSURL *URL = [_request URLForPath:@"agents" identifiers:nil params:nil];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/agents")]);
}

- (void)testRouteWithId
{
    NSURL *URL = [_request URLForPath:@"agents/:id" identifiers:@[@(2)] params:nil];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/agents/2")]);
}

- (void)testRouteWithTwoIds
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2), @(3) ]  params:nil];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/agents/2/companies/3")]);
}

- (void)testRouteWithNoId
{
    NSURL *URL = [_request URLForPath:@"agents/:id" identifiers:nil  params:nil];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/agents")]);
}

- (void)testRouteWithNoSecondId
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2) ]    params:nil];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/agents/2/companies")]);
}

- (void)testParams
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2) ] params:@{ @"per_page": @(5) }];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/agents/2/companies?per_page=5")]);
}

- (void)testParamsEscaped
{
    NSURL *URL = [_request URLForPath:@"agents/:id/companies/:company_id" identifiers:@[ @(2) ] params:@{ @"search_text": @"adam kirk" }];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/agents/2/companies?search_text=adam%20kirk")]);
}

- (void)testMultipleIdsCommaSeperated
{
    NSURL *URL = [_request URLForPath:@"notifications/:id" identifiers:@[ @[ @(2), @(3), @(4) ] ] params:nil];
    XCTAssertTrue([[URL absoluteString] isEqualToString:MAKE_URL(@"/notifications/2,3,4")]);
}





@end
