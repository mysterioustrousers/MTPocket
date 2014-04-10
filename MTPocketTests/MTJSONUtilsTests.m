//
//  MTJSONUtilsTests.m
//  MTJSONUtilsTests
//
//  Created by Adam Kirk on 8/16/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTJSONUtilsTests.h"
#import "NSObject+MTJSONUtils.h"



@implementation MTJSONUtilsTests

- (void)setUp
{
	_testDictionary = @{
		@"parent" : @{
			@"name" : @"Nathan",
			@"children" : @[ @{
				@"name" : @"adam",
				@"apple_products" : @[ @{
					@"title"		: @"macbook",
					@"price"		: @1399.99,
					@"date_bought"	: [NSDate dateWithTimeInterval:-22342 sinceDate:[NSDate date]],
					@"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
				},
				@{
					@"title"		: @"mac mini",
					@"price"		: @599.99,
					@"date_bought"	: [NSDate dateWithTimeInterval:-30223 sinceDate:[NSDate date]],
					@"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
				},
				@{
					@"title"		: @"iphone",
					@"price"		: @199.99,
					@"date_bought"	: [NSDate dateWithTimeInterval:-123453 sinceDate:[NSDate date]],
					@"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
				}]
			},
			@{
				@"name" : @"amanda",
				@"apple_products" : @[ @{
					@"title"		: @"nano",
					@"price"		: @299.99,
					@"date_bought"	: [NSDate dateWithTimeInterval:-123453 sinceDate:[NSDate date]],
					@"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
				}]
			},
			@{
				@"name" : @"andrew",
				@"apple_products" : @[ @{
					@"title"		: @"ipad",
					@"price"		: @499.99,
					@"date_bought"	: [NSDate dateWithTimeInterval:-2452342 sinceDate:[NSDate date]],
					@"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
				},
				@{
					@"title"		: @"ipod touch",
					@"price"		: @399.99,
					@"date_bought"	: [NSDate dateWithTimeInterval:-430223 sinceDate:[NSDate date]],
					@"colors"		: [NSSet setWithArray:@[ @"blue", @"green", @"yellow"]]
				}]
			}]
		}
	};

    [super setUp];
}

- (void)test_valueForComplexKeyPath
{
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.name"]										isEqualToString:@"Nathan"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[0].name"]							isEqualToString:@"adam"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[1].name"]							isEqualToString:@"amanda"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[2].name"]							isEqualToString:@"andrew"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].name"]						isEqualToString:@"adam"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[last].name"]						isEqualToString:@"andrew"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[0].title"]	isEqualToString:@"macbook"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[1].title"]	isEqualToString:@"mac mini"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[2].title"]	isEqualToString:@"iphone"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[last].title"] isEqualToString:@"iphone"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[last].title"]	isEqualToString:@"ipod touch"]);
	XCTAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[last].price"]	isEqualToNumber:@399.99]);

	XCTAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[10].price"]);
	XCTAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[-1].price"]);
	XCTAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].samsung_products.price"]);
	XCTAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].samsung_products[10]"]);
	XCTAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].samsung_products[10].price"]);
	XCTAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products.dogs[first]"]);
}

- (void)test_valueForComplexKeyPathOnObject
{
	NSError *error = [NSError errorWithDomain:@"YO" code:200 userInfo: @{ @"array" : @[ _testDictionary, @1 ] } ];
	XCTAssertTrue([[error valueForComplexKeyPath:@"userInfo.array[first].parent.children[last].apple_products[last].title"] isEqualToString:@"ipod touch"]);
}

- (void)test_dictionaryWithJSONSafeObjects
{
	NSDictionary *safeDictionary = [_testDictionary objectWithJSONSafeObjects];
	XCTAssertNoThrow([NSJSONSerialization dataWithJSONObject:safeDictionary options:0 error:nil]);
}

- (void)test_stringForKey
{
	XCTAssertTrue([[_testDictionary stringValueForComplexKeyPath:@"parent.children[last].apple_products[last].date_bought"] isKindOfClass:[NSString class]]);
	XCTAssertTrue([[_testDictionary stringValueForComplexKeyPath:@"parent.children[last].apple_products[last].price"] isKindOfClass:[NSString class]]);
}

@end
