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
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.name"]										isEqualToString:@"Nathan"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[0].name"]							isEqualToString:@"adam"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[1].name"]							isEqualToString:@"amanda"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[2].name"]							isEqualToString:@"andrew"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].name"]						isEqualToString:@"adam"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[last].name"]						isEqualToString:@"andrew"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[0].title"]	isEqualToString:@"macbook"],	nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[1].title"]	isEqualToString:@"mac mini"],	nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[2].title"]	isEqualToString:@"iphone"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[first].apple_products[last].title"] isEqualToString:@"iphone"],		nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[last].title"]	isEqualToString:@"ipod touch"], nil);
	STAssertTrue([[_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[last].price"]	isEqualToNumber:@399.99],		nil);

	STAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[10].price"], nil);
	STAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products[-1].price"], nil);
	STAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].samsung_products.price"], nil);
	STAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].samsung_products[10]"], nil);
	STAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].samsung_products[10].price"], nil);
	STAssertNil([_testDictionary valueForComplexKeyPath:@"parent.children[last].apple_products.dogs[first]"], nil);
}

- (void)test_valueForComplexKeyPathOnObject
{
	NSError *error = [NSError errorWithDomain:@"YO" code:200 userInfo: @{ @"array" : @[ _testDictionary, @1 ] } ];
	STAssertTrue([[error valueForComplexKeyPath:@"userInfo.array[first].parent.children[last].apple_products[last].title"] isEqualToString:@"ipod touch"], nil);
}

- (void)test_dictionaryWithJSONSafeObjects
{
	NSDictionary *safeDictionary = [_testDictionary objectWithJSONSafeObjects];
	STAssertNoThrow([NSJSONSerialization dataWithJSONObject:safeDictionary options:0 error:nil], nil);
}

- (void)test_stringForKey
{
	STAssertTrue([[_testDictionary stringValueForComplexKeyPath:@"parent.children[last].apple_products[last].date_bought"] isKindOfClass:[NSString class]], nil);
	STAssertTrue([[_testDictionary stringValueForComplexKeyPath:@"parent.children[last].apple_products[last].price"] isKindOfClass:[NSString class]], nil);
}

@end
